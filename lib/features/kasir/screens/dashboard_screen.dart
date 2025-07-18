import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';
import 'package:pos_bengkel/core/utils/currency_formatter.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                title: 'Penjualan Hari Ini',
                value: CurrencyFormatter.format(2500000),
                icon: Iconsax.money_recive,
                color: AppColors.success,
                trend: '+12%',
              ),
              _buildStatCard(
                title: 'Transaksi Hari Ini',
                value: '24',
                icon: Iconsax.receipt_text,
                color: AppColors.primary,
                trend: '+8%',
              ),
              _buildStatCard(
                title: 'Piutang Aktif',
                value: CurrencyFormatter.format(850000),
                icon: Iconsax.wallet_money,
                color: AppColors.warning,
                trend: '-3%',
              ),
              _buildStatCard(
                title: 'Kendaraan Dibeli',
                value: '5',
                icon: Iconsax.car,
                color: AppColors.info,
                trend: '+2',
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Charts Row
          Row(
            children: [
              // Sales Chart
              Expanded(
                flex: 2,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Iconsax.chart,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Penjualan 7 Hari Terakhir',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Lihat Detail'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          height: 200,
                          child: const Center(
                            child: Text(
                              'Chart akan ditampilkan di sini',
                              style: TextStyle(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Recent Activities
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Iconsax.clock,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Aktivitas Terbaru',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 200,
                          child: ListView(
                            children: [
                              _buildActivityItem(
                                'Transaksi INV-20250718-001 berhasil',
                                '2 menit yang lalu',
                                Iconsax.tick_circle,
                                AppColors.success,
                              ),
                              _buildActivityItem(
                                'Customer baru ditambahkan',
                                '15 menit yang lalu',
                                Iconsax.user_add,
                                AppColors.info,
                              ),
                              _buildActivityItem(
                                'Kendaraan Honda Vario dibeli',
                                '1 jam yang lalu',
                                Iconsax.car,
                                AppColors.primary,
                              ),
                              _buildActivityItem(
                                'Piutang INV-20250717-005 lunas',
                                '3 jam yang lalu',
                                Iconsax.wallet_check,
                                AppColors.success,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Recent Transactions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Iconsax.receipt_text,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Transaksi Terbaru',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Lihat Semua'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(1.5),
                      3: FlexColumnWidth(1),
                    },
                    children: [
                      const TableRow(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Invoice',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Customer',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Status',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      _buildTransactionRow(
                          'INV-20250718-001', 'John Doe', 150000, 'Lunas'),
                      _buildTransactionRow(
                          'INV-20250718-002', 'Jane Smith', 250000, 'Pending'),
                      _buildTransactionRow(
                          'INV-20250717-045', 'Ahmad Rahman', 180000, 'Lunas'),
                      _buildTransactionRow(
                          'INV-20250717-044', 'Siti Aminah', 320000, 'Lunas'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String trend,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: trend.startsWith('+')
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    trend,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: trend.startsWith('+')
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
      String title, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              size: 14,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTransactionRow(
      String invoice, String customer, double total, String status) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(invoice),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(customer),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(CurrencyFormatter.format(total)),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: status == 'Lunas'
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color:
                    status == 'Lunas' ? AppColors.success : AppColors.warning,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
