import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // General Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pengaturan Umum',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSettingItem(
                    icon: Iconsax.shop,
                    title: 'Informasi Bengkel',
                    subtitle: 'Nama, alamat, dan kontak bengkel',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Iconsax.user,
                    title: 'Manajemen User',
                    subtitle: 'Kelola akun kasir dan admin',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Iconsax.printer,
                    title: 'Pengaturan Printer',
                    subtitle: 'Konfigurasi printer untuk invoice',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Data Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pengaturan Data',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSettingItem(
                    icon: Iconsax.archive,
                    title: 'Backup Data',
                    subtitle: 'Cadangkan data transaksi dan customer',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Iconsax.refresh,
                    title: 'Restore Data',
                    subtitle: 'Pulihkan data dari backup',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Iconsax.trash,
                    title: 'Bersihkan Data',
                    subtitle: 'Hapus data lama atau tidak terpakai',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // System Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pengaturan Sistem',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSettingItem(
                    icon: Iconsax.notification,
                    title: 'Notifikasi',
                    subtitle: 'Atur preferensi notifikasi',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Iconsax.security,
                    title: 'Keamanan',
                    subtitle: 'Password dan keamanan akun',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Iconsax.information,
                    title: 'Tentang Aplikasi',
                    subtitle: 'Versi dan informasi aplikasi',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(
        Iconsax.arrow_right_3,
        color: AppColors.textTertiary,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
