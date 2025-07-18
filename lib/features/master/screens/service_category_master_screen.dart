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

class ServiceCategoryMasterScreen extends StatefulWidget {
  const ServiceCategoryMasterScreen({super.key});

  @override
  State<ServiceCategoryMasterScreen> createState() => _ServiceCategoryMasterScreenState();
}

class _ServiceCategoryMasterScreenState extends State<ServiceCategoryMasterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MasterDataProvider>().loadServiceCategories();
    });
  }

  void _showCategoryDetail(ServiceCategory category) {
    showDialog(
      context: context,
      builder: (context) => _CategoryDetailDialog(category: category),
    );
  }

  void _handleExport() {
    final provider = context.read<MasterDataProvider>();
    
    DataExportDialog.show(
      context: context,
      title: 'Kategori Servis',
      exportOptions: CommonExportOptions.all,
      availableFields: ExportFieldDefinitions.serviceCategoryFields,
      onExport: (config) {
        final exportData = provider.serviceCategories.map((category) => {
          'categoryName': category.categoryName,
          'categoryDescription': category.categoryDescription ?? '-',
          'parentCategory': category.parentCategory?.categoryName ?? '-',
          'status': category.status,
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
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Iconsax.category,
                      color: AppColors.secondary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kategori Servis',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kelola kategori layanan servis sistem',
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
                  searchHint: 'Cari kategori servis...',
                  onSearch: provider.searchServiceCategories,
                  onExport: _handleExport,
                  onRefresh: provider.loadServiceCategories,
                  isLoading: provider.serviceCategoriesState == LoadingState.loading,
                );
              },
            ),
            const SizedBox(height: 16),

            // Category List
            Expanded(
              child: Consumer<MasterDataProvider>(
                builder: (context, provider, child) {
                  if (provider.serviceCategoriesState == LoadingState.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (provider.serviceCategoriesState == LoadingState.error) {
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
                            provider.serviceCategoriesError ?? 'Terjadi kesalahan',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: provider.loadServiceCategories,
                            icon: const Icon(Iconsax.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (provider.serviceCategories.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Iconsax.category,
                            size: 64,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Tidak ada kategori servis',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.searchQuery.isNotEmpty
                                ? 'Tidak ditemukan kategori dengan kata kunci "${provider.searchQuery}"'
                                : 'Belum ada data kategori servis yang tersedia',
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
                    itemCount: provider.serviceCategories.length,
                    itemBuilder: (context, index) {
                      final category = provider.serviceCategories[index];
                      return MasterDataCard(
                        title: category.categoryName,
                        subtitle: category.categoryDescription,
                        onTap: () => _showCategoryDetail(category),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            category.hasParent ? Iconsax.category_2 : Iconsax.category,
                            color: AppColors.secondary,
                            size: 24,
                          ),
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            MasterDataStatusChip(
                              label: category.status,
                              color: category.isActive
                                  ? AppColors.success
                                  : AppColors.textTertiary,
                              icon: category.isActive
                                  ? Iconsax.tick_circle
                                  : Iconsax.close_circle,
                            ),
                            if (category.hasParent) ...[
                              const SizedBox(height: 4),
                              MasterDataStatusChip(
                                label: 'Sub Kategori',
                                color: AppColors.info,
                                icon: Iconsax.arrow_down_1,
                              ),
                            ],
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: MasterDataInfoCard(
                                label: 'ID Kategori',
                                value: category.serviceCategoryId ?? '-',
                                icon: Iconsax.hashtag,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: MasterDataInfoCard(
                                label: category.hasParent ? 'Kategori Induk' : 'Level',
                                value: category.hasParent 
                                    ? category.parentCategory?.categoryName ?? '-'
                                    : 'Utama',
                                icon: category.hasParent ? Iconsax.arrow_up_1 : Iconsax.crown,
                                color: category.hasParent ? AppColors.warning : AppColors.success,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: MasterDataInfoCard(
                                label: 'Path',
                                value: category.fullPath.length > 20 
                                    ? '${category.fullPath.substring(0, 17)}...'
                                    : category.fullPath,
                                icon: Iconsax.routing,
                                color: AppColors.info,
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
                if (provider.serviceCategories.isEmpty) return const SizedBox.shrink();
                
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

class _CategoryDetailDialog extends StatelessWidget {
  final ServiceCategory category;

  const _CategoryDetailDialog({
    required this.category,
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
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    category.hasParent ? Iconsax.category_2 : Iconsax.category,
                    color: AppColors.secondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.categoryName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (category.categoryDescription != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          category.categoryDescription!,
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

            // Category Info
            MasterDataInfoCard(
              label: 'ID Kategori',
              value: category.serviceCategoryId ?? '-',
              icon: Iconsax.hashtag,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),

            // Hierarchy Info
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
                    'Hierarki Kategori',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Iconsax.routing,
                        size: 16,
                        color: AppColors.info,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          category.fullPath,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      MasterDataInfoCard(
                        label: 'Level',
                        value: '${category.level}',
                        icon: Iconsax.layer,
                        color: AppColors.info,
                      ),
                      const SizedBox(width: 16),
                      if (category.hasParent)
                        Expanded(
                          child: MasterDataInfoCard(
                            label: 'Kategori Induk',
                            value: category.parentCategory?.categoryName ?? '-',
                            icon: Iconsax.arrow_up_1,
                            color: AppColors.warning,
                          ),
                        )
                      else
                        Expanded(
                          child: MasterDataInfoCard(
                            label: 'Jenis',
                            value: 'Kategori Utama',
                            icon: Iconsax.crown,
                            color: AppColors.success,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            if (category.categoryDescription != null) ...[
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
                      'Deskripsi Kategori',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.categoryDescription!,
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
                    label: 'Status',
                    value: category.status,
                    icon: category.isActive ? Iconsax.tick_circle : Iconsax.close_circle,
                    color: category.isActive ? AppColors.success : AppColors.textTertiary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: MasterDataInfoCard(
                    label: 'Dibuat',
                    value: DateFormat('dd/MM/yyyy').format(category.createdAt),
                    icon: Iconsax.calendar_add,
                    color: AppColors.info,
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
