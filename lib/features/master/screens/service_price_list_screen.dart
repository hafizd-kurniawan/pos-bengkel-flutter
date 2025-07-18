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
import 'package:pos_bengkel/features/master/models/price_list.dart';

class ServicePriceListScreen extends StatefulWidget {
  const ServicePriceListScreen({super.key});

  @override
  State<ServicePriceListScreen> createState() => _ServicePriceListScreenState();
}

class _ServicePriceListScreenState extends State<ServicePriceListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MasterDataProvider>().loadPriceLists();
    });
  }

  void _showPriceDetail(PriceList priceList) {
    showDialog(
      context: context,
      builder: (context) => _PriceDetailDialog(priceList: priceList),
    );
  }

  void _handleExport() {
    final provider = context.read<MasterDataProvider>();
    
    DataExportDialog.show(
      context: context,
      title: 'Daftar Harga Servis',
      exportOptions: CommonExportOptions.all,
      availableFields: ExportFieldDefinitions.priceListFields,
      onExport: (config) {
        final exportData = provider.priceLists.map((priceList) => {
          'serviceName': priceList.service?.serviceName ?? 'Layanan ${priceList.serviceId}',
          'price': NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp ',
            decimalDigits: 0,
          ).format(priceList.price),
          'effectiveDate': DateFormat('dd/MM/yyyy').format(priceList.effectiveDate),
          'endDate': priceList.endDate != null
              ? DateFormat('dd/MM/yyyy').format(priceList.endDate!)
              : '-',
          'status': priceList.status,
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
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Iconsax.money_recive,
                      color: AppColors.success,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daftar Harga Servis',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kelola daftar harga layanan servis sistem',
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
                  searchHint: 'Cari layanan, harga...',
                  onSearch: provider.searchPriceLists,
                  onExport: _handleExport,
                  onRefresh: provider.loadPriceLists,
                  isLoading: provider.priceListsState == LoadingState.loading,
                );
              },
            ),
            const SizedBox(height: 16),

            // Price List
            Expanded(
              child: Consumer<MasterDataProvider>(
                builder: (context, provider, child) {
                  if (provider.priceListsState == LoadingState.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (provider.priceListsState == LoadingState.error) {
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
                            provider.priceListsError ?? 'Terjadi kesalahan',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: provider.loadPriceLists,
                            icon: const Icon(Iconsax.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (provider.priceLists.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Iconsax.money_recive,
                            size: 64,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Tidak ada daftar harga',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.searchQuery.isNotEmpty
                                ? 'Tidak ditemukan harga dengan kata kunci "${provider.searchQuery}"'
                                : 'Belum ada data daftar harga yang tersedia',
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
                    itemCount: provider.priceLists.length,
                    itemBuilder: (context, index) {
                      final priceList = provider.priceLists[index];
                      return MasterDataCard(
                        title: priceList.service?.serviceName ?? 'Layanan ${priceList.serviceId}',
                        subtitle: priceList.notes,
                        onTap: () => _showPriceDetail(priceList),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Iconsax.money_recive,
                            color: AppColors.success,
                            size: 24,
                          ),
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            MasterDataStatusChip(
                              label: priceList.isCurrentlyEffective ? 'Berlaku' : 
                                     priceList.isFutureEffective ? 'Masa Depan' :
                                     priceList.isExpired ? 'Berakhir' : priceList.status,
                              color: priceList.isCurrentlyEffective ? AppColors.success :
                                     priceList.isFutureEffective ? AppColors.info :
                                     priceList.isExpired ? AppColors.error : AppColors.textTertiary,
                              icon: priceList.isCurrentlyEffective ? Iconsax.tick_circle :
                                    priceList.isFutureEffective ? Iconsax.timer_1 :
                                    priceList.isExpired ? Iconsax.close_circle : Iconsax.info_circle,
                            ),
                          ],
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
                                ).format(priceList.price),
                                icon: Iconsax.money,
                                color: AppColors.success,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: MasterDataInfoCard(
                                label: 'Berlaku Dari',
                                value: DateFormat('dd/MM/yy').format(priceList.effectiveDate),
                                icon: Iconsax.calendar_tick,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: MasterDataInfoCard(
                                label: 'Berakhir',
                                value: priceList.endDate != null
                                    ? DateFormat('dd/MM/yy').format(priceList.endDate!)
                                    : 'Permanen',
                                icon: priceList.endDate != null ? Iconsax.calendar_remove : Iconsax.infinite,
                                color: priceList.endDate != null ? AppColors.warning : AppColors.info,
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
                if (provider.priceLists.isEmpty) return const SizedBox.shrink();
                
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

class _PriceDetailDialog extends StatelessWidget {
  final PriceList priceList;

  const _PriceDetailDialog({
    required this.priceList,
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
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Iconsax.money_recive,
                    color: AppColors.success,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        priceList.service?.serviceName ?? 'Layanan ${priceList.serviceId}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Price List ID: ${priceList.priceListId}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
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

            // Price Info Grid
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                MasterDataInfoCard(
                  label: 'Harga',
                  value: NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(priceList.price),
                  icon: Iconsax.money,
                  color: AppColors.success,
                ),
                MasterDataInfoCard(
                  label: 'Service ID',
                  value: priceList.serviceId,
                  icon: Iconsax.hashtag,
                  color: AppColors.primary,
                ),
                MasterDataInfoCard(
                  label: 'Berlaku Dari',
                  value: DateFormat('dd MMMM yyyy', 'id_ID').format(priceList.effectiveDate),
                  icon: Iconsax.calendar_tick,
                  color: AppColors.info,
                ),
                MasterDataInfoCard(
                  label: 'Berakhir',
                  value: priceList.endDate != null
                      ? DateFormat('dd MMMM yyyy', 'id_ID').format(priceList.endDate!)
                      : 'Permanen',
                  icon: priceList.endDate != null ? Iconsax.calendar_remove : Iconsax.infinite,
                  color: priceList.endDate != null ? AppColors.warning : AppColors.info,
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Status Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: priceList.isCurrentlyEffective 
                    ? AppColors.success.withOpacity(0.1)
                    : priceList.isFutureEffective
                        ? AppColors.info.withOpacity(0.1)
                        : AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: priceList.isCurrentlyEffective 
                      ? AppColors.success.withOpacity(0.3)
                      : priceList.isFutureEffective
                          ? AppColors.info.withOpacity(0.3)
                          : AppColors.warning.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        priceList.isCurrentlyEffective ? Iconsax.tick_circle :
                        priceList.isFutureEffective ? Iconsax.timer_1 :
                        priceList.isExpired ? Iconsax.close_circle : Iconsax.info_circle,
                        size: 20,
                        color: priceList.isCurrentlyEffective ? AppColors.success :
                               priceList.isFutureEffective ? AppColors.info :
                               priceList.isExpired ? AppColors.error : AppColors.warning,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        priceList.isCurrentlyEffective ? 'Harga Sedang Berlaku' :
                        priceList.isFutureEffective ? 'Harga Akan Berlaku' :
                        priceList.isExpired ? 'Harga Sudah Berakhir' : 'Status Tidak Aktif',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: priceList.isCurrentlyEffective ? AppColors.success :
                                 priceList.isFutureEffective ? AppColors.info :
                                 priceList.isExpired ? AppColors.error : AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    priceList.isCurrentlyEffective 
                        ? 'Harga ini sedang berlaku dan dapat digunakan untuk transaksi.'
                        : priceList.isFutureEffective
                            ? 'Harga ini akan berlaku pada ${DateFormat('dd MMMM yyyy', 'id_ID').format(priceList.effectiveDate)}.'
                            : priceList.isExpired
                                ? 'Harga ini sudah berakhir pada ${DateFormat('dd MMMM yyyy', 'id_ID').format(priceList.endDate!)}.'
                                : 'Harga ini tidak aktif.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            if (priceList.notes != null) ...[
              const SizedBox(height: 16),
              
              // Notes
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
                      'Catatan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      priceList.notes!,
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
                    value: DateFormat('dd/MM/yyyy').format(priceList.createdAt),
                    icon: Iconsax.calendar_add,
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: MasterDataInfoCard(
                    label: 'Diperbarui',
                    value: DateFormat('dd/MM/yyyy').format(priceList.updatedAt),
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
