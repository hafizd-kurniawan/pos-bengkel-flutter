import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';
import 'package:pos_bengkel/features/kasir/screens/kasir_pos_screen.dart';
import 'package:pos_bengkel/features/kasir/screens/kasir_invoice_screen.dart';
import 'package:pos_bengkel/features/kasir/screens/kasir_receivables_screen.dart';

class PenjualanMainScreen extends StatefulWidget {
  const PenjualanMainScreen({super.key});

  @override
  State<PenjualanMainScreen> createState() => _PenjualanMainScreenState();
}

class _PenjualanMainScreenState extends State<PenjualanMainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Transaksi Penjualan'),
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
              icon: Icon(Iconsax.receipt_text),
              text: 'Kasir',
            ),
            Tab(
              icon: Icon(Iconsax.document_text),
              text: 'Invoice',
            ),
            Tab(
              icon: Icon(Iconsax.wallet_money),
              text: 'Piutang',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          KasirPosScreen(),
          KasirInvoiceScreen(),
          KasirReceivablesScreen(),
        ],
      ),
    );
  }
}
