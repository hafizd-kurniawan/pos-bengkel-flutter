import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';
import 'package:pos_bengkel/features/servis/providers/service_job_provider.dart';
import 'package:pos_bengkel/shared/models/service_job.dart';

class CreateServiceJobDialog extends StatefulWidget {
  final VoidCallback onServiceJobCreated;

  const CreateServiceJobDialog({
    super.key,
    required this.onServiceJobCreated,
  });

  @override
  State<CreateServiceJobDialog> createState() => _CreateServiceJobDialogState();
}

class _CreateServiceJobDialogState extends State<CreateServiceJobDialog> {
  final _formKey = GlobalKey<FormState>();
  final _complaintController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _estimatedCostController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedStatus = 'Pending';

  final List<String> _statusOptions = [
    'Pending',
    'In Progress',
    'Completed',
    'Cancelled',
  ];

  @override
  void dispose() {
    _complaintController.dispose();
    _diagnosisController.dispose();
    _estimatedCostController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );

      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
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
      status: _selectedStatus,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = await provider.createServiceJob(serviceJob);

    if (success && mounted) {
      Navigator.pop(context);
      widget.onServiceJobCreated();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Service job ${serviceJob.serviceCode} berhasil dibuat'),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Gagal membuat service job'),
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
                    Iconsax.setting_2,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Buat Service Job Baru',
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
                      // Service Date
                      InkWell(
                        onTap: _selectDate,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Iconsax.calendar,
                                  color: AppColors.primary),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tanggal Service *',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} ${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const Icon(Iconsax.arrow_right_3,
                                  color: AppColors.textTertiary),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Complaint
                      TextFormField(
                        controller: _complaintController,
                        decoration: const InputDecoration(
                          labelText: 'Keluhan Customer *',
                          hintText: 'Jelaskan keluhan dari customer',
                          prefixIcon: Icon(Iconsax.message_text),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Keluhan tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Diagnosis
                      TextFormField(
                        controller: _diagnosisController,
                        decoration: const InputDecoration(
                          labelText: 'Diagnosis Awal',
                          hintText: 'Diagnosis awal masalah (opsional)',
                          prefixIcon: Icon(Iconsax.health),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      // Estimated Cost & Status
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _estimatedCostController,
                              decoration: const InputDecoration(
                                labelText: 'Estimasi Biaya *',
                                prefixIcon: Icon(Iconsax.money_recive),
                                prefixText: 'Rp ',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Estimasi biaya tidak boleh kosong';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Format tidak valid';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedStatus,
                              decoration: const InputDecoration(
                                labelText: 'Status *',
                                prefixIcon: Icon(Iconsax.status),
                              ),
                              items: _statusOptions.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedStatus = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Notes
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Catatan',
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
                            : const Text('Buat Service Job'),
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
