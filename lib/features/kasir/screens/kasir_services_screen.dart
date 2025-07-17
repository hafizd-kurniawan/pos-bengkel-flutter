import 'package:flutter/material.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class KasirServicesScreen extends StatefulWidget {
  const KasirServicesScreen({super.key});

  @override
  State<KasirServicesScreen> createState() => _KasirServicesScreenState();
}

class _KasirServicesScreenState extends State<KasirServicesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('Servis'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.white.withOpacity(0.7),
          indicatorColor: AppColors.white,
          tabs: const [
            Tab(text: 'Daftar Servis'),
            Tab(text: 'Pekerjaan Aktif'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ServiceListTab(),
          _ActiveJobsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateServiceJobDialog();
        },
        child: const Icon(Icons.add),
        tooltip: 'Buat Service Job Baru',
      ),
    );
  }

  void _showCreateServiceJobDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buat Service Job Baru'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Pelanggan',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Kendaraan',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.directions_car),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Keluhan',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
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
                  content: Text('Service job berhasil dibuat'),
                ),
              );
            },
            child: const Text('Buat'),
          ),
        ],
      ),
    );
  }
}

class _ServiceListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Container(
          color: AppColors.white,
          padding: const EdgeInsets.all(16),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Cari servis...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        
        // Service Categories
        Container(
          height: 120,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _ServiceCategoryCard(
                title: 'Engine',
                icon: Icons.settings,
                count: 12,
              ),
              _ServiceCategoryCard(
                title: 'Brake',
                icon: Icons.disc_full,
                count: 8,
              ),
              _ServiceCategoryCard(
                title: 'Tire',
                icon: Icons.circle,
                count: 5,
              ),
              _ServiceCategoryCard(
                title: 'AC',
                icon: Icons.ac_unit,
                count: 6,
              ),
            ],
          ),
        ),
        
        // Service List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 15, // Demo data
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.build,
                      color: AppColors.success,
                    ),
                  ),
                  title: Text('Service ${index + 1}'),
                  subtitle: Text('Kategori Engine - Rp 150.000'),
                  trailing: Chip(
                    label: const Text('Aktif'),
                    backgroundColor: AppColors.success.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: AppColors.success,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    // Show service detail
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ActiveJobsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Demo data
      itemBuilder: (context, index) {
        final statuses = [
          AppConstants.statusPending,
          AppConstants.statusInProgress,
          AppConstants.statusCompleted,
        ];
        final colors = [
          AppColors.warning,
          AppColors.info,
          AppColors.success,
        ];
        final status = statuses[index % statuses.length];
        final color = colors[index % colors.length];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
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
                      backgroundColor: color.withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: color,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Pelanggan ${index + 1}',
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
                      'B${(1234 + index).toString()}XYZ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Keluhan: Mesin terasa kasar saat idle',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Estimasi: Rp ${((index + 1) * 150000).toString()}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // View detail
                      },
                      child: const Text('Lihat Detail'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ServiceCategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final int count;

  const _ServiceCategoryCard({
    required this.title,
    required this.icon,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        child: InkWell(
          onTap: () {
            // Filter by category
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '$count item',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}