import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';
import 'package:pos_bengkel/features/master/providers/master_data_provider.dart';
import 'package:pos_bengkel/features/master/providers/export_provider.dart';
import 'package:pos_bengkel/features/master/widgets/master_data_card.dart';
import 'package:pos_bengkel/features/master/widgets/search_filter_bar.dart';
import 'package:pos_bengkel/features/master/widgets/pagination_controls.dart';
import 'package:pos_bengkel/features/master/widgets/data_export_dialog.dart';
import 'package:pos_bengkel/features/master/models/service.dart';

class ServiceMasterScreen extends StatefulWidget {
  const ServiceMasterScreen({super.key});

  @override
  State<ServiceMasterScreen> createState() => _ServiceMasterScreenState();
}

class _ServiceMasterScreenState extends State<ServiceMasterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MasterDataProvider>().loadServices();
    });
  }

  void _showServiceDetail(Service service) {
    showDialog(
      context: context,
      builder: (context) => _ServiceDetailDialog(service: service),
    );
  }

  void _handleExport() {
    final provider = context.read<MasterDataProvider>();
    
    DataExportDialog.show(
      context: context,
      title: 'Data Servis',
      exportOptions: CommonExportOptions.all,
      availableFields: ExportFieldDefinitions.serviceFields,
      onExport: (config) {
        final exportData = provider.services.map((service) => {
          'serviceName': service.serviceName,
          'serviceDescription': service.serviceDescription ?? '-',
          'serviceCost': NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp ',
            decimalDigits: 0,
          ).format(service.serviceCost),
          'category': service.category?.categoryName ?? '-',
          'status': service.status,
        }).toList();

        context.read<ExportProvider>().exportData(
          config: config,
          data: exportData,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header dengan info Read Only
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Iconsax.setting_2,
                      color: AppColors.info,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data Servis',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kelola data layanan servis sistem',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Iconsax.eye, size: 16, color: AppColors.warning),
                        SizedBox(width: 6),
                        Text(
                          'READ ONLY',
                          style: TextStyle(
                            color: AppColors.warning,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Search and Filter Bar
            Consumer<MasterDataProvider>(
              builder: (context, provider, child) {
                return SearchFilterBar(
                  searchHint: 'Cari layanan servis, kategori...',
                  onSearch: provider.searchServices,
                  onExport: _handleExport,
                  onRefresh: provider.loadServices,
                  isLoading: provider.servicesState == LoadingState.loading,
                );
              },
            ),
            const SizedBox(height: 16),

            // Service List
            Expanded(
              child: Consumer<MasterDataProvider>(
                builder: (context, provider, child) {
                  if (provider.servicesState == LoadingState.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (provider.servicesState == LoadingState.error) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Iconsax.close_circle,
                            size: 64,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Gagal memuat data',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.servicesError ?? 'Terjadi kesalahan',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: provider.loadServices,
                            icon: const Icon(Iconsax.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (provider.services.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Iconsax.setting_2,
                            size: 64,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Tidak ada data servis',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.searchQuery.isNotEmpty
                                ? 'Tidak ditemukan layanan dengan kata kunci "${provider.searchQuery}"'
                                : 'Belum ada data layanan servis yang tersedia',
                            style: const TextStyle(
                              color: AppColors.textTertiary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: provider.services.length,
                    itemBuilder: (context, index) {
                      final service = provider.services[index];
                      return MasterDataCard(
                        title: service.serviceName,
                        subtitle: service.serviceDescription,
                        onTap: () => _showServiceDetail(service),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.info.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Iconsax.setting_2,
                            color: AppColors.info,
                            size: 24,
                          ),
                        ),
                        trailing: MasterDataStatusChip(
                          label: service.status,
                          color: service.isActive
                              ? AppColors.success
                              : AppColors.textTertiary,
                          icon: service.isActive
                              ? Iconsax.tick_circle
                              : Iconsax.close_circle,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: MasterDataInfoCard(
                                label: 'Harga',
                                value: NumberFormat.currency(
                                  locale: 'id_ID',
                                  symbol: 'Rp ',
                                  decimalDigits: 0,
                                ).format(service.serviceCost),
                                icon: Iconsax.money_recive,
                                color: AppColors.success,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: MasterDataInfoCard(
                                label: 'Kategori',
                                value: service.category?.categoryName ?? '-',
                                icon: Iconsax.category,
                                color: AppColors.secondary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: MasterDataInfoCard(
                                label: 'ID Servis',
                                value: service.serviceId ?? '-',
                                icon: Iconsax.hashtag,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Pagination
            Consumer<MasterDataProvider>(
              builder: (context, provider, child) {
                if (provider.services.isEmpty) return const SizedBox.shrink();
                
                return PaginationControls(
                  currentPage: provider.currentPage,
                  totalPages: provider.totalPages,
                  totalItems: provider.totalItems,
                  itemsPerPage: provider.itemsPerPage,
                  onPageChanged: provider.setPage,
                  onItemsPerPageChanged: provider.setItemsPerPage,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceDetailDialog extends StatelessWidget {
  final Service service;

  const _ServiceDetailDialog({
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Iconsax.setting_2,
                    color: AppColors.info,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.serviceName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (service.serviceDescription != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          service.serviceDescription!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Iconsax.close_circle),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Service Info Grid
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                MasterDataInfoCard(
                  label: 'ID Servis',
                  value: service.serviceId ?? '-',
                  icon: Iconsax.hashtag,
                  color: AppColors.primary,
                ),
                MasterDataInfoCard(
                  label: 'Harga',
                  value: NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(service.serviceCost),
                  icon: Iconsax.money_recive,
                  color: AppColors.success,
                ),
                MasterDataInfoCard(
                  label: 'Kategori',
                  value: service.category?.categoryName ?? '-',
                  icon: Iconsax.category,
                  color: AppColors.secondary,
                ),
                MasterDataInfoCard(
                  label: 'Status',
                  value: service.status,
                  icon: service.isActive ? Iconsax.tick_circle : Iconsax.close_circle,
                  color: service.isActive ? AppColors.success : AppColors.textTertiary,
                ),
              ],
            ),

            if (service.serviceDescription != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              
              // Description
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Deskripsi Layanan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service.serviceDescription!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: MasterDataInfoCard(
                    label: 'Dibuat',
                    value: DateFormat('dd MMMM yyyy', 'id_ID').format(service.createdAt),
                    icon: Iconsax.calendar_add,
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: MasterDataInfoCard(
                    label: 'Diperbarui',
                    value: DateFormat('dd/MM/yyyy').format(service.updatedAt),
                    icon: Iconsax.refresh,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Tutup'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
