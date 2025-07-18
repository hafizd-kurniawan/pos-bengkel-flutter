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
import 'package:pos_bengkel/shared/models/product.dart';

class ProductMasterScreen extends StatefulWidget {
  const ProductMasterScreen({super.key});

  @override
  State<ProductMasterScreen> createState() => _ProductMasterScreenState();
}

class _ProductMasterScreenState extends State<ProductMasterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MasterDataProvider>().loadProducts();
    });
  }

  void _showProductDetail(Product product) {
    showDialog(
      context: context,
      builder: (context) => _ProductDetailDialog(product: product),
    );
  }

  void _handleExport() {
    final provider = context.read<MasterDataProvider>();
    
    DataExportDialog.show(
      context: context,
      title: 'Data Barang',
      exportOptions: CommonExportOptions.all,
      availableFields: ExportFieldDefinitions.productFields,
      onExport: (config) {
        final exportData = provider.products.map((product) => {
          'name': product.name,
          'sku': product.sku ?? '-',
          'category': product.category?.name ?? '-',
          'stock': product.stock.toString(),
          'costPrice': NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp ',
            decimalDigits: 0,
          ).format(product.costPrice),
          'sellingPrice': NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp ',
            decimalDigits: 0,
          ).format(product.sellingPrice),
          'status': product.isActive ? 'Aktif' : 'Nonaktif',
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
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Iconsax.box,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data Barang',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kelola data produk dan spare parts sistem',
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
                  searchHint: 'Cari produk, SKU, kategori...',
                  onSearch: provider.searchProducts,
                  filterOptions: const [
                    FilterOption(
                      label: 'Stok Tersedia',
                      value: 'in_stock',
                      description: 'Produk dengan stok > 0',
                    ),
                    FilterOption(
                      label: 'Stok Habis',
                      value: 'out_of_stock',
                      description: 'Produk dengan stok = 0',
                    ),
                    FilterOption(
                      label: 'Aktif',
                      value: 'active',
                      description: 'Produk yang masih aktif',
                    ),
                    FilterOption(
                      label: 'Nonaktif',
                      value: 'inactive',
                      description: 'Produk yang nonaktif',
                    ),
                  ],
                  onFilterChanged: provider.filterProducts,
                  onExport: _handleExport,
                  onRefresh: provider.loadProducts,
                  isLoading: provider.productsState == LoadingState.loading,
                );
              },
            ),
            const SizedBox(height: 16),

            // Product List
            Expanded(
              child: Consumer<MasterDataProvider>(
                builder: (context, provider, child) {
                  if (provider.productsState == LoadingState.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (provider.productsState == LoadingState.error) {
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
                          Text(
                            'Gagal memuat data',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.productsError ?? 'Terjadi kesalahan',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: provider.loadProducts,
                            icon: const Icon(Iconsax.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (provider.products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Iconsax.box,
                            size: 64,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Tidak ada data produk',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.searchQuery.isNotEmpty
                                ? 'Tidak ditemukan produk dengan kata kunci "${provider.searchQuery}"'
                                : 'Belum ada data produk yang tersedia',
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
                    itemCount: provider.products.length,
                    itemBuilder: (context, index) {
                      final product = provider.products[index];
                      return MasterDataCard(
                        title: product.name,
                        subtitle: product.description,
                        onTap: () => _showProductDetail(product),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Iconsax.box,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            MasterDataStatusChip(
                              label: product.isActive ? 'Aktif' : 'Nonaktif',
                              color: product.isActive
                                  ? AppColors.success
                                  : AppColors.textTertiary,
                              icon: product.isActive
                                  ? Iconsax.tick_circle
                                  : Iconsax.close_circle,
                            ),
                            const SizedBox(height: 4),
                            MasterDataStatusChip(
                              label: product.isInStock ? 'Stok: ${product.stock}' : 'Habis',
                              color: product.isInStock
                                  ? AppColors.info
                                  : AppColors.error,
                              icon: product.isInStock
                                  ? Iconsax.archive_tick
                                  : Iconsax.archive_minus,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: MasterDataInfoCard(
                                label: 'SKU',
                                value: product.sku ?? '-',
                                icon: Iconsax.barcode,
                                color: AppColors.info,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: MasterDataInfoCard(
                                label: 'Harga Jual',
                                value: NumberFormat.currency(
                                  locale: 'id_ID',
                                  symbol: 'Rp ',
                                  decimalDigits: 0,
                                ).format(product.sellingPrice),
                                icon: Iconsax.money_recive,
                                color: AppColors.success,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: MasterDataInfoCard(
                                label: 'Kategori',
                                value: product.category?.name ?? '-',
                                icon: Iconsax.category,
                                color: AppColors.secondary,
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
                if (provider.products.isEmpty) return const SizedBox.shrink();
                
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

class _ProductDetailDialog extends StatelessWidget {
  final Product product;

  const _ProductDetailDialog({
    required this.product,
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
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Iconsax.box,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (product.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          product.description!,
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

            // Product Info Grid
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                MasterDataInfoCard(
                  label: 'SKU',
                  value: product.sku ?? '-',
                  icon: Iconsax.barcode,
                  color: AppColors.info,
                ),
                MasterDataInfoCard(
                  label: 'Stok',
                  value: product.stock.toString(),
                  icon: Iconsax.archive,
                  color: product.isInStock ? AppColors.success : AppColors.error,
                ),
                MasterDataInfoCard(
                  label: 'Harga Beli',
                  value: NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(product.costPrice),
                  icon: Iconsax.money_send,
                  color: AppColors.warning,
                ),
                MasterDataInfoCard(
                  label: 'Harga Jual',
                  value: NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(product.sellingPrice),
                  icon: Iconsax.money_recive,
                  color: AppColors.success,
                ),
                MasterDataInfoCard(
                  label: 'Kategori',
                  value: product.category?.name ?? '-',
                  icon: Iconsax.category,
                  color: AppColors.secondary,
                ),
                MasterDataInfoCard(
                  label: 'Status',
                  value: product.isActive ? 'Aktif' : 'Nonaktif',
                  icon: product.isActive ? Iconsax.tick_circle : Iconsax.close_circle,
                  color: product.isActive ? AppColors.success : AppColors.textTertiary,
                ),
              ],
            ),

            if (product.shelfLocation != null || product.barcode != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              
              // Additional Info
              if (product.shelfLocation != null)
                MasterDataInfoCard(
                  label: 'Lokasi Rak',
                  value: product.shelfLocation!,
                  icon: Iconsax.location,
                  color: AppColors.info,
                ),
              
              if (product.barcode != null) ...[
                const SizedBox(height: 16),
                MasterDataInfoCard(
                  label: 'Barcode',
                  value: product.barcode!,
                  icon: Iconsax.scan_barcode,
                  color: AppColors.primary,
                ),
              ],
            ],
            
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
