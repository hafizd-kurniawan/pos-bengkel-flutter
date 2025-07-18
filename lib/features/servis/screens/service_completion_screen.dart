import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';
import 'package:pos_bengkel/core/utils/currency_formatter.dart';
import 'package:pos_bengkel/core/utils/date_formatter.dart';
import 'package:pos_bengkel/features/servis/providers/service_job_provider.dart';
import 'package:pos_bengkel/features/servis/widgets/create_service_job_dialog.dart';
import 'package:pos_bengkel/shared/models/service_job.dart';

class ServiceCompletionScreen extends StatefulWidget {
  const ServiceCompletionScreen({super.key});

  @override
  State<ServiceCompletionScreen> createState() => _ServiceCompletionScreenState();
}

class _ServiceCompletionScreenState extends State<ServiceCompletionScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedEntriesPerPage = 10;
  int _currentPage = 1;

  final List<String> _statusOptions = [
    'Completed',
    'Ready for Pickup',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load only completed service jobs
      context.read<ServiceJobProvider>().loadServiceJobs(status: 'Completed');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCompletionDialog(ServiceJob serviceJob) {
    // TODO: Create service completion dialog for finalizing pickup
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur finalisasi pengambilan akan segera tersedia'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header with Add Button
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pengambilan Setelah Servis',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Kelola pengambilan kendaraan yang sudah selesai servis',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Refresh completed services
                        context.read<ServiceJobProvider>().loadServiceJobs(status: 'Completed');
                      },
                      icon: const Icon(Iconsax.refresh),
                      label: const Text('Refresh Data'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Status Filter
                Consumer<ServiceJobProvider>(
                  builder: (context, provider, _) {
                    return Row(
                      children: [
                        const Text(
                          'Filter Status: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ...List.generate(_statusOptions.length, (index) {
                          final status = _statusOptions[index];
                          final isSelected = provider.selectedStatus == status || 
                                           (provider.selectedStatus == 'Semua' && status == 'Completed');

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(status),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  // Map UI status to API status
                                  String apiStatus = status == 'Ready for Pickup' ? 'Completed' : status;
                                  provider.setSelectedStatus(apiStatus);
                                }
                              },
                              selectedColor: AppColors.primary.withOpacity(0.2),
                              checkmarkColor: AppColors.primary,
                            ),
                          );
                        }),
                        const Spacer(),

                        // Quick Stats
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.info.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Iconsax.setting_2,
                                  size: 16, color: AppColors.info),
                              const SizedBox(width: 6),
                              Text(
                                'Total: ${provider.serviceJobs.length}',
                                style: const TextStyle(
                                  color: AppColors.info,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                child: Column(
                  children: [
                    // Table Controls
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.border),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Show entries dropdown
                          Row(
                            children: [
                              const Text('Show '),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.border),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: DropdownButton<int>(
                                  value: _selectedEntriesPerPage,
                                  underline: const SizedBox(),
                                  items: [10, 25, 50, 100].map((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text(value.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (int? value) {
                                    if (value != null) {
                                      setState(() {
                                        _selectedEntriesPerPage = value;
                                        _currentPage = 1;
                                      });
                                      context
                                          .read<ServiceJobProvider>()
                                          .loadServiceJobs(
                                            limit: value,
                                            page: 1,
                                          );
                                    }
                                  },
                                ),
                              ),
                              const Text(' entries'),
                            ],
                          ),
                          const Spacer(),
                          // Search
                          Row(
                            children: [
                              const Text('Search: '),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 200,
                                child: TextFormField(
                                  controller: _searchController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    isDense: true,
                                  ),
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      context
                                          .read<ServiceJobProvider>()
                                          .loadServiceJobs();
                                    }
                                  },
                                  onFieldSubmitted: (_) {
                                    final query = _searchController.text.trim();
                                    if (query.isNotEmpty) {
                                      context
                                          .read<ServiceJobProvider>()
                                          .loadServiceJobs(search: query);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Data Table
                    Expanded(
                      child: Consumer<ServiceJobProvider>(
                        builder: (context, provider, _) {
                          if (provider.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (provider.errorMessage != null) {
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
                                    'Error: ${provider.errorMessage}',
                                    style: const TextStyle(
                                      color: AppColors.error,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => provider.loadServiceJobs(),
                                    child: const Text('Coba Lagi'),
                                  ),
                                ],
                              ),
                            );
                          }

                          final serviceJobs = provider.serviceJobs;

                          if (serviceJobs.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Iconsax.tick_circle,
                                    size: 64,
                                    color: AppColors.textTertiary,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Belum ada servis yang siap diambil',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Servis yang sudah selesai akan muncul di sini',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      context.read<ServiceJobProvider>().loadServiceJobs(status: 'Completed');
                                    },
                                    icon: const Icon(Iconsax.refresh),
                                    label: const Text('Refresh Data'),
                                  ),
                                ],
                              ),
                            );
                          }

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 16,
                              horizontalMargin: 16,
                              columns: const [
                                DataColumn(label: Text('No.')),
                                DataColumn(label: Text('Service Code')),
                                DataColumn(label: Text('Customer')),
                                DataColumn(label: Text('No. Pol')),
                                DataColumn(label: Text('Kendaraan')),
                                DataColumn(label: Text('Total Biaya')),
                                DataColumn(label: Text('Tanggal Selesai')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Aksi')),
                              ],
                              rows: List.generate(
                                serviceJobs.length,
                                (index) => _buildDataRow(
                                  index + 1,
                                  serviceJobs[index],
                                  provider,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(
    int number,
    ServiceJob serviceJob,
    ServiceJobProvider provider,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(number.toString())),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              serviceJob.serviceCode,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.info,
              ),
            ),
          ),
        ),
        DataCell(Text(serviceJob.customerName)),
        DataCell(
          Text(
            serviceJob.plateNumber,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
        DataCell(Text(serviceJob.vehicleInfo)),
        DataCell(
          Text(
            CurrencyFormatter.format(serviceJob.actualCost > 0 ? serviceJob.actualCost : serviceJob.estimatedCost),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ),
        DataCell(
          Text(
            DateFormatter.formatDate(serviceJob.updatedAt),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Siap Diambil',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => _showDetailDialog(serviceJob),
                icon: const Icon(Iconsax.eye, size: 18),
                tooltip: 'Lihat Detail',
                color: AppColors.info,
              ),
              IconButton(
                onPressed: () => _showCostBreakdownDialog(serviceJob),
                icon: const Icon(Iconsax.receipt_text, size: 18),
                tooltip: 'Rincian Biaya',
                color: AppColors.warning,
              ),
              IconButton(
                onPressed: () => _showPickupDialog(serviceJob, provider),
                icon: const Icon(Iconsax.tick_circle, size: 18),
                tooltip: 'Finalisasi Pengambilan',
                color: AppColors.success,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.success;
      case 'ready for pickup':
        return AppColors.info;
      default:
        return AppColors.success; // Default to success since we only show completed services
    }
  }

  void _showDetailDialog(ServiceJob serviceJob) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Service'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Service Code:', serviceJob.serviceCode),
              _buildDetailRow('Customer:', serviceJob.customerName),
              _buildDetailRow('No. Polisi:', serviceJob.plateNumber),
              _buildDetailRow('Kendaraan:', serviceJob.vehicleInfo),
              _buildDetailRow('Keluhan:', serviceJob.complaint),
              if (serviceJob.diagnosis != null)
                _buildDetailRow('Diagnosis:', serviceJob.diagnosis!),
              _buildDetailRow('Estimasi Biaya:',
                  CurrencyFormatter.format(serviceJob.estimatedCost)),
              _buildDetailRow('Biaya Aktual:',
                  CurrencyFormatter.format(serviceJob.actualCost)),
              _buildDetailRow('Status:', serviceJob.status),
              _buildDetailRow('Service Date:',
                  DateFormatter.formatDateTime(serviceJob.serviceDate)),
              if (serviceJob.notes != null && serviceJob.notes!.isNotEmpty)
                _buildDetailRow('Catatan:', serviceJob.notes!),
              _buildDetailRow('Selesai:',
                  DateFormatter.formatDateTime(serviceJob.updatedAt)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showCostBreakdownDialog(ServiceJob serviceJob) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Iconsax.receipt_text, color: AppColors.warning),
            SizedBox(width: 8),
            Text('Rincian Biaya'),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Service Code: ${serviceJob.serviceCode}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                // Service Details Table
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Expanded(flex: 3, child: Text('Deskripsi', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(flex: 1, child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text('Harga', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                      
                      // TODO: Replace with actual service details from API
                      Container(
                        padding: const EdgeInsets.all(12),
                        child: const Row(
                          children: [
                            Expanded(flex: 3, child: Text('Service & Parts')),
                            Expanded(flex: 1, child: Text('1')),
                            Expanded(flex: 2, child: Text('-')),
                            Expanded(flex: 2, child: Text('-')),
                          ],
                        ),
                      ),
                      
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Expanded(flex: 6, child: Text('Total Biaya:', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(
                              flex: 2, 
                              child: Text(
                                CurrencyFormatter.format(serviceJob.actualCost > 0 ? serviceJob.actualCost : serviceJob.estimatedCost),
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Detail rincian biaya akan ditampilkan setelah integrasi dengan service details API.',
                    style: TextStyle(color: AppColors.info, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showPickupDialog(ServiceJob serviceJob, ServiceJobProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Iconsax.tick_circle, color: AppColors.success),
            SizedBox(width: 8),
            Text('Finalisasi Pengambilan'),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Konfirmasi pengambilan kendaraan:'),
            const SizedBox(height: 8),
            Text('• No. Polisi: ${serviceJob.plateNumber}', style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('• Customer: ${serviceJob.customerName}'),
            Text('• Total Biaya: ${CurrencyFormatter.format(serviceJob.actualCost > 0 ? serviceJob.actualCost : serviceJob.estimatedCost)}'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Setelah dikonfirmasi, status akan berubah menjadi "Diambil" dan kendaraan dianggap telah diserahkan kepada customer.',
                style: TextStyle(color: AppColors.warning, fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              // TODO: Implement pickup finalization
              // This would call: PUT /api/v1/service-jobs/{id} with status "Picked Up"
              if (serviceJob.serviceJobId != null) {
                final success = await provider.updateServiceJobStatus(
                  serviceJob.serviceJobId!,
                  'Picked Up',
                  'Kendaraan telah diambil customer pada ${DateTime.now()}',
                );
                
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pengambilan kendaraan berhasil dikonfirmasi'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  // Refresh the list to remove picked up items
                  context.read<ServiceJobProvider>().loadServiceJobs(status: 'Completed');
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal konfirmasi: ${provider.errorMessage ?? 'Error tidak diketahui'}'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ID service job tidak valid'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('Konfirmasi Pengambilan'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateStatus(ServiceJob serviceJob, String newStatus,
      ServiceJobProvider provider) async {
    if (serviceJob.serviceJobId != null) {
      final success = await provider.updateServiceJobStatus(
        serviceJob.serviceJobId!,
        newStatus,
        'Status updated to $newStatus',
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status berhasil diubah ke $newStatus'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  void _showEditDialog(ServiceJob serviceJob) {
    // TODO: Implement edit dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur edit akan segera tersedia'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showDeleteDialog(ServiceJob serviceJob, ServiceJobProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Iconsax.warning_2, color: AppColors.error),
            SizedBox(width: 8),
            Text('Konfirmasi Hapus'),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus service job ${serviceJob.serviceCode}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              if (serviceJob.serviceJobId != null) {
                final success =
                    await provider.deleteServiceJob(serviceJob.serviceJobId!);
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Service job berhasil dihapus'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
