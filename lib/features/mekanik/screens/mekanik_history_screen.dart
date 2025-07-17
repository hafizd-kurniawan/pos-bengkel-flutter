import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class MekanikHistoryScreen extends StatefulWidget {
  const MekanikHistoryScreen({super.key});

  @override
  State<MekanikHistoryScreen> createState() => _MekanikHistoryScreenState();
}

class _MekanikHistoryScreenState extends State<MekanikHistoryScreen> {
  final _searchController = TextEditingController();
  String _selectedPeriod = 'Bulan Ini';
  String _selectedStatus = 'Semua';

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
        title: const Text('Riwayat Pekerjaan'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: Column(
        children: [
          // Search and Filters
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Cari riwayat pekerjaan...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _FilterDropdown(
                        label: 'Periode',
                        value: _selectedPeriod,
                        items: ['Hari Ini', 'Minggu Ini', 'Bulan Ini', '3 Bulan', '6 Bulan', 'Tahun Ini'],
                        onChanged: (value) {
                          setState(() {
                            _selectedPeriod = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FilterDropdown(
                        label: 'Status',
                        value: _selectedStatus,
                        items: ['Semua', AppConstants.statusCompleted, AppConstants.statusCancelled],
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Statistics Summary
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(16),
            child: _StatisticsSummary(),
          ),
          
          // History List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 25, // Demo data
              itemBuilder: (context, index) {
                final isCompleted = index % 4 != 3; // 75% completed, 25% cancelled
                final date = DateTime.now().subtract(Duration(days: index));
                
                return _HistoryCard(
                  serviceCode: 'SJ-2024-${(index + 100).toString().padLeft(3, '0')}',
                  customerName: 'Pelanggan ${index + 1}',
                  vehiclePlate: 'B${(5000 + index).toString()}XY',
                  complaint: _getRandomComplaint(index),
                  status: isCompleted ? AppConstants.statusCompleted : AppConstants.statusCancelled,
                  statusColor: isCompleted ? AppColors.success : AppColors.error,
                  date: date,
                  actualCost: (index + 1) * 125000.0,
                  onTap: () => _showHistoryDetail(context, index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getRandomComplaint(int index) {
    final complaints = [
      'Mesin terasa kasar saat idle',
      'Rem blong dan berbunyi',
      'AC tidak dingin',
      'Oli mesin perlu diganti',
      'Lampu depan mati',
      'Suspensi keras',
      'Klakson tidak bunyi',
      'Radiator bocor',
      'Kampas rem habis',
      'Filter udara kotor',
    ];
    return complaints[index % complaints.length];
  }

  void _showHistoryDetail(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => _HistoryDetailSheet(
          scrollController: scrollController,
          index: index,
        ),
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          )).toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }
}

class _StatisticsSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'Total Selesai',
            value: '25',
            icon: Icons.check_circle,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            title: 'Rata-rata',
            value: '4.8★',
            icon: Icons.star,
            color: AppColors.warning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            title: 'Pendapatan',
            value: 'Rp 3.2M',
            icon: Icons.attach_money,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final String serviceCode;
  final String customerName;
  final String vehiclePlate;
  final String complaint;
  final String status;
  final Color statusColor;
  final DateTime date;
  final double actualCost;
  final VoidCallback onTap;

  const _HistoryCard({
    required this.serviceCode,
    required this.customerName,
    required this.vehiclePlate,
    required this.complaint,
    required this.status,
    required this.statusColor,
    required this.date,
    required this.actualCost,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    
    final dateFormatter = DateFormat('dd MMM yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    serviceCode,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Chip(
                    label: Text(
                      status,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: statusColor.withOpacity(0.1),
                    labelStyle: TextStyle(color: statusColor),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Customer & Vehicle Info
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    customerName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.directions_car,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    vehiclePlate,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Complaint
              Text(
                'Keluhan: $complaint',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Date & Cost
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateFormatter.format(date),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Text(
                    formatter.format(actualCost),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
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

class _HistoryDetailSheet extends StatelessWidget {
  final ScrollController scrollController;
  final int index;

  const _HistoryDetailSheet({
    required this.scrollController,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final isCompleted = index % 4 != 3;
    final status = isCompleted ? AppConstants.statusCompleted : AppConstants.statusCancelled;
    final statusColor = isCompleted ? AppColors.success : AppColors.error;
    final date = DateTime.now().subtract(Duration(days: index));

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Riwayat Detail',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Chip(
                        label: Text(status),
                        backgroundColor: statusColor.withOpacity(0.1),
                        labelStyle: TextStyle(color: statusColor),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Job Info
                  _DetailRow('Kode Service', 'SJ-2024-${(index + 100).toString().padLeft(3, '0')}'),
                  _DetailRow('Pelanggan', 'Pelanggan ${index + 1}'),
                  _DetailRow('Kendaraan', 'Toyota Avanza - B${(5000 + index).toString()}XY'),
                  _DetailRow('Tanggal Mulai', DateFormat('dd MMMM yyyy HH:mm').format(date)),
                  _DetailRow('Tanggal Selesai', DateFormat('dd MMMM yyyy HH:mm').format(date.add(const Duration(hours: 3)))),
                  _DetailRow('Keluhan', _getRandomComplaint(index)),
                  _DetailRow('Diagnosis', 'Perlu pergantian oli dan filter udara'),
                  _DetailRow('Hasil Pekerjaan', isCompleted ? 'Pekerjaan selesai dengan baik' : 'Dibatalkan oleh pelanggan'),
                  
                  const SizedBox(height: 24),
                  
                  // Service Details
                  Text(
                    'Detail Service',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  ...List.generate(2, (detailIndex) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Service ${detailIndex + 1}',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  '1x - ${detailIndex == 0 ? 'Oil Change' : 'Filter Replacement'}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            formatter.format((detailIndex + 1) * 75000),
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                  
                  const SizedBox(height: 24),
                  
                  // Cost Summary
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
                            Text(
                              'Estimasi Biaya',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              formatter.format((index + 1) * 150000),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Biaya Aktual',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formatter.format((index + 1) * 125000),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Workflow History
                  Text(
                    'Riwayat Workflow',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  ...List.generate(4, (historyIndex) {
                    final historyStatuses = ['Dibuat', 'Dimulai', 'Progress', isCompleted ? 'Selesai' : 'Dibatalkan'];
                    final historyTimes = ['08:00', '09:15', '11:30', '14:45'];
                    final historyDates = [
                      date,
                      date.add(const Duration(hours: 1)),
                      date.add(const Duration(hours: 2)),
                      date.add(const Duration(hours: 3)),
                    ];
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: historyIndex == 3 && !isCompleted 
                                  ? AppColors.error 
                                  : AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  historyStatuses[historyIndex],
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${DateFormat('dd MMM yyyy').format(historyDates[historyIndex])} • ${historyTimes[historyIndex]}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  
                  if (isCompleted) ...[
                    const SizedBox(height: 24),
                    
                    // Rating Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rating Pelanggan',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: List.generate(5, (starIndex) => Icon(
                              Icons.star,
                              color: starIndex < 4 ? AppColors.warning : AppColors.grey300,
                              size: 20,
                            )),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pelayanan bagus dan cepat. Mekaniknya profesional.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRandomComplaint(int index) {
    final complaints = [
      'Mesin terasa kasar saat idle',
      'Rem blong dan berbunyi',
      'AC tidak dingin',
      'Oli mesin perlu diganti',
      'Lampu depan mati',
      'Suspensi keras',
      'Klakson tidak bunyi',
      'Radiator bocor',
      'Kampas rem habis',
      'Filter udara kotor',
    ];
    return complaints[index % complaints.length];
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}