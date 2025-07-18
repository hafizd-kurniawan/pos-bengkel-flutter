import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';
import 'package:pos_bengkel/core/utils/currency_formatter.dart';
import 'package:pos_bengkel/core/utils/date_formatter.dart';
import 'package:pos_bengkel/features/kasir/providers/transaction_provider.dart';

class KasirInvoiceScreen extends StatefulWidget {
  const KasirInvoiceScreen({super.key});

  @override
  State<KasirInvoiceScreen> createState() => _KasirInvoiceScreenState();
}

class _KasirInvoiceScreenState extends State<KasirInvoiceScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().loadTransactions();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Invoice Penjualan'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Cari invoice atau customer...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      // Implement search
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // Show filter dialog
                  },
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filter'),
                ),
              ],
            ),
          ),

          // Transactions List
          Expanded(
            child: Consumer<TransactionProvider>(
              builder: (context, transactionProvider, _) {
                if (transactionProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (transactionProvider.transactions.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada transaksi',
                          style: TextStyle(
                            fontSize: 18,
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
                              flex: 2,
                              child: Text('Invoice',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 3,
                              child: Text('Tanggal Transaksi',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 2,
                              child: Text('Customer',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 2,
                              child: Text('Kasir',
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

                    // Transactions List
                    Expanded(
                      child: ListView.builder(
                        itemCount: transactionProvider.transactions.length,
                        itemBuilder: (context, index) {
                          final transaction =
                              transactionProvider.transactions[index];
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
                                    flex: 2,
                                    child: Text(transaction.invoiceNumber)),
                                Expanded(
                                    flex: 3,
                                    child: Text(DateFormatter.formatDateTime(
                                        transaction.createdAt))),
                                Expanded(
                                    flex: 2,
                                    child: Text(transaction.customerName ??
                                        'Customer Umum')),
                                Expanded(flex: 2, child: Text('Demo Kasir')),
                                Expanded(
                                    flex: 2,
                                    child: Text(CurrencyFormatter.format(
                                        transaction.totalAmount))),
                                Expanded(
                                  flex: 1,
                                  child: PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'view') {
                                        _showTransactionDetail(transaction);
                                      } else if (value == 'print') {
                                        _printInvoice(transaction);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'view',
                                        child: Row(
                                          children: [
                                            Icon(Icons.visibility),
                                            SizedBox(width: 8),
                                            Text('Lihat Detail'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'print',
                                        child: Row(
                                          children: [
                                            Icon(Icons.print),
                                            SizedBox(width: 8),
                                            Text('Cetak'),
                                          ],
                                        ),
                                      ),
                                    ],
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
        ],
      ),
    );
  }

  void _showTransactionDetail(transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Transaksi ${transaction.invoiceNumber}'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer: ${transaction.customerName ?? "Customer Umum"}'),
              Text(
                  'Tanggal: ${DateFormatter.formatDateTime(transaction.createdAt)}'),
              Text('Metode Pembayaran: ${transaction.paymentMethod}'),
              Text('Status: ${transaction.status}'),
              const SizedBox(height: 16),
              const Text('Item:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: transaction.items.length,
                  itemBuilder: (context, index) {
                    final item = transaction.items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(
                                  '${item.productName} x${item.quantity}')),
                          Text(CurrencyFormatter.format(item.subtotal)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    CurrencyFormatter.format(transaction.totalAmount),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
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

  void _printInvoice(transaction) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur cetak invoice akan segera tersedia'),
        backgroundColor: AppColors.info,
      ),
    );
  }
}
