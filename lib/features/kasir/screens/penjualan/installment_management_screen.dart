import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';
import 'package:pos_bengkel/core/utils/currency_formatter.dart';
import 'package:pos_bengkel/core/utils/date_formatter.dart';
import 'package:pos_bengkel/features/kasir/providers/installment_provider.dart';
import 'package:pos_bengkel/shared/models/installment.dart';

class InstallmentManagementScreen extends StatefulWidget {
  const InstallmentManagementScreen({super.key});

  @override
  State<InstallmentManagementScreen> createState() => _InstallmentManagementScreenState();
}

class _InstallmentManagementScreenState extends State<InstallmentManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InstallmentProvider>().loadActiveInstallments();
      context.read<InstallmentProvider>().loadOverduePayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<InstallmentProvider>(
        builder: (context, installmentProvider, child) {
          return Column(
            children: [
              _buildOverdueAlert(installmentProvider),
              Expanded(
                child: installmentProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildInstallmentList(installmentProvider),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPaymentDialog(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Iconsax.money_add, color: Colors.white),
      ),
    );
  }

  Widget _buildOverdueAlert(InstallmentProvider provider) {
    if (provider.overduePayments.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Iconsax.warning_2, color: Colors.red, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cicilan Terlambat',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
                Text(
                  '${provider.overduePayments.length} pembayaran terlambat',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showOverduePayments(context, provider),
            child: Text('Lihat', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildInstallmentList(InstallmentProvider provider) {
    if (provider.installments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.document_text, size: 64, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(
              'Belum ada cicilan aktif',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.installments.length,
      itemBuilder: (context, index) {
        final installment = provider.installments[index];
        return _buildInstallmentCard(installment, provider);
      },
    );
  }

  Widget _buildInstallmentCard(Installment installment, InstallmentProvider provider) {
    final remainingBalance = provider.getRemainingBalance(installment.installmentId!);
    final nextDueDate = provider.getNextPaymentDueDate(installment.installmentId!);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showInstallmentDetails(context, installment),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          installment.customerName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${installment.installmentId}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(installment.status).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getStatusText(installment.status),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(installment.status),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Pinjaman:', style: TextStyle(fontSize: 12)),
                        Text(
                          CurrencyFormatter.format(installment.totalAmount),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Sisa Cicilan:', style: TextStyle(fontSize: 12)),
                        Text(
                          CurrencyFormatter.format(remainingBalance),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cicilan/Bulan:', style: TextStyle(fontSize: 12)),
                        Text(
                          CurrencyFormatter.format(installment.monthlyPayment),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (nextDueDate != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Iconsax.calendar,
                      size: 16,
                      color: _isOverdue(nextDueDate) ? Colors.red : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Jatuh Tempo: ${DateFormatter.formatDate(nextDueDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: _isOverdue(nextDueDate) ? Colors.red : AppColors.textSecondary,
                        fontWeight: _isOverdue(nextDueDate) ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'defaulted':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'Aktif';
      case 'completed':
        return 'Selesai';
      case 'defaulted':
        return 'Macet';
      default:
        return status;
    }
  }

  bool _isOverdue(DateTime date) {
    return DateTime.now().isAfter(date);
  }

  void _showPaymentDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PaymentDialog(),
    );
  }

  void _showInstallmentDetails(BuildContext context, Installment installment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstallmentDetailScreen(installment: installment),
      ),
    );
  }

  void _showOverduePayments(BuildContext context, InstallmentProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pembayaran Terlambat'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: provider.overduePayments.map((payment) {
              return ListTile(
                title: Text('Cicilan #${payment.installmentNumber}'),
                subtitle: Text('Jatuh Tempo: ${DateFormatter.formatDate(payment.dueDate)}'),
                trailing: Text(CurrencyFormatter.format(payment.amount)),
              );
            }).toList(),
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

class _PaymentDialog extends StatefulWidget {
  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Consumer<InstallmentProvider>(
          builder: (context, provider, child) {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bayar Cicilan',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<String>(
                    value: provider.selectedInstallmentId,
                    decoration: InputDecoration(
                      labelText: 'Pilih Cicilan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: provider.installments.map((installment) {
                      return DropdownMenuItem<String>(
                        value: installment.installmentId,
                        child: Text(installment.customerName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      provider.setSelectedInstallmentId(value);
                    },
                    validator: (value) {
                      if (value == null) return 'Pilih cicilan terlebih dahulu';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Jumlah Pembayaran',
                      prefixText: 'Rp ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      final amount = double.tryParse(value) ?? 0;
                      provider.setPaymentAmount(amount);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Masukkan jumlah pembayaran';
                      if (double.tryParse(value) == null || double.parse(value) <= 0) {
                        return 'Jumlah harus berupa angka positif';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: provider.paymentMethod,
                    decoration: InputDecoration(
                      labelText: 'Metode Pembayaran',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'cash', child: Text('Tunai')),
                      DropdownMenuItem(value: 'transfer', child: Text('Transfer')),
                      DropdownMenuItem(value: 'credit', child: Text('Kredit')),
                    ],
                    onChanged: (value) {
                      if (value != null) provider.setPaymentMethod(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Catatan (Opsional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      provider.setNotes(value);
                    },
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: provider.canProcessPayment
                          ? () => _processPayment(provider)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: provider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Proses Pembayaran',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _processPayment(InstallmentProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await provider.processInstallmentPayment();
    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pembayaran berhasil diproses!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Gagal memproses pembayaran'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class InstallmentDetailScreen extends StatefulWidget {
  final Installment installment;

  const InstallmentDetailScreen({super.key, required this.installment});

  @override
  State<InstallmentDetailScreen> createState() => _InstallmentDetailScreenState();
}

class _InstallmentDetailScreenState extends State<InstallmentDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<InstallmentProvider>();
      provider.loadInstallmentPayments(widget.installment.installmentId!);
      provider.loadInstallmentSchedule(widget.installment.installmentId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Detail Cicilan'),
        backgroundColor: AppColors.surface,
      ),
      body: Consumer<InstallmentProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInstallmentInfo(widget.installment, provider),
                const SizedBox(height: 24),
                _buildPaymentHistory(provider),
                const SizedBox(height: 24),
                _buildPaymentSchedule(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInstallmentInfo(Installment installment, InstallmentProvider provider) {
    final remainingBalance = provider.getRemainingBalance(installment.installmentId!);
    final totalPaid = provider.getTotalPaymentsMade(installment.installmentId!);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Cicilan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Nama Pembeli', installment.customerName),
            _buildInfoRow('Total Pinjaman', CurrencyFormatter.format(installment.totalAmount)),
            _buildInfoRow('Uang Muka', CurrencyFormatter.format(installment.downPayment)),
            _buildInfoRow('Jumlah Bulan', '${installment.installmentMonths} bulan'),
            _buildInfoRow('Cicilan/Bulan', CurrencyFormatter.format(installment.monthlyPayment)),
            _buildInfoRow('Bunga', '${installment.interestRate}%'),
            const Divider(),
            _buildInfoRow('Total Dibayar', CurrencyFormatter.format(totalPaid), isHighlight: true),
            _buildInfoRow('Sisa Cicilan', CurrencyFormatter.format(remainingBalance), isHighlight: true),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isHighlight ? AppColors.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistory(InstallmentProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Riwayat Pembayaran',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            if (provider.payments.isEmpty)
              Center(
                child: Text(
                  'Belum ada pembayaran',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              )
            else
              ...provider.payments.map((payment) => _buildPaymentItem(payment)),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentItem(InstallmentPayment payment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cicilan #${payment.installmentNumber}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                payment.paidDate != null
                    ? DateFormatter.formatDate(payment.paidDate!)
                    : 'Belum dibayar',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.format(payment.amount),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getPaymentStatusColor(payment.status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _getPaymentStatusText(payment.status),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _getPaymentStatusColor(payment.status),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSchedule(InstallmentProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jadwal Pembayaran',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            if (provider.currentSchedule.isEmpty)
              Center(
                child: Text(
                  'Jadwal tidak tersedia',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              )
            else
              ...provider.currentSchedule.map((schedule) => _buildScheduleItem(schedule)),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(InstallmentSchedule schedule) {
    final isOverdue = DateTime.now().isAfter(schedule.dueDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOverdue ? Colors.red.withOpacity(0.05) : AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: isOverdue ? Border.all(color: Colors.red.withOpacity(0.3)) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cicilan #${schedule.installmentNumber}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isOverdue ? Colors.red : null,
                ),
              ),
              Text(
                DateFormatter.formatDate(schedule.dueDate),
                style: TextStyle(
                  fontSize: 12,
                  color: isOverdue ? Colors.red : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Text(
            CurrencyFormatter.format(schedule.amount),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isOverdue ? Colors.red : null,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPaymentStatusColor(String status) {
    switch (status) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'overdue':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getPaymentStatusText(String status) {
    switch (status) {
      case 'paid':
        return 'Lunas';
      case 'pending':
        return 'Tertunda';
      case 'overdue':
        return 'Terlambat';
      default:
        return status;
    }
  }
}