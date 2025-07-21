import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';
import 'package:pos_bengkel/core/utils/currency_formatter.dart';
import 'package:pos_bengkel/features/kasir/providers/vehicle_sales_provider.dart';
import 'package:pos_bengkel/features/kasir/providers/customer_provider.dart';
import 'package:pos_bengkel/shared/models/vehicle.dart';
import 'package:pos_bengkel/shared/models/customer.dart';

class VehicleSalesScreen extends StatefulWidget {
  const VehicleSalesScreen({super.key});

  @override
  State<VehicleSalesScreen> createState() => _VehicleSalesScreenState();
}

class _VehicleSalesScreenState extends State<VehicleSalesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _downPaymentController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleSalesProvider>().loadForSaleVehicles();
      context.read<CustomerProvider>().loadCustomers();
    });
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _salePriceController.dispose();
    _downPaymentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<VehicleSalesProvider>(
        builder: (context, salesProvider, child) {
          if (salesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildVehicleSelection(salesProvider),
                  const SizedBox(height: 16),
                  _buildCustomerSection(),
                  const SizedBox(height: 16),
                  _buildPriceSection(salesProvider),
                  const SizedBox(height: 16),
                  _buildPaymentMethodSection(salesProvider),
                  if (salesProvider.isInstallmentPayment) ...[
                    const SizedBox(height: 16),
                    _buildInstallmentSection(salesProvider),
                  ],
                  const SizedBox(height: 16),
                  _buildNotesField(),
                  const SizedBox(height: 24),
                  _buildActionButton(salesProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVehicleSelection(VehicleSalesProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Kendaraan',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: provider.selectedVehicleId,
              isExpanded: true,
              hint: const Text('Pilih kendaraan yang akan dijual'),
              items: provider.forSaleVehicles.map((Vehicle vehicle) {
                return DropdownMenuItem<String>(
                  value: vehicle.vehicleId,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.displayName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Harga: ${CurrencyFormatter.format(vehicle.salePrice ?? 0)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? vehicleId) {
                provider.setSelectedVehicleId(vehicleId);
                if (vehicleId != null) {
                  final vehicle = provider.getVehicleById(vehicleId);
                  if (vehicle?.salePrice != null) {
                    _salePriceController.text = vehicle!.salePrice!.toString();
                    provider.setSalePrice(vehicle.salePrice!);
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerSection() {
    return Consumer<CustomerProvider>(
      builder: (context, customerProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Pembeli',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: context.read<VehicleSalesProvider>().selectedCustomerId,
                  isExpanded: true,
                  hint: const Text('Pilih pembeli'),
                  items: customerProvider.customers.map((Customer customer) {
                    return DropdownMenuItem<String>(
                      value: customer.customerId,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            customer.phoneNumber,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? customerId) {
                    final salesProvider = context.read<VehicleSalesProvider>();
                    salesProvider.setSelectedCustomerId(customerId);
                    if (customerId != null) {
                      final customer = customerProvider.customers
                          .firstWhere((c) => c.customerId == customerId);
                      salesProvider.setCustomerName(customer.name);
                      _customerNameController.text = customer.name;
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _customerNameController,
              decoration: InputDecoration(
                labelText: 'Nama Pembeli',
                hintText: 'Masukkan nama pembeli',
                prefixIcon: const Icon(Iconsax.user),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                context.read<VehicleSalesProvider>().setCustomerName(value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama pembeli wajib diisi';
                }
                return null;
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriceSection(VehicleSalesProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Harga Jual',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _salePriceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Harga Jual',
            hintText: 'Masukkan harga jual',
            prefixIcon: const Icon(Iconsax.money_add),
            prefixText: 'Rp ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: (value) {
            final price = double.tryParse(value) ?? 0;
            provider.setSalePrice(price);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Harga jual wajib diisi';
            }
            if (double.tryParse(value) == null || double.parse(value) <= 0) {
              return 'Harga jual harus berupa angka positif';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection(VehicleSalesProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Metode Pembayaran',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: provider.paymentMethod,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'cash', child: Text('Tunai')),
                DropdownMenuItem(value: 'credit', child: Text('Kredit')),
                DropdownMenuItem(value: 'installment', child: Text('Cicilan')),
              ],
              onChanged: (String? method) {
                if (method != null) {
                  provider.setPaymentMethod(method);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstallmentSection(VehicleSalesProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detail Cicilan',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _downPaymentController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Uang Muka',
                  hintText: '0',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  final amount = double.tryParse(value) ?? 0;
                  provider.setDownPayment(amount);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: provider.installmentMonths > 0 ? provider.installmentMonths : null,
                    isExpanded: true,
                    hint: const Text('Tenor (Bulan)'),
                    items: [6, 12, 18, 24, 36].map((int months) {
                      return DropdownMenuItem<int>(
                        value: months,
                        child: Text('$months Bulan'),
                      );
                    }).toList(),
                    onChanged: (int? months) {
                      if (months != null) {
                        provider.setInstallmentMonths(months);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        if (provider.monthlyPayment > 0) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sisa Cicilan:'),
                    Text(
                      CurrencyFormatter.format(provider.remainingAmount),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Cicilan/Bulan:'),
                    Text(
                      CurrencyFormatter.format(provider.monthlyPayment),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Catatan',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Catatan (opsional)',
            hintText: 'Catatan tambahan...',
            prefixIcon: const Icon(Iconsax.note_text),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: (value) {
            context.read<VehicleSalesProvider>().setNotes(value);
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(VehicleSalesProvider provider) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: provider.canCreateSale ? () => _processSale() : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: provider.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Jual Kendaraan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _processSale() async {
    if (!_formKey.currentState!.validate()) return;

    final salesProvider = context.read<VehicleSalesProvider>();
    final success = await salesProvider.sellVehicle();

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Penjualan kendaraan berhasil!'),
            backgroundColor: Colors.green,
          ),
        );
        // Clear form
        _customerNameController.clear();
        _salePriceController.clear();
        _downPaymentController.clear();
        _notesController.clear();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(salesProvider.errorMessage ?? 'Gagal menjual kendaraan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}