import 'package:flutter/material.dart';
import '../../../core/themes/app_theme.dart';
import 'mekanik_home_screen.dart';
import 'mekanik_jobs_screen.dart';
import 'mekanik_history_screen.dart';

class MekanikMainScreen extends StatefulWidget {
  const MekanikMainScreen({super.key});

  @override
  State<MekanikMainScreen> createState() => _MekanikMainScreenState();
}

class _MekanikMainScreenState extends State<MekanikMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MekanikHomeScreen(),
    const MekanikJobsScreen(),
    const MekanikHistoryScreen(),
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
            icon: Icon(Icons.build_circle),
            label: 'Pekerjaan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
        ],
      ),
    );
  }
}