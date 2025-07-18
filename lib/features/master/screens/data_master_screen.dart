import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';

class DataMasterScreen extends StatefulWidget {
  const DataMasterScreen({super.key});

  @override
  State<DataMasterScreen> createState() => _DataMasterScreenState();
}

class _DataMasterScreenState extends State<DataMasterScreen> {
  int _selectedIndex = 0;

  final List<MasterMenuItem> _menuItems = [
    MasterMenuItem(
      id: 'products',
      title: 'Data Barang',
      subtitle: 'Kelola data produk dan spare parts',
      icon: Iconsax.box,
      activeIcon: Iconsax.box5,
      color: AppColors.primary,
      isReadOnly: true,
    ),
    MasterMenuItem(
      id: 'customers',
      title: 'Customer',
      subtitle: 'Kelola data customer dan pelanggan',
      icon: Iconsax.user,
      activeIcon: Iconsax.user5,
      color: AppColors.success,
      isReadOnly: false,
    ),
    MasterMenuItem(
      id: 'vehicles',
      title: 'Kendaraan',
      subtitle: 'Kelola data kendaraan customer',
      icon: Iconsax.car,
      activeIcon: Iconsax.car5,
      color: AppColors.warning,
      isReadOnly: false,
    ),
    MasterMenuItem(
      id: 'services',
      title: 'Data Servis',
      subtitle: 'Kelola data layanan servis',
      icon: Iconsax.setting_2,
      activeIcon: Iconsax.setting_25,
      color: AppColors.info,
      isReadOnly: true,
    ),
    MasterMenuItem(
      id: 'service_categories',
      title: 'Kategori Servis',
      subtitle: 'Kelola kategori layanan servis',
      icon: Iconsax.category,
      activeIcon: Iconsax.category5,
      color: AppColors.secondary,
      isReadOnly: true,
    ),
    MasterMenuItem(
      id: 'price_lists',
      title: 'Price List Servis',
      subtitle: 'Kelola daftar harga layanan',
      icon: Iconsax.money_recive,
      activeIcon: Iconsax.money_recive5,
      color: AppColors.error,
      isReadOnly: true,
    ),
  ];

  Widget _getCurrentScreen() {
    final currentItem = _menuItems[_selectedIndex];

    // Return simple placeholder for now
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              currentItem.activeIcon,
              size: 64,
              color: currentItem.color,
            ),
            const SizedBox(height: 16),
            Text(
              '${currentItem.title} - Coming Soon',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currentItem.subtitle,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentTitle() {
    return _menuItems[_selectedIndex].title;
  }

  String _getCurrentSubtitle() {
    return _menuItems[_selectedIndex].subtitle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Sidebar Menu
          Container(
            width: 320,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(
                right: BorderSide(color: AppColors.border),
              ),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.border),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Iconsax.archive,
                        color: AppColors.primary,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DATA MASTER',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Kelola data master sistem',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Menu Items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      final item = _menuItems[index];
                      final isSelected = _selectedIndex == index;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? item.color.withOpacity(0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(
                                        color: item.color.withOpacity(0.3))
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? item.color
                                          : item.color.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      isSelected ? item.activeIcon : item.icon,
                                      color: isSelected
                                          ? Colors.white
                                          : item.color,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.title,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w600
                                                      : FontWeight.w500,
                                                  color: isSelected
                                                      ? item.color
                                                      : AppColors.textPrimary,
                                                ),
                                              ),
                                            ),
                                            if (item.isReadOnly)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.warning
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: const Text(
                                                  'READ',
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.warning,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item.subtitle,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: isSelected
                                                ? item.color.withOpacity(0.8)
                                                : AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Footer Info
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Iconsax.info_circle,
                        color: AppColors.info,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Data yang ditandai READ hanya bisa dilihat, tidak bisa diubah.',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.info,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      bottom: BorderSide(color: AppColors.border),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getCurrentTitle(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getCurrentSubtitle(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _menuItems[_selectedIndex].color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _menuItems[_selectedIndex].activeIcon,
                              color: _menuItems[_selectedIndex].color,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'hafizd-kurniawan',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _menuItems[_selectedIndex].color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: _getCurrentScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MasterMenuItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final IconData activeIcon;
  final Color color;
  final bool isReadOnly;

  MasterMenuItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.activeIcon,
    required this.color,
    required this.isReadOnly,
  });
}
