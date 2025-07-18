import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';
import 'package:pos_bengkel/features/kasir/providers/customer_vehicle_provider.dart';
import 'package:pos_bengkel/features/kasir/widgets/vehicle_detail_dialog.dart';
import 'package:pos_bengkel/shared/models/customer_vehicle.dart';

class VehicleSelectionDialog extends StatefulWidget {
  final String customerId;
  final Function(CustomerVehicle) onVehicleSelected;

  const VehicleSelectionDialog({
    super.key,
    required this.customerId,
    required this.onVehicleSelected,
  });

  @override
  State<VehicleSelectionDialog> createState() => _VehicleSelectionDialogState();
}

class _VehicleSelectionDialogState extends State<VehicleSelectionDialog> {
  @override
  void initState() {
    super.initState();
    debugPrint(
        '🚗 VehicleSelectionDialog initialized for customer: ${widget.customerId}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('🔄 Loading vehicles for customer: ${widget.customerId}');
      context
          .read<CustomerVehicleProvider>()
          .loadVehiclesByCustomerId(widget.customerId);
    });
  }

  void _showAddVehicleDialog() {
    showDialog(
      context: context,
      builder: (context) => AddVehicleDialog(
        customerId: widget.customerId,
        onVehicleAdded: (vehicle) {
          widget.onVehicleSelected(vehicle);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showVehicleDetail(CustomerVehicle vehicle) {
    showDialog(
      context: context,
      builder: (context) => VehicleDetailDialog(
        vehicle: vehicle,
        onEdit: () {
          // TODO: Implement edit functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fitur edit akan segera tersedia'),
              backgroundColor: AppColors.info,
            ),
          );
        },
        onDelete: () {
          // TODO: Implement delete functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fitur hapus akan segera tersedia'),
              backgroundColor: AppColors.warning,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Pilih Kendaraan',
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
            const SizedBox(height: 16),

            // Debug Info (temporary)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Customer ID: ${widget.customerId}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.info,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Vehicle List
            Expanded(
              child: Consumer<CustomerVehicleProvider>(
                builder: (context, vehicleProvider, _) {
                  debugPrint(
                      '🔄 Building vehicle list: isLoading=${vehicleProvider.isLoading}, vehicleCount=${vehicleProvider.customerVehicles.length}');

                  if (vehicleProvider.isLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Memuat kendaraan...'),
                        ],
                      ),
                    );
                  }

                  if (vehicleProvider.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Iconsax.warning_2,
                            size: 64,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${vehicleProvider.errorMessage}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              vehicleProvider
                                  .loadVehiclesByCustomerId(widget.customerId);
                            },
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  final vehicles = vehicleProvider.customerVehicles;
                  debugPrint('📋 Displaying ${vehicles.length} vehicles');

                  if (vehicles.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Iconsax.car,
                            size: 64,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Customer belum memiliki kendaraan',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Customer ID: ${widget.customerId}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _showAddVehicleDialog,
                            icon: const Icon(Iconsax.car),
                            label: const Text('Tambah Kendaraan'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = vehicles[index];
                      debugPrint(
                          '🚗 Building vehicle item $index: ${vehicle.displayName}');

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.info.withOpacity(0.1),
                            child: const Icon(
                              Iconsax.car,
                              color: AppColors.info,
                            ),
                          ),
                          title: Text(
                            vehicle.displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${vehicle.type} - ${vehicle.color}'),
                              Text('Tahun ${vehicle.productionYear}'),
                              // Status badge
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(vehicle.status)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  vehicle.status,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: _getStatusColor(vehicle.status),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Detail button
                              IconButton(
                                onPressed: () => _showVehicleDetail(vehicle),
                                icon: const Icon(
                                  Iconsax.eye,
                                  color: AppColors.info,
                                ),
                                tooltip: 'Lihat Detail',
                                padding: const EdgeInsets.all(4),
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                              ),
                              // Select button
                              IconButton(
                                onPressed: () {
                                  debugPrint(
                                      '✅ Vehicle selected: ${vehicle.displayName}');
                                  widget.onVehicleSelected(vehicle);
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Iconsax.tick_circle,
                                  color: AppColors.success,
                                ),
                                tooltip: 'Pilih Kendaraan',
                                padding: const EdgeInsets.all(4),
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            debugPrint(
                                '✅ Vehicle selected: ${vehicle.displayName}');
                            widget.onVehicleSelected(vehicle);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Add Vehicle Button
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showAddVehicleDialog,
                icon: const Icon(Iconsax.car),
                label: const Text('Tambah Kendaraan Baru'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
        return AppColors.success;
      case 'tidak aktif':
        return AppColors.error;
      case 'maintenance':
        return AppColors.warning;
      default:
        return AppColors.textTertiary;
    }
  }
}

// AddVehicleDialog tetap sama seperti sebelumnya
class AddVehicleDialog extends StatefulWidget {
  final String customerId;
  final Function(CustomerVehicle) onVehicleAdded;

  const AddVehicleDialog({
    super.key,
    required this.customerId,
    required this.onVehicleAdded,
  });

  @override
  State<AddVehicleDialog> createState() => _AddVehicleDialogState();
}

class _AddVehicleDialogState extends State<AddVehicleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _plateController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _engineController = TextEditingController();
  final _chassisController = TextEditingController();
  final _colorController = TextEditingController();

  String _selectedType = 'Motor';

  @override
  void dispose() {
    _plateController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _engineController.dispose();
    _chassisController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final vehicle = CustomerVehicle(
      customerId: widget.customerId,
      plateNumber: _plateController.text.trim(),
      type: _selectedType,
      brand: _brandController.text.trim(),
      model: _modelController.text.trim(),
      productionYear: int.parse(_yearController.text.trim()),
      engineNumber: _engineController.text.trim(),
      chassisNumber: _chassisController.text.trim(),
      color: _colorController.text.trim(),
      status: 'Aktif',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final vehicleProvider = context.read<CustomerVehicleProvider>();
    final success = await vehicleProvider.createVehicle(vehicle);

    if (success && mounted) {
      final createdVehicle = vehicleProvider.customerVehicles.first;
      widget.onVehicleAdded(createdVehicle);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Kendaraan ${vehicle.displayName} berhasil ditambahkan'),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              vehicleProvider.errorMessage ?? 'Gagal menambahkan kendaraan'),
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
        width: 500,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Tambah Kendaraan Baru',
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

                // Customer ID info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Iconsax.user, color: AppColors.info, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Customer ID: ${widget.customerId}',
                        style: const TextStyle(
                          color: AppColors.info,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Plate Number
                TextFormField(
                  controller: _plateController,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Plat *',
                    prefixIcon: Icon(Iconsax.car),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nomor plat tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Type
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Jenis Kendaraan *',
                    prefixIcon: Icon(Iconsax.category),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Motor', child: Text('Motor')),
                    DropdownMenuItem(value: 'Mobil', child: Text('Mobil')),
                    DropdownMenuItem(value: 'Truk', child: Text('Truk')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedType = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Brand & Model
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _brandController,
                        decoration: const InputDecoration(
                          labelText: 'Merk *',
                          prefixIcon: Icon(Iconsax.tag),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Merk tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _modelController,
                        decoration: const InputDecoration(
                          labelText: 'Model *',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Model tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Year & Color
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _yearController,
                        decoration: const InputDecoration(
                          labelText: 'Tahun *',
                          prefixIcon: Icon(Iconsax.calendar),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Tahun tidak boleh kosong';
                          }
                          final year = int.tryParse(value);
                          if (year == null ||
                              year < 1900 ||
                              year > DateTime.now().year + 1) {
                            return 'Tahun tidak valid';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _colorController,
                        decoration: const InputDecoration(
                          labelText: 'Warna *',
                          prefixIcon: Icon(Iconsax.colorfilter),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Warna tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Engine Number
                TextFormField(
                  controller: _engineController,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Mesin *',
                    prefixIcon: Icon(Iconsax.setting),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nomor mesin tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Chassis Number
                TextFormField(
                  controller: _chassisController,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Rangka *',
                    prefixIcon: Icon(Iconsax.code),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nomor rangka tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Buttons
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
                      child: Consumer<CustomerVehicleProvider>(
                        builder: (context, vehicleProvider, _) {
                          return ElevatedButton(
                            onPressed: vehicleProvider.isLoading
                                ? null
                                : _handleSubmit,
                            child: vehicleProvider.isLoading
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
        ),
      ),
    );
  }
}
