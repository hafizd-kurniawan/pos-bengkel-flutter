import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';
import 'package:pos_bengkel/core/utils/currency_formatter.dart';
import 'package:pos_bengkel/features/kasir/providers/customer_provider.dart';
import 'package:pos_bengkel/features/kasir/providers/customer_vehicle_provider.dart';
import 'package:pos_bengkel/features/kasir/providers/vehicle_purchase_provider.dart';
import 'package:pos_bengkel/features/kasir/widgets/customer_selection_dialog.dart';
import 'package:pos_bengkel/features/kasir/widgets/vehicle_selection_dialog.dart';

class VehiclePurchaseScreen extends StatefulWidget {
  const VehiclePurchaseScreen({super.key});

  @override
  State<VehiclePurchaseScreen> createState() => _VehiclePurchaseScreenState();
}

class _VehiclePurchaseScreenState extends State<VehiclePurchaseScreen> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showCustomerDialog() {
    showDialog(
      context: context,
      builder: (context) => CustomerSelectionDialog(
        onCustomerSelected: (customer) {
          context.read<VehiclePurchaseProvider>().setCustomer(customer);
        },
      ),
    );
  }

  void _showVehicleDialog() {
    final purchaseProvider = context.read<VehiclePurchaseProvider>();
    if (purchaseProvider.selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih customer terlebih dahulu'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => VehicleSelectionDialog(
        customerId: purchaseProvider.selectedCustomer!.customerId!,
        onVehicleSelected: (vehicle) {
          purchaseProvider.setVehicle(vehicle);
        },
      ),
    );
  }

  void _handlePurchase() async {
    final purchaseProvider = context.read<VehiclePurchaseProvider>();

    if (!purchaseProvider.canCreatePurchase) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pastikan semua data sudah diisi dengan benar'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final success = await purchaseProvider.createPurchase();

    if (success) {
      _priceController.clear();
      _notesController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pembelian kendaraan berhasil dicatat'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(purchaseProvider.errorMessage ?? 'Gagal mencatat pembelian'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer<VehiclePurchaseProvider>(
          builder: (context, purchaseProvider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Iconsax.car,
                            color: AppColors.primary,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pembelian Kendaraan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'No. Invoice: ${purchaseProvider.invoiceNumber}',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Customer Selection
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pilih Customer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: _showCustomerDialog,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      purchaseProvider.selectedCustomer != null
                                          ? AppColors.success.withOpacity(0.1)
                                          : AppColors.textTertiary
                                              .withOpacity(0.1),
                                  child: Icon(
                                    Iconsax.user,
                                    color: purchaseProvider.selectedCustomer !=
                                            null
                                        ? AppColors.success
                                        : AppColors.textTertiary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        purchaseProvider
                                                .selectedCustomer?.name ??
                                            'Pilih Customer',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: purchaseProvider
                                                      .selectedCustomer !=
                                                  null
                                              ? AppColors.textPrimary
                                              : AppColors.textTertiary,
                                        ),
                                      ),
                                      if (purchaseProvider.selectedCustomer !=
                                          null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          purchaseProvider
                                              .selectedCustomer!.phoneNumber,
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Iconsax.arrow_right_3,
                                  color: AppColors.textTertiary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Vehicle Selection
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pilih Kendaraan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: _showVehicleDialog,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      purchaseProvider.selectedVehicle != null
                                          ? AppColors.info.withOpacity(0.1)
                                          : AppColors.textTertiary
                                              .withOpacity(0.1),
                                  child: Icon(
                                    Iconsax.car,
                                    color:
                                        purchaseProvider.selectedVehicle != null
                                            ? AppColors.info
                                            : AppColors.textTertiary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        purchaseProvider
                                                .selectedVehicle?.displayName ??
                                            'Pilih Kendaraan',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: purchaseProvider
                                                      .selectedVehicle !=
                                                  null
                                              ? AppColors.textPrimary
                                              : AppColors.textTertiary,
                                        ),
                                      ),
                                      if (purchaseProvider.selectedVehicle !=
                                          null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          '${purchaseProvider.selectedVehicle!.type} - ${purchaseProvider.selectedVehicle!.color}',
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Iconsax.arrow_right_3,
                                  color: AppColors.textTertiary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Purchase Details
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detail Pembelian',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Purchase Price
                        TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'Harga Beli',
                            prefixIcon: Icon(Iconsax.money_recive),
                            prefixText: 'Rp ',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final price = double.tryParse(
                                    value.replaceAll(RegExp(r'[^\d]'), '')) ??
                                0.0;
                            purchaseProvider.setPurchasePrice(price);
                          },
                        ),
                        const SizedBox(height: 16),

                        // Condition
                        DropdownButtonFormField<String>(
                          value: purchaseProvider.condition,
                          decoration: const InputDecoration(
                            labelText: 'Kondisi Kendaraan',
                            prefixIcon: Icon(Iconsax.status),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'Sangat Baik',
                                child: Text('Sangat Baik')),
                            DropdownMenuItem(
                                value: 'Baik', child: Text('Baik')),
                            DropdownMenuItem(
                                value: 'Cukup', child: Text('Cukup')),
                            DropdownMenuItem(
                                value: 'Perlu Perbaikan',
                                child: Text('Perlu Perbaikan')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              purchaseProvider.setCondition(value);
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        // Next Action
                        DropdownButtonFormField<String>(
                          value: purchaseProvider.nextAction,
                          decoration: const InputDecoration(
                            labelText: 'Tindakan Selanjutnya',
                            prefixIcon: Icon(Iconsax.arrow_right),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'servis', child: Text('Servis Dulu')),
                            DropdownMenuItem(
                                value: 'jual', child: Text('Langsung Jual')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              purchaseProvider.setNextAction(value);
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        // Notes
                        TextFormField(
                          controller: _notesController,
                          decoration: const InputDecoration(
                            labelText: 'Catatan (Opsional)',
                            prefixIcon: Icon(Iconsax.note),
                          ),
                          maxLines: 3,
                          onChanged: (value) {
                            purchaseProvider.setNotes(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: purchaseProvider.canCreatePurchase &&
                            !purchaseProvider.isLoading
                        ? _handlePurchase
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: purchaseProvider.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.tick_circle),
                              SizedBox(width: 8),
                              Text(
                                'Proses Pembelian',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
