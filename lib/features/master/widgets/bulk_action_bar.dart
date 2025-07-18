import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';

class BulkActionBar extends StatelessWidget {
  final int selectedCount;
  final List<BulkAction> actions;
  final VoidCallback? onSelectAll;
  final VoidCallback? onClearSelection;
  final bool isSelectAllEnabled;
  final String? selectAllText;

  const BulkActionBar({
    super.key,
    required this.selectedCount,
    required this.actions,
    this.onSelectAll,
    this.onClearSelection,
    this.isSelectAllEnabled = true,
    this.selectAllText,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedCount == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // Selection info
          Expanded(
            child: Row(
              children: [
                Icon(
                  Iconsax.tick_square,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '$selectedCount item terpilih',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                if (isSelectAllEnabled && onSelectAll != null)
                  TextButton.icon(
                    onPressed: onSelectAll,
                    icon: const Icon(Iconsax.tick_square, size: 16),
                    label: Text(selectAllText ?? 'Pilih Semua'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ),

          // Actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...actions.map((action) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _buildActionButton(action),
              )),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onClearSelection,
                icon: const Icon(Iconsax.close_circle),
                tooltip: 'Batal pilih',
                iconSize: 20,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BulkAction action) {
    if (action.isDestructive) {
      return OutlinedButton.icon(
        onPressed: action.onPressed,
        icon: Icon(action.icon, size: 16),
        label: Text(action.label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: action.onPressed,
      icon: Icon(action.icon, size: 16),
      label: Text(action.label),
      style: ElevatedButton.styleFrom(
        backgroundColor: action.color ?? AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class BulkAction {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final bool isDestructive;

  const BulkAction({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color,
    this.isDestructive = false,
  });
}

class SelectableListItem extends StatelessWidget {
  final bool isSelected;
  final Function(bool?) onSelectionChanged;
  final Widget child;
  final VoidCallback? onTap;

  const SelectableListItem({
    super.key,
    required this.isSelected,
    required this.onSelectionChanged,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? AppColors.primary 
                : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected 
              ? AppColors.primary.withOpacity(0.05) 
              : null,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Checkbox(
                value: isSelected,
                onChanged: onSelectionChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class BulkSelectionProvider extends ChangeNotifier {
  final Set<String> _selectedItems = {};

  Set<String> get selectedItems => Set.unmodifiable(_selectedItems);
  int get selectedCount => _selectedItems.length;
  bool get hasSelection => _selectedItems.isNotEmpty;

  bool isSelected(String id) => _selectedItems.contains(id);

  void toggleSelection(String id) {
    if (_selectedItems.contains(id)) {
      _selectedItems.remove(id);
    } else {
      _selectedItems.add(id);
    }
    notifyListeners();
  }

  void selectAll(List<String> ids) {
    _selectedItems.addAll(ids);
    notifyListeners();
  }

  void clearSelection() {
    _selectedItems.clear();
    notifyListeners();
  }

  void selectItems(List<String> ids) {
    _selectedItems.addAll(ids);
    notifyListeners();
  }

  void removeFromSelection(List<String> ids) {
    _selectedItems.removeAll(ids);
    notifyListeners();
  }
}

class BulkConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;
  final VoidCallback onConfirm;

  const BulkConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Ya',
    this.cancelText = 'Batal',
    this.isDestructive = false,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            isDestructive ? Iconsax.warning_2 : Iconsax.info_circle,
            color: isDestructive ? AppColors.error : AppColors.info,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDestructive ? AppColors.error : AppColors.primary,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Ya',
    String cancelText = 'Batal',
    bool isDestructive = false,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) => BulkConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        onConfirm: onConfirm,
      ),
    );
  }
}