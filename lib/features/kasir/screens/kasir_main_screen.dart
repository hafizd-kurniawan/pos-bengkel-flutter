import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/providers/auth_provider.dart';
import 'kasir_home_screen.dart';
import 'kasir_customers_screen.dart';
import 'kasir_services_screen.dart';
import 'kasir_transactions_screen.dart';

class KasirMainScreen extends StatefulWidget {
  const KasirMainScreen({super.key});

  @override
  State<KasirMainScreen> createState() => _KasirMainScreenState();
}

class _KasirMainScreenState extends State<KasirMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const KasirHomeScreen(),
    const KasirCustomersScreen(),
    const KasirServicesScreen(),
    const KasirTransactionsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        backgroundColor: AppColors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Pelanggan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Servis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Transaksi',
          ),
        ],
      ),
    );
  }
}