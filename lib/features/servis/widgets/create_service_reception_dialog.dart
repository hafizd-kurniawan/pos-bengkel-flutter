import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';
import 'package:pos_bengkel/features/servis/providers/service_job_provider.dart';
import 'package:pos_bengkel/features/kasir/providers/customer_provider.dart';
import 'package:pos_bengkel/features/kasir/providers/customer_vehicle_provider.dart';
import 'package:pos_bengkel/shared/models/service_job.dart';
import 'package:pos_bengkel/shared/models/customer.dart';
import 'package:pos_bengkel/shared/models/customer_vehicle.dart';

class CreateServiceReceptionDialog extends StatefulWidget {
  final VoidCallback onServiceJobCreated;

  const CreateServiceReceptionDialog({
    super.key,
    required this.onServiceJobCreated,
  });

  @override
  State<CreateServiceReceptionDialog> createState() =>
      _CreateServiceReceptionDialogState();
}

class _CreateServiceReceptionDialogState
    extends State<CreateServiceReceptionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _complaintController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _estimatedCostController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedServiceType = 'Datang Langsung';
  Customer? _selectedCustomer;
  CustomerVehicle? _selectedVehicle;

  final List<String> _serviceTypes = [
    'Datang Langsung',
    'Booking',
    'Emergency',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerProvider>().loadCustomers();
    });
  }

  @override
  void dispose() {
    _complaintController.dispose();
    _diagnosisController.dispose();
    _estimatedCostController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih customer terlebih dahulu'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedVehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih kendaraan terlebih dahulu'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final provider = context.read<ServiceJobProvider>();

    final serviceJob = ServiceJob(
      serviceCode: provider.nextServiceCode,
      customerId: _selectedCustomer!.customerId.toString(),
      vehicleId: _selectedVehicle!.vehicleId.toString(),
      userId: '1', // hafizd-kurniawan user ID
      outletId: '1', // Default outlet ID
      serviceDate: _selectedDate,
      complaint: _complaintController.text.trim(),
      diagnosis: _diagnosisController.text.trim().isNotEmpty
          ? _diagnosisController.text.trim()
          : null,
      estimatedCost:
          double.tryParse(_estimatedCostController.text.trim()) ?? 0.0,
      actualCost: 0.0,
      status: 'Pending',
      notes: _notesController.text.trim().isNotEmpty
          ? 'Tipe Servis: $_selectedServiceType. ${_notesController.text.trim()}'
          : 'Tipe Servis: $_selectedServiceType',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = await provider.createServiceJob(serviceJob);

    if (success && mounted) {
      Navigator.pop(context);
      widget.onServiceJobCreated();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Data servis masuk ${serviceJob.serviceCode} berhasil ditambahkan'),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(provider.errorMessage ?? 'Gagal menambahkan data servis'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 600,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Iconsax.clipboard_text,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Data Servis Masuk',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Service Code Display
            Consumer<ServiceJobProvider>(
              builder: (context, provider, _) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Iconsax.code, color: AppColors.info, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Service Code: ${provider.nextServiceCode}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Form
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Customer Selection
                      Consumer<CustomerProvider>(
                        builder: (context, customerProvider, _) {
                          return DropdownButtonFormField<Customer>(
                            value: _selectedCustomer,
                            decoration: const InputDecoration(
                              labelText: 'Pilih Customer *',
                              prefixIcon: Icon(Iconsax.user),
                            ),
                            hint: const Text('Pilih customer'),
                            items: customerProvider.customers.map((customer) {
                              return DropdownMenuItem<Customer>(
                                value: customer,
                                child: Text('${customer.name} (${customer.phoneNumber})'),
                              );
                            }).toList(),
                            onChanged: (customer) {
                              setState(() {
                                _selectedCustomer = customer;
                                _selectedVehicle = null; // Reset vehicle selection
                              });
                              if (customer != null) {
                                // Load vehicles for selected customer
                                context.read<CustomerVehicleProvider>().loadVehiclesByCustomerId(customer.customerId.toString());
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Silakan pilih customer';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Vehicle Selection
                      if (_selectedCustomer != null)
                        Consumer<CustomerVehicleProvider>(
                          builder: (context, vehicleProvider, _) {
                            if (vehicleProvider.isLoading) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.border),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                    SizedBox(width: 12),
                                    Text('Memuat kendaraan...'),
                                  ],
                                ),
                              );
                            }
                            
                            if (vehicleProvider.errorMessage != null) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.error),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error, color: AppColors.error),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Error: ${vehicleProvider.errorMessage}',
                                        style: const TextStyle(color: AppColors.error),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            
                            return DropdownButtonFormField<CustomerVehicle>(
                              value: _selectedVehicle,
                              decoration: const InputDecoration(
                                labelText: 'Pilih Kendaraan *',
                                prefixIcon: Icon(Iconsax.car),
                              ),
                              hint: Text(vehicleProvider.customerVehicles.isEmpty 
                                  ? 'Tidak ada kendaraan untuk customer ini' 
                                  : 'Pilih kendaraan customer'),
                              items: vehicleProvider.customerVehicles.map((vehicle) {
                                return DropdownMenuItem<CustomerVehicle>(
                                  value: vehicle,
                                  child: Text('${vehicle.plateNumber} - ${vehicle.brand} ${vehicle.model}'),
                                );
                              }).toList(),
                              onChanged: vehicleProvider.customerVehicles.isEmpty ? null : (vehicle) {
                                setState(() {
                                  _selectedVehicle = vehicle;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Silakan pilih kendaraan';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                      if (_selectedCustomer != null)
                        const SizedBox(height: 16),

                      // Service Type
                      DropdownButtonFormField<String>(
                        value: _selectedServiceType,
                        decoration: const InputDecoration(
                          labelText: 'Tipe Servis *',
                          prefixIcon: Icon(Iconsax.setting_2),
                        ),
                        items: _serviceTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedServiceType = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Complaint/Damage
                      TextFormField(
                        controller: _complaintController,
                        decoration: const InputDecoration(
                          labelText: 'Kerusakan/Keluhan *',
                          hintText: 'Input Kerusakan Kendaraan',
                          prefixIcon: Icon(Iconsax.warning_2),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Kerusakan/Keluhan tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Diagnosis
                      TextFormField(
                        controller: _diagnosisController,
                        decoration: const InputDecoration(
                          labelText: 'Kondisi Kendaraan Masuk',
                          hintText: 'Contoh: Kondisi Nyala',
                          prefixIcon: Icon(Iconsax.status),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      // Estimated Cost
                      TextFormField(
                        controller: _estimatedCostController,
                        decoration: const InputDecoration(
                          labelText: 'Estimasi Biaya *',
                          hintText: 'Input estimasi biaya servis',
                          prefixIcon: Icon(Iconsax.money_recive),
                          prefixText: 'Rp ',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            final cost = double.tryParse(value.trim());
                            if (cost == null || cost < 0) {
                              return 'Masukkan nilai yang valid';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Notes
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Keterangan/Catatan',
                          hintText: 'Catatan tambahan (opsional)',
                          prefixIcon: Icon(Iconsax.note),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Consumer<ServiceJobProvider>(
                    builder: (context, provider, _) {
                      return ElevatedButton(
                        onPressed: provider.isLoading ? null : _handleSubmit,
                        child: provider.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Simpan'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
