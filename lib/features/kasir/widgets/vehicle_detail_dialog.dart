import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';
import 'package:pos_bengkel/core/utils/date_formatter.dart';
import 'package:pos_bengkel/shared/models/customer_vehicle.dart';

class VehicleDetailDialog extends StatelessWidget {
  final CustomerVehicle vehicle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const VehicleDetailDialog({
    super.key,
    required this.vehicle,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Iconsax.car,
                    color: AppColors.info,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detail Kendaraan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        vehicle.displayName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Vehicle Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(vehicle.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _getStatusColor(vehicle.status),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    vehicle.status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(vehicle.status),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Vehicle Information
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Basic Info Section
                    _buildSection(
                      title: 'Informasi Dasar',
                      icon: Iconsax.info_circle,
                      children: [
                        _buildInfoRow(
                            'Nomor Plat', vehicle.plateNumber, Iconsax.car),
                        _buildInfoRow('Jenis', vehicle.type, Iconsax.category),
                        _buildInfoRow('Merk', vehicle.brand, Iconsax.tag),
                        _buildInfoRow('Model', vehicle.model, Iconsax.tag_2),
                        _buildInfoRow('Tahun Produksi',
                            '${vehicle.productionYear}', Iconsax.calendar),
                        _buildInfoRow(
                            'Warna', vehicle.color, Iconsax.colorfilter),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Technical Info Section
                    _buildSection(
                      title: 'Informasi Teknis',
                      icon: Iconsax.setting_2,
                      children: [
                        _buildInfoRow('Nomor Mesin', vehicle.engineNumber,
                            Iconsax.setting),
                        _buildInfoRow('Nomor Rangka', vehicle.chassisNumber,
                            Iconsax.code),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // System Info Section
                    _buildSection(
                      title: 'Informasi Sistem',
                      icon: Iconsax.information,
                      children: [
                        _buildInfoRow('ID Kendaraan',
                            vehicle.vehicleId ?? 'N/A', Iconsax.hashtag),
                        _buildInfoRow('ID Customer', vehicle.customerId,
                            Iconsax.profile_2user),
                        _buildInfoRow('Status', vehicle.status, Iconsax.status),
                        _buildInfoRow(
                            'Dibuat',
                            DateFormatter.formatDateTime(vehicle.createdAt),
                            Iconsax.calendar_add),
                        _buildInfoRow(
                            'Diperbarui',
                            DateFormatter.formatDateTime(vehicle.updatedAt),
                            Iconsax.calendar_edit),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Additional Info Section
                    _buildSection(
                      title: 'Informasi Tambahan',
                      icon: Iconsax.note,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Iconsax.info_circle,
                                    size: 16,
                                    color: AppColors.info,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Catatan:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Untuk informasi customer pemilik kendaraan ini, silakan hubungi administrator atau akses menu customer.',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textTertiary,
                                  fontStyle: FontStyle.italic,
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
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Iconsax.arrow_left),
                    label: const Text('Kembali'),
                  ),
                ),
                if (onEdit != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        onEdit!();
                      },
                      icon: const Icon(Iconsax.edit),
                      label: const Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warning,
                      ),
                    ),
                  ),
                ],
                if (onDelete != null) ...[
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {
                      _showDeleteConfirmation(context);
                    },
                    icon: const Icon(Iconsax.trash),
                    color: AppColors.error,
                    tooltip: 'Hapus Kendaraan',
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
        return AppColors.success;
      case 'tidak aktif':
        return AppColors.error;
      case 'maintenance':
        return AppColors.warning;
      default:
        return AppColors.textTertiary;
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(
              Iconsax.warning_2,
              color: AppColors.error,
            ),
            SizedBox(width: 12),
            Text('Konfirmasi Hapus'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Apakah Anda yakin ingin menghapus kendaraan ini?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Iconsax.car,
                    color: AppColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      vehicle.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tindakan ini tidak dapat dibatalkan.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
              ),
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
              Navigator.pop(context); // Close confirmation
              Navigator.pop(context); // Close detail dialog
              if (onDelete != null) {
                onDelete!();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
