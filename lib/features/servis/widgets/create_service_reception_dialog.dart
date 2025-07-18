import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';
import 'package:pos_bengkel/features/servis/providers/service_job_provider.dart';
import 'package:pos_bengkel/shared/models/service_job.dart';

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

  final List<String> _serviceTypes = [
    'Datang Langsung',
    'Booking',
    'Emergency',
  ];

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

    final provider = context.read<ServiceJobProvider>();

    final serviceJob = ServiceJob(
      serviceCode: provider.nextServiceCode,
      customerId: '1', // Default customer ID
      vehicleId: '1', // Default vehicle ID
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
                          labelText: 'Estimasi Biaya',
                          hintText: 'Input estimasi biaya servis',
                          prefixIcon: Icon(Iconsax.money_recive),
                          prefixText: 'Rp ',
                        ),
                        keyboardType: TextInputType.number,
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
