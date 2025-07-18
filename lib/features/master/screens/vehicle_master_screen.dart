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
import 'package:pos_bengkel/shared/models/customer_vehicle.dart';

class VehicleMasterScreen extends StatefulWidget {
  const VehicleMasterScreen({super.key});

  @override
  State<VehicleMasterScreen> createState() => _VehicleMasterScreenState();
}

class _VehicleMasterScreenState extends State<VehicleMasterScreen> {
  late BulkSelectionProvider _bulkSelectionProvider;

  @override
  void initState() {
    super.initState();
    _bulkSelectionProvider = BulkSelectionProvider();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MasterDataProvider>().loadVehicles();
    });
  }

  @override
  void dispose() {
    _bulkSelectionProvider.dispose();
    super.dispose();
  }

  void _showAddVehicle() {
    showDialog(
      context: context,
      builder: (context) => _VehicleFormDialog(),
    );
  }

  void _showEditVehicle(CustomerVehicle vehicle) {
    showDialog(
      context: context,
      builder: (context) => _VehicleFormDialog(vehicle: vehicle),
    );
  }

  void _showVehicleDetail(CustomerVehicle vehicle) {
    showDialog(
      context: context,
      builder: (context) => _VehicleDetailDialog(vehicle: vehicle),
    );
  }

  void _handleBulkDelete() {
    final selectedIds = _bulkSelectionProvider.selectedItems.toList();
    
    BulkConfirmationDialog.show(
      context: context,
      title: 'Hapus Kendaraan',
      message: 'Apakah Anda yakin ingin menghapus ${selectedIds.length} kendaraan yang dipilih?',
      isDestructive: true,
      onConfirm: () {
        // TODO: Implement bulk delete
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${selectedIds.length} kendaraan berhasil dihapus'),
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
      title: 'Data Kendaraan',
      exportOptions: CommonExportOptions.all,
      availableFields: ExportFieldDefinitions.vehicleFields,
      onExport: (config) {
        final exportData = provider.vehicles.map((vehicle) => {
          'plateNumber': vehicle.plateNumber,
          'brand': vehicle.brand,
          'model': vehicle.model,
          'productionYear': vehicle.productionYear.toString(),
          'color': vehicle.color,
          'status': vehicle.status,
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
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Iconsax.car,
                        color: AppColors.warning,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Data Kendaraan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Kelola data kendaraan customer',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showAddVehicle,
                      icon: const Icon(Iconsax.add),
                      label: const Text('Tambah Kendaraan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warning,
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
                      final vehicleIds = provider.vehicles
                          .map((v) => v.vehicleId!)
                          .toList();
                      bulkProvider.selectAll(vehicleIds);
                    },
                  );
                },
              ),

              // Search and Filter Bar
              Consumer<MasterDataProvider>(
                builder: (context, provider, child) {
                  return SearchFilterBar(
                    searchHint: 'Cari plat nomor, merek, model...',
                    onSearch: provider.searchVehicles,
                    onExport: _handleExport,
                    onRefresh: provider.loadVehicles,
                    isLoading: provider.vehiclesState == LoadingState.loading,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Vehicle List
              Expanded(
                child: Consumer<MasterDataProvider>(
                  builder: (context, provider, child) {
                    if (provider.vehiclesState == LoadingState.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (provider.vehiclesState == LoadingState.error) {
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
                              provider.vehiclesError ?? 'Terjadi kesalahan',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: provider.loadVehicles,
                              icon: const Icon(Iconsax.refresh),
                              label: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (provider.vehicles.isEmpty) {
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
                              'Tidak ada data kendaraan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              provider.searchQuery.isNotEmpty
                                  ? 'Tidak ditemukan kendaraan dengan kata kunci "${provider.searchQuery}"'
                                  : 'Belum ada data kendaraan yang tersedia',
                              style: const TextStyle(
                                color: AppColors.textTertiary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _showAddVehicle,
                              icon: const Icon(Iconsax.add),
                              label: const Text('Tambah Kendaraan Pertama'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Consumer<BulkSelectionProvider>(
                      builder: (context, bulkProvider, child) {
                        return ListView.builder(
                          itemCount: provider.vehicles.length,
                          itemBuilder: (context, index) {
                            final vehicle = provider.vehicles[index];
                            final isSelected = bulkProvider.isSelected(vehicle.vehicleId!);
                            
                            return SelectableListItem(
                              isSelected: isSelected,
                              onSelectionChanged: (selected) {
                                bulkProvider.toggleSelection(vehicle.vehicleId!);
                              },
                              onTap: () => _showVehicleDetail(vehicle),
                              child: MasterDataCard(
                                title: vehicle.displayName,
                                subtitle: '${vehicle.type} • ${vehicle.color}',
                                onTap: () => _showVehicleDetail(vehicle),
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.warning.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Iconsax.car,
                                    color: AppColors.warning,
                                    size: 24,
                                  ),
                                ),
                                trailing: MasterDataStatusChip(
                                  label: vehicle.status,
                                  color: vehicle.status == 'Aktif'
                                      ? AppColors.success
                                      : AppColors.textTertiary,
                                  icon: vehicle.status == 'Aktif'
                                      ? Iconsax.tick_circle
                                      : Iconsax.close_circle,
                                ),
                                actions: [
                                  IconButton(
                                    onPressed: () => _showEditVehicle(vehicle),
                                    icon: const Icon(Iconsax.edit),
                                    tooltip: 'Edit',
                                    iconSize: 18,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // TODO: Implement delete
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Kendaraan berhasil dihapus'),
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
                                        label: 'Plat Nomor',
                                        value: vehicle.plateNumber,
                                        icon: Iconsax.hashtag,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: MasterDataInfoCard(
                                        label: 'Tahun',
                                        value: vehicle.productionYear.toString(),
                                        icon: Iconsax.calendar,
                                        color: AppColors.info,
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
                  if (provider.vehicles.isEmpty) return const SizedBox.shrink();
                  
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

class _VehicleFormDialog extends StatefulWidget {
  final CustomerVehicle? vehicle;

  const _VehicleFormDialog({this.vehicle});

  @override
  State<_VehicleFormDialog> createState() => __VehicleFormDialogState();
}

class __VehicleFormDialogState extends State<_VehicleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _plateNumberController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _productionYearController = TextEditingController();
  final _engineNumberController = TextEditingController();
  final _chassisNumberController = TextEditingController();
  final _colorController = TextEditingController();
  
  String _selectedType = 'Mobil';
  String _selectedStatus = 'Aktif';

  bool get isEditing => widget.vehicle != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _plateNumberController.text = widget.vehicle!.plateNumber;
      _brandController.text = widget.vehicle!.brand;
      _modelController.text = widget.vehicle!.model;
      _productionYearController.text = widget.vehicle!.productionYear.toString();
      _engineNumberController.text = widget.vehicle!.engineNumber;
      _chassisNumberController.text = widget.vehicle!.chassisNumber;
      _colorController.text = widget.vehicle!.color;
      _selectedType = widget.vehicle!.type;
      _selectedStatus = widget.vehicle!.status;
    }
  }

  @override
  void dispose() {
    _plateNumberController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _productionYearController.dispose();
    _engineNumberController.dispose();
    _chassisNumberController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save vehicle
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing 
                ? 'Kendaraan berhasil diperbarui'
                : 'Kendaraan berhasil ditambahkan',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      
      // Refresh data
      context.read<MasterDataProvider>().loadVehicles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
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
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Iconsax.car,
                      color: AppColors.warning,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isEditing ? 'Edit Kendaraan' : 'Tambah Kendaraan',
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _plateNumberController,
                              decoration: const InputDecoration(
                                labelText: 'Plat Nomor *',
                                hintText: 'B 1234 ABC',
                                prefixIcon: Icon(Iconsax.hashtag),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Plat nomor harus diisi';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedType,
                              decoration: const InputDecoration(
                                labelText: 'Jenis Kendaraan *',
                                prefixIcon: Icon(Iconsax.car),
                              ),
                              items: ['Mobil', 'Motor'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _brandController,
                              decoration: const InputDecoration(
                                labelText: 'Merek *',
                                hintText: 'Toyota',
                                prefixIcon: Icon(Iconsax.tag_2),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Merek harus diisi';
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
                                hintText: 'Avanza',
                                prefixIcon: Icon(Iconsax.category),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Model harus diisi';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _productionYearController,
                              decoration: const InputDecoration(
                                labelText: 'Tahun Produksi *',
                                hintText: '2020',
                                prefixIcon: Icon(Iconsax.calendar),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Tahun produksi harus diisi';
                                }
                                final year = int.tryParse(value);
                                if (year == null || year < 1900 || year > DateTime.now().year + 1) {
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
                                hintText: 'Putih',
                                prefixIcon: Icon(Iconsax.colorfilter),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Warna harus diisi';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _engineNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Nomor Mesin *',
                          hintText: 'Masukkan nomor mesin',
                          prefixIcon: Icon(Iconsax.setting_3),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor mesin harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _chassisNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Nomor Rangka *',
                          hintText: 'Masukkan nomor rangka',
                          prefixIcon: Icon(Iconsax.code),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor rangka harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Status *',
                          prefixIcon: Icon(Iconsax.info_circle),
                        ),
                        items: ['Aktif', 'Nonaktif'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
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
                      backgroundColor: AppColors.warning,
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

class _VehicleDetailDialog extends StatelessWidget {
  final CustomerVehicle vehicle;

  const _VehicleDetailDialog({
    required this.vehicle,
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
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Iconsax.car,
                    color: AppColors.warning,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.displayName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Vehicle ID: ${vehicle.vehicleId}',
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

            // Vehicle Info Grid
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                MasterDataInfoCard(
                  label: 'Plat Nomor',
                  value: vehicle.plateNumber,
                  icon: Iconsax.hashtag,
                  color: AppColors.primary,
                ),
                MasterDataInfoCard(
                  label: 'Jenis',
                  value: vehicle.type,
                  icon: Iconsax.car,
                  color: AppColors.info,
                ),
                MasterDataInfoCard(
                  label: 'Merek',
                  value: vehicle.brand,
                  icon: Iconsax.tag_2,
                  color: AppColors.secondary,
                ),
                MasterDataInfoCard(
                  label: 'Model',
                  value: vehicle.model,
                  icon: Iconsax.category,
                  color: AppColors.success,
                ),
                MasterDataInfoCard(
                  label: 'Tahun',
                  value: vehicle.productionYear.toString(),
                  icon: Iconsax.calendar,
                  color: AppColors.warning,
                ),
                MasterDataInfoCard(
                  label: 'Warna',
                  value: vehicle.color,
                  icon: Iconsax.colorfilter,
                  color: AppColors.error,
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Technical Info
            MasterDataInfoCard(
              label: 'Nomor Mesin',
              value: vehicle.engineNumber,
              icon: Iconsax.setting_3,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            MasterDataInfoCard(
              label: 'Nomor Rangka',
              value: vehicle.chassisNumber,
              icon: Iconsax.code,
              color: AppColors.info,
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: MasterDataInfoCard(
                    label: 'Status',
                    value: vehicle.status,
                    icon: vehicle.status == 'Aktif' ? Iconsax.tick_circle : Iconsax.close_circle,
                    color: vehicle.status == 'Aktif' ? AppColors.success : AppColors.textTertiary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: MasterDataInfoCard(
                    label: 'Terdaftar',
                    value: DateFormat('dd/MM/yyyy').format(vehicle.createdAt),
                    icon: Iconsax.calendar_add,
                    color: AppColors.secondary,
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
