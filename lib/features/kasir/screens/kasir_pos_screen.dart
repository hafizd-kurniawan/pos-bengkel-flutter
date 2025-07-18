import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';
import 'package:pos_bengkel/core/utils/currency_formatter.dart';
import 'package:pos_bengkel/features/kasir/providers/cart_provider.dart';
import 'package:pos_bengkel/features/kasir/providers/product_provider.dart';
import 'package:pos_bengkel/features/kasir/providers/customer_provider.dart';
import 'package:pos_bengkel/features/kasir/providers/transaction_provider.dart';
import 'package:pos_bengkel/features/kasir/widgets/customer_selection_dialog.dart';
import 'package:pos_bengkel/shared/models/product.dart';

class KasirPosScreen extends StatefulWidget {
  const KasirPosScreen({super.key});

  @override
  State<KasirPosScreen> createState() => _KasirPosScreenState();
}

class _KasirPosScreenState extends State<KasirPosScreen> {
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _paidAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _paidAmountController.dispose();
    super.dispose();
  }

  void _handleBarcodeSubmit() async {
    final barcode = _barcodeController.text.trim();
    if (barcode.isEmpty) return;

    final productProvider = context.read<ProductProvider>();
    final cartProvider = context.read<CartProvider>();

    final product = await productProvider.getProductByBarcode(barcode);

    if (product != null) {
      cartProvider.addItem(product);
      _barcodeController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} ditambahkan ke keranjang'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Produk dengan barcode $barcode tidak ditemukan'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showCustomerDialog() {
    showDialog(
      context: context,
      builder: (context) => const CustomerSelectionDialog(),
    );
  }

  void _handleCheckout() async {
    final cartProvider = context.read<CartProvider>();
    final transactionProvider = context.read<TransactionProvider>();

    if (!cartProvider.canCheckout) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pastikan jumlah pembayaran cukup'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    // Demo user ID dan outlet ID - dalam implementasi sebenarnya ambil dari auth provider
    const userId = '1';
    const outletId = '1';

    final transactionData = cartProvider.toTransactionJson(userId, outletId);

    final success =
        await transactionProvider.createTransaction(transactionData);

    if (success) {
      cartProvider.clear();
      _paidAmountController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaksi berhasil disimpan'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              transactionProvider.errorMessage ?? 'Gagal menyimpan transaksi'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transaksi Kasir'),
        automaticallyImplyLeading: false,
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, _) {
              return Badge(
                label: Text('${cartProvider.itemCount}'),
                isLabelVisible: cartProvider.itemCount > 0,
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    // Show cart details
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Invoice Number
                Consumer<CartProvider>(
                  builder: (context, cartProvider, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Barang',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'No. Invoice: ${cartProvider.invoiceNumber}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Barcode Input
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _barcodeController,
                        decoration: const InputDecoration(
                          labelText: 'Barcode / Kode Barang',
                          prefixIcon: Icon(Icons.qr_code_scanner),
                          suffixIcon: Icon(Icons.search),
                        ),
                        onFieldSubmitted: (_) => _handleBarcodeSubmit(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Show product search dialog
                        _showProductSearchDialog();
                      },
                      icon: const Icon(Icons.list),
                      label: const Text('Cari'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Cart Items
          Expanded(
            child: Consumer<CartProvider>(
              builder: (context, cartProvider, _) {
                if (cartProvider.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Keranjang kosong',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Scan barcode atau cari produk untuk memulai',
                          style: TextStyle(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    // Table Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: AppColors.primary,
                      child: const Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text('No.',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 3,
                              child: Text('Nama',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 2,
                              child: Text('Harga',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 1,
                              child: Text('QTY',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 2,
                              child: Text('Sub Total',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 1,
                              child: Text('Aksi',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),

                    // Cart Items List
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartProvider.items.length,
                        itemBuilder: (context, index) {
                          final item = cartProvider.items[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AppColors.border),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 1, child: Text('${index + 1}')),
                                Expanded(
                                    flex: 3, child: Text(item.productName)),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                        CurrencyFormatter.format(item.price))),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                            Icons.remove_circle_outline),
                                        onPressed: item.quantity > 1
                                            ? () =>
                                                cartProvider.updateItemQuantity(
                                                    index, item.quantity - 1)
                                            : null,
                                        iconSize: 20,
                                      ),
                                      Text('${item.quantity}'),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.add_circle_outline),
                                        onPressed: () =>
                                            cartProvider.updateItemQuantity(
                                                index, item.quantity + 1),
                                        iconSize: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Text(CurrencyFormatter.format(
                                        item.subtotal))),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: AppColors.error),
                                    onPressed: () =>
                                        cartProvider.removeItem(index),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Payment Section
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Consumer<CartProvider>(
              builder: (context, cartProvider, _) {
                return Column(
                  children: [
                    // Customer Selection
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Customer',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: _showCustomerDialog,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.border),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.person,
                                          color: AppColors.textSecondary),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          cartProvider.selectedCustomer?.name ??
                                              'Customer Umum',
                                          style: const TextStyle(
                                              color: AppColors.textSecondary),
                                        ),
                                      ),
                                      const Icon(Icons.arrow_drop_down,
                                          color: AppColors.textSecondary),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tipe Pembayaran',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: cartProvider.paymentMethod,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                      value: 'cash', child: Text('Cash')),
                                  DropdownMenuItem(
                                      value: 'credit', child: Text('Kredit')),
                                  DropdownMenuItem(
                                      value: 'transfer',
                                      child: Text('Transfer Bank')),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    cartProvider.setPaymentMethod(value);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Payment Details
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    CurrencyFormatter.format(
                                        cartProvider.total),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _paidAmountController,
                                decoration: const InputDecoration(
                                  labelText: 'Bayar',
                                  prefixIcon: Icon(Icons.payment),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  final amount = double.tryParse(value
                                          .replaceAll(RegExp(r'[^\d]'), '')) ??
                                      0.0;
                                  cartProvider.setPaidAmount(amount);
                                },
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Kembali',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    CurrencyFormatter.format(
                                        cartProvider.changeAmount),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: cartProvider.changeAmount >= 0
                                          ? AppColors.success
                                          : AppColors.error,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          height: 120,
                          width: 120,
                          child: Consumer<TransactionProvider>(
                            builder: (context, transactionProvider, _) {
                              return ElevatedButton(
                                onPressed: cartProvider.isEmpty ||
                                        transactionProvider.isLoading
                                    ? null
                                    : _handleCheckout,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: transactionProvider.isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.payment, size: 32),
                                          SizedBox(height: 8),
                                          Text(
                                            'BAYAR',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                              );
                            },
                          ),
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
    );
  }

  void _showProductSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cari Produk'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Consumer<ProductProvider>(
            builder: (context, productProvider, _) {
              if (productProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: productProvider.products.length,
                itemBuilder: (context, index) {
                  final product = productProvider.products[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle:
                        Text(CurrencyFormatter.format(product.sellingPrice)),
                    trailing: Text('Stok: ${product.stock}'),
                    onTap: () {
                      context.read<CartProvider>().addItem(product);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('${product.name} ditambahkan ke keranjang'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                  );
                },
              );
            },
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
}
