import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';
import 'package:pos_bengkel/core/utils/currency_formatter.dart';
import 'package:pos_bengkel/core/utils/date_formatter.dart';
import 'package:pos_bengkel/features/servis/providers/service_job_provider.dart';
import 'package:pos_bengkel/features/servis/widgets/create_service_reception_dialog.dart';
import 'package:pos_bengkel/shared/models/service_job.dart';

class ServiceReceptionScreen extends StatefulWidget {
  const ServiceReceptionScreen({super.key});

  @override
  State<ServiceReceptionScreen> createState() => _ServiceReceptionScreenState();
}

class _ServiceReceptionScreenState extends State<ServiceReceptionScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedEntriesPerPage = 10;
  int _currentPage = 1;

  final List<String> _statusOptions = [
    'Semua',
    'Pending',
    'In Progress',
    'Completed',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceJobProvider>().loadServiceJobs();
      context.read<ServiceJobProvider>().loadNextServiceCode();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CreateServiceReceptionDialog(
        onServiceJobCreated: () {
          context.read<ServiceJobProvider>().loadServiceJobs();
        },
      ),
    );
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<ServiceJobProvider>().loadServiceJobs(search: query);
    } else {
      context.read<ServiceJobProvider>().loadServiceJobs();
    }
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
                            'Penerimaan Servis',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Kelola penerimaan kendaraan untuk servis',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showCreateDialog,
                      icon: const Icon(Iconsax.add),
                      label: const Text('Data Servis Masuk'),
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
                          final isSelected = provider.selectedStatus == status;

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(status),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  provider.setSelectedStatus(status);
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
                              const Icon(Iconsax.clipboard_text,
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
                                  onFieldSubmitted: (_) => _performSearch(),
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
                                    Iconsax.clipboard_text,
                                    size: 64,
                                    color: AppColors.textTertiary,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Belum ada data penerimaan servis',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: _showCreateDialog,
                                    icon: const Icon(Iconsax.add),
                                    label: const Text('Tambah Data Servis'),
                                  ),
                                ],
                              ),
                            );
                          }

                          return SingleChildScrollView(
                            child: DataTable(
                              columnSpacing: 16,
                              horizontalMargin: 16,
                              columns: const [
                                DataColumn(label: Text('No.')),
                                DataColumn(label: Text('Service Code')),
                                DataColumn(label: Text('Customer')),
                                DataColumn(label: Text('No. Pol')),
                                DataColumn(label: Text('Kendaraan')),
                                DataColumn(label: Text('Tipe')),
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

                    // Pagination Footer
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.border),
                        ),
                      ),
                      child: Consumer<ServiceJobProvider>(
                        builder: (context, provider, _) {
                          final serviceJobs = provider.serviceJobs;

                          return Row(
                            children: [
                              Text(
                                'Showing ${serviceJobs.isNotEmpty ? 1 : 0} to ${serviceJobs.length} of ${serviceJobs.length} entries',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: _currentPage > 1
                                        ? () {
                                            setState(() {
                                              _currentPage--;
                                            });
                                            provider.loadServiceJobs(
                                              page: _currentPage,
                                              limit: _selectedEntriesPerPage,
                                            );
                                          }
                                        : null,
                                    child: const Text('Previous'),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      _currentPage.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: serviceJobs.length >=
                                            _selectedEntriesPerPage
                                        ? () {
                                            setState(() {
                                              _currentPage++;
                                            });
                                            provider.loadServiceJobs(
                                              page: _currentPage,
                                              limit: _selectedEntriesPerPage,
                                            );
                                          }
                                        : null,
                                    child: const Text('Next'),
                                  ),
                                ],
                              ),
                            ],
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Datang Langsung', // Default service type
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(serviceJob.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _mapStatusToReception(serviceJob.status),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _getStatusColor(serviceJob.status),
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
              if (serviceJob.status == 'Pending')
                IconButton(
                  onPressed: () => _startService(serviceJob, provider),
                  icon: const Icon(Iconsax.play, size: 18),
                  tooltip: 'Mulai Servis',
                  color: AppColors.success,
                ),
              IconButton(
                onPressed: () => _showEditDialog(serviceJob),
                icon: const Icon(Iconsax.edit, size: 18),
                tooltip: 'Edit',
                color: AppColors.warning,
              ),
              IconButton(
                onPressed: () => _showDeleteDialog(serviceJob, provider),
                icon: const Icon(Iconsax.trash, size: 18),
                tooltip: 'Hapus',
                color: AppColors.error,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'in progress':
        return AppColors.info;
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textTertiary;
    }
  }

  String _mapStatusToReception(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Antrian Servis Masuk';
      case 'in progress':
        return 'Sedang Dikerjakan';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  void _showDetailDialog(ServiceJob serviceJob) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Penerimaan Servis'),
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
              if (serviceJob.actualCost > 0)
                _buildDetailRow('Biaya Aktual:',
                    CurrencyFormatter.format(serviceJob.actualCost)),
              _buildDetailRow(
                  'Status:', _mapStatusToReception(serviceJob.status)),
              _buildDetailRow('Service Date:',
                  DateFormatter.formatDateTime(serviceJob.serviceDate)),
              if (serviceJob.notes != null && serviceJob.notes!.isNotEmpty)
                _buildDetailRow('Catatan:', serviceJob.notes!),
              _buildDetailRow('Dibuat:',
                  DateFormatter.formatDateTime(serviceJob.createdAt)),
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

  void _startService(ServiceJob serviceJob, ServiceJobProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Iconsax.play, color: AppColors.success),
            SizedBox(width: 8),
            Text('Mulai Servis'),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin memulai servis untuk kendaraan ${serviceJob.plateNumber}?',
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
                final success = await provider.updateServiceJobStatus(
                  serviceJob.serviceJobId!,
                  'In Progress',
                  'Servis dimulai',
                );
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Servis berhasil dimulai'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('Ya, Mulai Servis'),
          ),
        ],
      ),
    );
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
          'Apakah Anda yakin ingin menghapus data penerimaan servis ${serviceJob.serviceCode}?',
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
                      content: Text('Data berhasil dihapus'),
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
