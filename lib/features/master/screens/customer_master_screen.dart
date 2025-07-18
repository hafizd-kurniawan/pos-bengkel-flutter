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
import 'package:pos_bengkel/features/master/widgets/bulk_action_bar.dart';
import 'package:pos_bengkel/shared/models/customer.dart';

class CustomerMasterScreen extends StatefulWidget {
  const CustomerMasterScreen({super.key});

  @override
  State<CustomerMasterScreen> createState() => _CustomerMasterScreenState();
}

class _CustomerMasterScreenState extends State<CustomerMasterScreen> {
  late BulkSelectionProvider _bulkSelectionProvider;

  @override
  void initState() {
    super.initState();
    _bulkSelectionProvider = BulkSelectionProvider();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MasterDataProvider>().loadCustomers();
    });
  }

  @override
  void dispose() {
    _bulkSelectionProvider.dispose();
    super.dispose();
  }

  void _showAddCustomer() {
    showDialog(
      context: context,
      builder: (context) => _CustomerFormDialog(),
    );
  }

  void _showEditCustomer(Customer customer) {
    showDialog(
      context: context,
      builder: (context) => _CustomerFormDialog(customer: customer),
    );
  }

  void _showCustomerDetail(Customer customer) {
    showDialog(
      context: context,
      builder: (context) => _CustomerDetailDialog(customer: customer),
    );
  }

  void _handleBulkDelete() {
    final selectedIds = _bulkSelectionProvider.selectedItems.toList();
    
    BulkConfirmationDialog.show(
      context: context,
      title: 'Hapus Customer',
      message: 'Apakah Anda yakin ingin menghapus ${selectedIds.length} customer yang dipilih?',
      isDestructive: true,
      onConfirm: () {
        // TODO: Implement bulk delete
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${selectedIds.length} customer berhasil dihapus'),
            backgroundColor: AppColors.success,
          ),
        );
        _bulkSelectionProvider.clearSelection();
      },
    );
  }

  void _handleExport() {
    final provider = context.read<MasterDataProvider>();
    
    DataExportDialog.show(
      context: context,
      title: 'Data Customer',
      exportOptions: CommonExportOptions.all,
      availableFields: ExportFieldDefinitions.customerFields,
      onExport: (config) {
        final exportData = provider.customers.map((customer) => {
          'name': customer.name,
          'phoneNumber': customer.phoneNumber,
          'address': customer.address ?? '-',
          'createdAt': DateFormat('dd/MM/yyyy').format(customer.createdAt),
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
    return ChangeNotifierProvider.value(
      value: _bulkSelectionProvider,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
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
                        Iconsax.user,
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
                            'Data Customer',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Kelola data customer dan pelanggan sistem',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showAddCustomer,
                      icon: const Icon(Iconsax.add),
                      label: const Text('Tambah Customer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Bulk Action Bar
              Consumer<BulkSelectionProvider>(
                builder: (context, bulkProvider, child) {
                  return BulkActionBar(
                    selectedCount: bulkProvider.selectedCount,
                    actions: [
                      BulkAction(
                        label: 'Hapus',
                        icon: Iconsax.trash,
                        onPressed: _handleBulkDelete,
                        isDestructive: true,
                      ),
                    ],
                    onClearSelection: bulkProvider.clearSelection,
                    onSelectAll: () {
                      final provider = context.read<MasterDataProvider>();
                      final customerIds = provider.customers
                          .map((c) => c.customerId!)
                          .toList();
                      bulkProvider.selectAll(customerIds);
                    },
                  );
                },
              ),

              // Search and Filter Bar
              Consumer<MasterDataProvider>(
                builder: (context, provider, child) {
                  return SearchFilterBar(
                    searchHint: 'Cari customer, nomor telepon...',
                    onSearch: provider.searchCustomers,
                    onExport: _handleExport,
                    onRefresh: provider.loadCustomers,
                    isLoading: provider.customersState == LoadingState.loading,
                    showExport: true,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Customer List
              Expanded(
                child: Consumer<MasterDataProvider>(
                  builder: (context, provider, child) {
                    if (provider.customersState == LoadingState.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (provider.customersState == LoadingState.error) {
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
                              provider.customersError ?? 'Terjadi kesalahan',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: provider.loadCustomers,
                              icon: const Icon(Iconsax.refresh),
                              label: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (provider.customers.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Iconsax.user,
                              size: 64,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Tidak ada data customer',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              provider.searchQuery.isNotEmpty
                                  ? 'Tidak ditemukan customer dengan kata kunci "${provider.searchQuery}"'
                                  : 'Belum ada data customer yang tersedia',
                              style: const TextStyle(
                                color: AppColors.textTertiary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _showAddCustomer,
                              icon: const Icon(Iconsax.add),
                              label: const Text('Tambah Customer Pertama'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Consumer<BulkSelectionProvider>(
                      builder: (context, bulkProvider, child) {
                        return ListView.builder(
                          itemCount: provider.customers.length,
                          itemBuilder: (context, index) {
                            final customer = provider.customers[index];
                            final isSelected = bulkProvider.isSelected(customer.customerId!);
                            
                            return SelectableListItem(
                              isSelected: isSelected,
                              onSelectionChanged: (selected) {
                                bulkProvider.toggleSelection(customer.customerId!);
                              },
                              onTap: () => _showCustomerDetail(customer),
                              child: MasterDataCard(
                                title: customer.name,
                                subtitle: customer.address,
                                onTap: () => _showCustomerDetail(customer),
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Iconsax.user,
                                    color: AppColors.success,
                                    size: 24,
                                  ),
                                ),
                                actions: [
                                  IconButton(
                                    onPressed: () => _showEditCustomer(customer),
                                    icon: const Icon(Iconsax.edit),
                                    tooltip: 'Edit',
                                    iconSize: 18,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // TODO: Implement delete
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Customer berhasil dihapus'),
                                          backgroundColor: AppColors.success,
                                        ),
                                      );
                                    },
                                    icon: const Icon(Iconsax.trash),
                                    tooltip: 'Hapus',
                                    iconSize: 18,
                                    color: AppColors.error,
                                  ),
                                ],
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: MasterDataInfoCard(
                                        label: 'Telepon',
                                        value: customer.phoneNumber,
                                        icon: Iconsax.call,
                                        color: AppColors.info,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: MasterDataInfoCard(
                                        label: 'Bergabung',
                                        value: DateFormat('dd/MM/yyyy').format(customer.createdAt),
                                        icon: Iconsax.calendar,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),

              // Pagination
              Consumer<MasterDataProvider>(
                builder: (context, provider, child) {
                  if (provider.customers.isEmpty) return const SizedBox.shrink();
                  
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
      ),
    );
  }
}

class _CustomerFormDialog extends StatefulWidget {
  final Customer? customer;

  const _CustomerFormDialog({this.customer});

  @override
  State<_CustomerFormDialog> createState() => __CustomerFormDialogState();
}

class __CustomerFormDialogState extends State<_CustomerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool get isEditing => widget.customer != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.customer!.name;
      _phoneController.text = widget.customer!.phoneNumber;
      _addressController.text = widget.customer!.address ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save customer
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing 
                ? 'Customer berhasil diperbarui'
                : 'Customer berhasil ditambahkan',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      
      // Refresh data
      context.read<MasterDataProvider>().loadCustomers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Iconsax.user,
                      color: AppColors.success,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isEditing ? 'Edit Customer' : 'Tambah Customer',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Iconsax.close_circle),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Form Fields
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Customer *',
                  hintText: 'Masukkan nama customer',
                  prefixIcon: Icon(Iconsax.user),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama customer harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon *',
                  hintText: 'Masukkan nomor telepon',
                  prefixIcon: Icon(Iconsax.call),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor telepon harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  hintText: 'Masukkan alamat (opsional)',
                  prefixIcon: Icon(Iconsax.location),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _handleSubmit,
                    icon: Icon(isEditing ? Iconsax.edit : Iconsax.add),
                    label: Text(isEditing ? 'Perbarui' : 'Simpan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerDetailDialog extends StatelessWidget {
  final Customer customer;

  const _CustomerDetailDialog({
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
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
                    Iconsax.user,
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
                        customer.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Customer ID: ${customer.customerId}',
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

            // Customer Info
            MasterDataInfoCard(
              label: 'Nomor Telepon',
              value: customer.phoneNumber,
              icon: Iconsax.call,
              color: AppColors.info,
            ),
            
            if (customer.address != null) ...[
              const SizedBox(height: 16),
              MasterDataInfoCard(
                label: 'Alamat',
                value: customer.address!,
                icon: Iconsax.location,
                color: AppColors.secondary,
              ),
            ],
            
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: MasterDataInfoCard(
                    label: 'Tanggal Bergabung',
                    value: DateFormat('dd MMMM yyyy', 'id_ID').format(customer.createdAt),
                    icon: Iconsax.calendar,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: MasterDataInfoCard(
                    label: 'Terakhir Update',
                    value: DateFormat('dd/MM/yyyy').format(customer.updatedAt),
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
