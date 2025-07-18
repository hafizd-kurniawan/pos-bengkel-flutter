import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';
import 'package:pos_bengkel/core/utils/currency_formatter.dart';
import 'package:pos_bengkel/core/utils/date_formatter.dart';
import 'package:pos_bengkel/features/kasir/providers/transaction_provider.dart';

class KasirReceivablesScreen extends StatefulWidget {
  const KasirReceivablesScreen({super.key});

  @override
  State<KasirReceivablesScreen> createState() => _KasirReceivablesScreenState();
}

class _KasirReceivablesScreenState extends State<KasirReceivablesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().loadUnpaidTransactions();
      context.read<TransactionProvider>().loadPaidTransactions();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Piutang'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Belum Lunas'),
            Tab(text: 'Lunas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUnpaidTab(),
          _buildPaidTab(),
        ],
      ),
    );
  }

  Widget _buildUnpaidTab() {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, _) {
        if (transactionProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (transactionProvider.unpaidTransactions.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 64,
                  color: AppColors.textTertiary,
                ),
                SizedBox(height: 16),
                Text(
                  'Tidak ada piutang',
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
              color: AppColors.warning,
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
                      flex: 2,
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
                      child: Text('Jatuh Tempo',
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

            // Unpaid Transactions List
            Expanded(
              child: ListView.builder(
                itemCount: transactionProvider.unpaidTransactions.length,
                itemBuilder: (context, index) {
                  final transaction =
                      transactionProvider.unpaidTransactions[index];
                  final isOverdue = transaction.dueDate != null &&
                      transaction.dueDate!.isBefore(DateTime.now());

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          isOverdue ? AppColors.error.withOpacity(0.1) : null,
                      border: const Border(
                        bottom: BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(flex: 1, child: Text('${index + 1}')),
                        Expanded(
                            flex: 2, child: Text(transaction.invoiceNumber)),
                        Expanded(
                            flex: 2,
                            child: Text(DateFormatter.formatDate(
                                transaction.createdAt))),
                        Expanded(
                            flex: 2,
                            child: Text(
                                transaction.customerName ?? 'Customer Umum')),
                        Expanded(
                          flex: 2,
                          child: Text(
                            transaction.dueDate != null
                                ? DateFormatter.formatDate(transaction.dueDate!)
                                : '-',
                            style: TextStyle(
                              color: isOverdue ? AppColors.error : null,
                              fontWeight: isOverdue ? FontWeight.bold : null,
                            ),
                          ),
                        ),
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
                              } else if (value == 'pay') {
                                _showPaymentDialog(transaction);
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
                                value: 'pay',
                                child: Row(
                                  children: [
                                    Icon(Icons.payment),
                                    SizedBox(width: 8),
                                    Text('Bayar'),
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
    );
  }

  Widget _buildPaidTab() {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, _) {
        if (transactionProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (transactionProvider.paidTransactions.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: AppColors.textTertiary,
                ),
                SizedBox(height: 16),
                Text(
                  'Belum ada transaksi lunas',
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
              color: AppColors.success,
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
                      flex: 2,
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
                      child: Text('Tanggal Bayar',
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

            // Paid Transactions List
            Expanded(
              child: ListView.builder(
                itemCount: transactionProvider.paidTransactions.length,
                itemBuilder: (context, index) {
                  final transaction =
                      transactionProvider.paidTransactions[index];

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
                            flex: 2, child: Text(transaction.invoiceNumber)),
                        Expanded(
                            flex: 2,
                            child: Text(DateFormatter.formatDate(
                                transaction.createdAt))),
                        Expanded(
                            flex: 2,
                            child: Text(
                                transaction.customerName ?? 'Customer Umum')),
                        Expanded(
                            flex: 2,
                            child: Text(DateFormatter.formatDate(
                                transaction.updatedAt))),
                        Expanded(
                            flex: 2,
                            child: Text(CurrencyFormatter.format(
                                transaction.totalAmount))),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () =>
                                _showTransactionDetail(transaction),
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
              if (transaction.dueDate != null)
                Text(
                    'Jatuh Tempo: ${DateFormatter.formatDate(transaction.dueDate!)}'),
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

  void _showPaymentDialog(transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bayar Invoice ${transaction.invoiceNumber}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Total: ${CurrencyFormatter.format(transaction.totalAmount)}'),
            Text('Customer: ${transaction.customerName ?? "Customer Umum"}'),
            const SizedBox(height: 16),
            const Text('Konfirmasi pembayaran?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pembayaran berhasil diproses'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Bayar'),
          ),
        ],
      ),
    );
  }
}
