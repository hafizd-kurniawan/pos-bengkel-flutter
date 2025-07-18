import 'package:flutter/material.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class MekanikJobsScreen extends StatefulWidget {
  const MekanikJobsScreen({super.key});

  @override
  State<MekanikJobsScreen> createState() => _MekanikJobsScreenState();
}

class _MekanikJobsScreenState extends State<MekanikJobsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pekerjaan Saya'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.white.withOpacity(0.7),
          indicatorColor: AppColors.white,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'In Progress'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Cari pekerjaan...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _JobListTab(status: AppConstants.statusPending),
                _JobListTab(status: AppConstants.statusInProgress),
                _JobListTab(status: AppConstants.statusCompleted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JobListTab extends StatelessWidget {
  final String status;

  const _JobListTab({required this.status});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status) {
      case AppConstants.statusPending:
        statusColor = AppColors.warning;
        break;
      case AppConstants.statusInProgress:
        statusColor = AppColors.info;
        break;
      case AppConstants.statusCompleted:
        statusColor = AppColors.success;
        break;
      default:
        statusColor = AppColors.grey500;
    }

    // Demo data - in real app, this would be filtered by status
    final jobCount = status == AppConstants.statusPending ? 3 :
                    status == AppConstants.statusInProgress ? 2 : 8;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jobCount,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () => _showJobDetail(context, index, status),
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
                        'SJ-2024-${(index + 1).toString().padLeft(3, '0')}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Chip(
                        label: Text(status),
                        backgroundColor: statusColor.withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Customer & Vehicle Info
                  Row(
                    children: [
                      Expanded(
                        child: _InfoRow(
                          icon: Icons.person,
                          label: 'Pelanggan',
                          value: 'Pelanggan ${index + 1}',
                        ),
                      ),
                      Expanded(
                        child: _InfoRow(
                          icon: Icons.directions_car,
                          label: 'Kendaraan',
                          value: 'B${(1234 + index).toString()}XYZ',
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Date & Complaint
                  _InfoRow(
                    icon: Icons.access_time,
                    label: 'Tanggal',
                    value: '${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
                  ),
                  
                  const SizedBox(height: 8),
                  
                  _InfoRow(
                    icon: Icons.report_problem,
                    label: 'Keluhan',
                    value: 'Mesin terasa kasar saat idle dan suara tidak normal',
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Action Buttons
                  Row(
                    children: [
                      if (status == AppConstants.statusPending) ...[
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _startJob(context, index),
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Mulai'),
                          ),
                        ),
                      ] else if (status == AppConstants.statusInProgress) ...[
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _updateJob(context, index),
                            icon: const Icon(Icons.edit),
                            label: const Text('Update'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _completeJob(context, index),
                            icon: const Icon(Icons.check),
                            label: const Text('Selesai'),
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _viewJobDetail(context, index),
                            icon: const Icon(Icons.visibility),
                            label: const Text('Lihat Detail'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month];
  }

  void _showJobDetail(BuildContext context, int index, String status) {
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
        builder: (context, scrollController) => _JobDetailSheet(
          scrollController: scrollController,
          index: index,
          status: status,
        ),
      ),
    );
  }

  void _startJob(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mulai Pekerjaan'),
        content: const Text('Apakah Anda yakin ingin memulai pekerjaan ini?'),
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
                  content: Text('Pekerjaan dimulai'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Mulai'),
          ),
        ],
      ),
    );
  }

  void _updateJob(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Pekerjaan'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Diagnosis',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Catatan Progress',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
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
                  content: Text('Pekerjaan berhasil diupdate'),
                ),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _completeJob(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selesaikan Pekerjaan'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Hasil Pekerjaan',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Biaya Aktual',
                border: OutlineInputBorder(),
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
            ),
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
                  content: Text('Pekerjaan selesai'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }

  void _viewJobDetail(BuildContext context, int index) {
    _showJobDetail(context, index, status);
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _JobDetailSheet extends StatelessWidget {
  final ScrollController scrollController;
  final int index;
  final String status;

  const _JobDetailSheet({
    required this.scrollController,
    required this.index,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status) {
      case AppConstants.statusPending:
        statusColor = AppColors.warning;
        break;
      case AppConstants.statusInProgress:
        statusColor = AppColors.info;
        break;
      case AppConstants.statusCompleted:
        statusColor = AppColors.success;
        break;
      default:
        statusColor = AppColors.grey500;
    }

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
                        'Detail Pekerjaan',
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
                  _DetailRow('Kode Service', 'SJ-2024-${(index + 1).toString().padLeft(3, '0')}'),
                  _DetailRow('Pelanggan', 'Pelanggan ${index + 1}'),
                  _DetailRow('Kendaraan', 'Toyota Avanza - B${(1234 + index).toString()}XYZ'),
                  _DetailRow('Tanggal Service', '${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}'),
                  _DetailRow('Keluhan', 'Mesin terasa kasar saat idle dan suara tidak normal'),
                  _DetailRow('Estimasi Biaya', 'Rp 450.000'),
                  
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
                                  '1x - Oil Change',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Rp 150.000',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                  
                  const SizedBox(height: 24),
                  
                  // Progress History
                  Text(
                    'Riwayat Progress',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  ...List.generate(3, (historyIndex) {
                    final historyStatuses = ['Created', 'In Progress', 'Completed'];
                    final historyTimes = ['08:00', '10:30', '15:45'];
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: historyIndex <= 1 ? AppColors.primary : AppColors.grey300,
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
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  historyTimes[historyIndex],
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month];
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