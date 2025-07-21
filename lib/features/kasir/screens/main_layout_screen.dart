import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';
import 'package:pos_bengkel/features/kasir/screens/kasir_pos_screen.dart';
import 'package:pos_bengkel/features/kasir/screens/kasir_invoice_screen.dart';
import 'package:pos_bengkel/features/kasir/screens/kasir_receivables_screen.dart';
import 'package:pos_bengkel/features/kasir/screens/pembelian/vehicle_purchase_screen.dart';
import 'package:pos_bengkel/features/kasir/screens/pembelian/purchase_history_screen.dart';
import 'package:pos_bengkel/features/kasir/screens/dashboard_screen.dart';
import 'package:pos_bengkel/features/kasir/screens/settings_screen.dart';
import 'package:pos_bengkel/features/servis/screens/service_reception_screen.dart';
import 'package:pos_bengkel/features/servis/screens/service_completion_screen.dart';
import 'package:pos_bengkel/features/servis/screens/reconditioning_screen.dart';
import 'package:pos_bengkel/features/master/screens/product_master_screen.dart';
import 'package:pos_bengkel/features/master/screens/customer_master_screen.dart';
import 'package:pos_bengkel/features/master/screens/vehicle_master_screen.dart';
import 'package:pos_bengkel/features/master/screens/service_master_screen.dart';
import 'package:pos_bengkel/features/master/screens/service_category_master_screen.dart';
import 'package:pos_bengkel/features/master/screens/service_price_list_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isExpanded = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Menu items dengan grouping yang lebih lengkap
  final List<NavigationItem> _navigationItems = [
    // Dashboard
    NavigationItem(
      id: 'dashboard',
      title: 'Dashboard',
      icon: Iconsax.element_4,
      activeIcon: Iconsax.element_45,
      isGroup: false,
    ),

    // Penjualan Group
    NavigationItem(
      id: 'penjualan_group',
      title: 'PENJUALAN',
      icon: Iconsax.shop,
      activeIcon: Iconsax.shop5,
      isGroup: true,
    ),
    NavigationItem(
      id: 'pos',
      title: 'Point of Sale',
      icon: Iconsax.receipt_text,
      activeIcon: Iconsax.receipt_text5,
      isGroup: false,
      parentGroup: 'penjualan_group',
    ),
    NavigationItem(
      id: 'invoice',
      title: 'Invoice',
      icon: Iconsax.document_text,
      activeIcon: Iconsax.document_text5,
      isGroup: false,
      parentGroup: 'penjualan_group',
    ),
    NavigationItem(
      id: 'piutang',
      title: 'Piutang',
      icon: Iconsax.wallet_money,
      activeIcon: Iconsax.wallet_money5,
      isGroup: false,
      parentGroup: 'penjualan_group',
    ),

    // Servis Group
    NavigationItem(
      id: 'servis_group',
      title: 'SERVIS',
      icon: Iconsax.setting_2,
      activeIcon: Iconsax.setting_25,
      isGroup: true,
    ),
    NavigationItem(
      id: 'penerimaan_servis',
      title: 'Penerimaan Servis',
      icon: Iconsax.clipboard_text,
      activeIcon: Iconsax.clipboard_text5,
      isGroup: false,
      parentGroup: 'servis_group',
    ),
    NavigationItem(
      id: 'service_completion',
      title: 'Pengambilan Setelah Servis',
      icon: Iconsax.tick_circle,
      activeIcon: Iconsax.tick_circle5,
      isGroup: false,
      parentGroup: 'servis_group',
    ),
    NavigationItem(
      id: 'reconditioning',
      title: 'Rekondisi Kendaraan',
      icon: Iconsax.setting_3,
      activeIcon: Iconsax.setting_35,
      isGroup: false,
      parentGroup: 'servis_group',
    ),

    // Data Master Group
    NavigationItem(
      id: 'master_group',
      title: 'DATA MASTER',
      icon: Iconsax.archive,
      activeIcon: Iconsax.archive5,
      isGroup: true,
    ),
    NavigationItem(
      id: 'products_master',
      title: 'Data Barang',
      icon: Iconsax.box,
      activeIcon: Iconsax.box5,
      isGroup: false,
      parentGroup: 'master_group',
      isReadOnly: true,
    ),
    NavigationItem(
      id: 'customers_master',
      title: 'Customer',
      icon: Iconsax.user,
      activeIcon: Iconsax.user5,
      isGroup: false,
      parentGroup: 'master_group',
      isReadOnly: false,
    ),
    NavigationItem(
      id: 'vehicles_master',
      title: 'Kendaraan',
      icon: Iconsax.car,
      activeIcon: Iconsax.car5,
      isGroup: false,
      parentGroup: 'master_group',
      isReadOnly: false,
    ),
    NavigationItem(
      id: 'services_master',
      title: 'Data Servis',
      icon: Iconsax.setting_2,
      activeIcon: Iconsax.setting_25,
      isGroup: false,
      parentGroup: 'master_group',
      isReadOnly: true,
    ),
    NavigationItem(
      id: 'service_categories_master',
      title: 'Kategori Servis',
      icon: Iconsax.category,
      activeIcon: Iconsax.category5,
      isGroup: false,
      parentGroup: 'master_group',
      isReadOnly: true,
    ),
    NavigationItem(
      id: 'price_lists_master',
      title: 'Price List Servis',
      icon: Iconsax.money_recive,
      activeIcon: Iconsax.money_recive5,
      isGroup: false,
      parentGroup: 'master_group',
      isReadOnly: true,
    ),

    // Pembelian Group
    NavigationItem(
      id: 'pembelian_group',
      title: 'PEMBELIAN',
      icon: Iconsax.buy_crypto,
      activeIcon: Iconsax.buy_crypto5,
      isGroup: true,
    ),
    NavigationItem(
      id: 'beli_kendaraan',
      title: 'Beli Kendaraan',
      icon: Iconsax.car,
      activeIcon: Iconsax.car5,
      isGroup: false,
      parentGroup: 'pembelian_group',
    ),
    NavigationItem(
      id: 'riwayat_pembelian',
      title: 'Riwayat Pembelian',
      icon: Iconsax.clock,
      activeIcon: Iconsax.clock5,
      isGroup: false,
      parentGroup: 'pembelian_group',
    ),

    // Settings
    NavigationItem(
      id: 'settings',
      title: 'Pengaturan',
      icon: Iconsax.setting_2,
      activeIcon: Iconsax.setting_25,
      isGroup: false,
    ),
  ];

  // Screens mapping
  final Map<String, Widget> _screens = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Initialize screens
    _initializeScreens();

    if (_isExpanded) {
      _animationController.forward();
    }
  }

  void _initializeScreens() {
    _screens.addAll({
      'dashboard': const DashboardScreen(),
      'pos': const KasirPosScreen(),
      'invoice': const KasirInvoiceScreen(),
      'piutang': const KasirReceivablesScreen(),
      'penerimaan_servis': const ServiceReceptionScreen(),
      'service_completion': const ServiceCompletionScreen(),
      'reconditioning': const ReconditioningScreen(),
      'products_master': const ProductMasterScreen(),
      'customers_master': const CustomerMasterScreen(),
      'vehicles_master': const VehicleMasterScreen(),
      'services_master': const ServiceMasterScreen(),
      'service_categories_master': const ServiceCategoryMasterScreen(),
      'price_lists_master': const ServicePriceListScreen(),
      'beli_kendaraan': const VehiclePurchaseScreen(),
      'riwayat_pembelian': const PurchaseHistoryScreen(),
      'settings': const SettingsScreen(),
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _selectItem(int index, String id) {
    final item = _navigationItems[index];
    if (!item.isGroup) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _getCurrentScreen() {
    final currentItem = _navigationItems[_selectedIndex];
    return _screens[currentItem.id] ?? const DashboardScreen();
  }

  String _getPageTitle() {
    final currentItem = _navigationItems[_selectedIndex];
    switch (currentItem.id) {
      case 'dashboard':
        return 'Dashboard';
      case 'pos':
        return 'Point of Sale';
      case 'invoice':
        return 'Invoice Penjualan';
      case 'piutang':
        return 'Manajemen Piutang';
      case 'penerimaan_servis':
        return 'Penerimaan Servis';
      case 'service_completion':
        return 'Pengambilan Setelah Servis';
      case 'reconditioning':
        return 'Rekondisi Kendaraan';
      case 'products_master':
        return 'Data Barang';
      case 'customers_master':
        return 'Data Customer';
      case 'vehicles_master':
        return 'Data Kendaraan';
      case 'services_master':
        return 'Data Servis';
      case 'service_categories_master':
        return 'Kategori Servis';
      case 'price_lists_master':
        return 'Price List Servis';
      case 'beli_kendaraan':
        return 'Pembelian Kendaraan';
      case 'riwayat_pembelian':
        return 'Riwayat Pembelian';
      case 'settings':
        return 'Pengaturan Sistem';
      default:
        return 'POS Bengkel';
    }
  }

  String _getPageSubtitle() {
    final currentItem = _navigationItems[_selectedIndex];
    switch (currentItem.id) {
      case 'dashboard':
        return 'Ringkasan aktivitas dan statistik terkini';
      case 'pos':
        return 'Transaksi penjualan harian';
      case 'invoice':
        return 'Daftar semua invoice penjualan';
      case 'piutang':
        return 'Kelola tagihan yang belum lunas';
      case 'penerimaan_servis':
        return 'Kelola penerimaan kendaraan untuk servis';
      case 'service_completion':
        return 'Kelola pengambilan kendaraan yang sudah selesai servis';
      case 'reconditioning':
        return 'Kelola pekerjaan rekondisi kendaraan';
      case 'products_master':
        return 'Kelola data produk dan spare parts (Read Only)';
      case 'customers_master':
        return 'Kelola data customer dan pelanggan';
      case 'vehicles_master':
        return 'Kelola data kendaraan customer';
      case 'services_master':
        return 'Kelola data layanan servis (Read Only)';
      case 'service_categories_master':
        return 'Kelola kategori layanan servis (Read Only)';
      case 'price_lists_master':
        return 'Kelola daftar harga layanan (Read Only)';
      case 'beli_kendaraan':
        return 'Catat pembelian kendaraan baru';
      case 'riwayat_pembelian':
        return 'Histori semua pembelian kendaraan';
      case 'settings':
        return 'Konfigurasi aplikasi dan preferensi';
      default:
        return 'Sistem manajemen bengkel modern';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: _isExpanded ? 280 : 80,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 10,
                      offset: const Offset(2, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.border,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary,
                                  AppColors.primaryDark,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.build_circle,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          if (_isExpanded) ...[
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'POS Bengkel',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    'v1.0.0',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          IconButton(
                            onPressed: _toggleSidebar,
                            icon: AnimatedRotation(
                              turns: _isExpanded ? 0 : 0.5,
                              duration: const Duration(milliseconds: 300),
                              child: const Icon(
                                Iconsax.arrow_left_2,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Navigation Items
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _navigationItems.length,
                        itemBuilder: (context, index) {
                          final item = _navigationItems[index];
                          final isSelected = _selectedIndex == index;

                          if (item.isGroup) {
                            return _buildGroupHeader(item);
                          }

                          return _buildNavigationItem(item, index, isSelected);
                        },
                      ),
                    ),

                    // User Profile
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: AppColors.border,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: const Icon(
                              Iconsax.user,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          if (_isExpanded) ...[
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'hafizd-kurniawan',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    'Kasir',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'logout') {
                                  _showLogoutDialog();
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'profile',
                                  child: Row(
                                    children: [
                                      Icon(Iconsax.user, size: 16),
                                      SizedBox(width: 8),
                                      Text('Profile'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'logout',
                                  child: Row(
                                    children: [
                                      Icon(Iconsax.logout, size: 16),
                                      SizedBox(width: 8),
                                      Text('Logout'),
                                    ],
                                  ),
                                ),
                              ],
                              child: const Icon(
                                Iconsax.more,
                                color: AppColors.textSecondary,
                                size: 16,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Bar
                Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.border,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getPageTitle(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              _getPageSubtitle(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Quick Actions
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Iconsax.notification),
                            tooltip: 'Notifikasi',
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Iconsax.search_normal),
                            tooltip: 'Cari',
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Online',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Page Content
                Expanded(
                  child: Container(
                    color: AppColors.background,
                    child: _getCurrentScreen(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupHeader(NavigationItem item) {
    if (!_isExpanded) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Text(
        item.title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textTertiary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildNavigationItem(NavigationItem item, int index, bool isSelected) {
    final hasParentGroup = item.parentGroup != null;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: _isExpanded ? 12 : 8,
        vertical: 2,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectItem(index, item.id),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: _isExpanded ? 16 : 12,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: AppColors.primary.withOpacity(0.2))
                  : null,
            ),
            child: Row(
              children: [
                if (hasParentGroup && _isExpanded) const SizedBox(width: 16),
                Icon(
                  isSelected ? item.activeIcon : item.icon,
                  size: 22,
                  color:
                      isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
                if (_isExpanded) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (item.isReadOnly) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
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
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

// Navigation Item Model dengan tambahan isReadOnly
class NavigationItem {
  final String id;
  final String title;
  final IconData icon;
  final IconData activeIcon;
  final bool isGroup;
  final String? parentGroup;
  final bool isReadOnly;

  NavigationItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.isGroup,
    this.parentGroup,
    this.isReadOnly = false,
  });
}
