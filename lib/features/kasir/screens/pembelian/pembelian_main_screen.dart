import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';
import 'package:pos_bengkel/features/kasir/screens/pembelian/vehicle_purchase_screen.dart';
import 'package:pos_bengkel/features/kasir/screens/pembelian/purchase_history_screen.dart';

class PembelianMainScreen extends StatefulWidget {
  const PembelianMainScreen({super.key});

  @override
  State<PembelianMainScreen> createState() => _PembelianMainScreenState();
}

class _PembelianMainScreenState extends State<PembelianMainScreen>
    with SingleTickerProviderStateMixin {
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
        title: const Text('Pembelian Kendaraan'),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppColors.surface,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(
              icon: Icon(Iconsax.car),
              text: 'Beli Kendaraan',
            ),
            Tab(
              icon: Icon(Iconsax.document_text),
              text: 'Riwayat Pembelian',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          VehiclePurchaseScreen(),
          PurchaseHistoryScreen(),
        ],
      ),
    );
  }
}
