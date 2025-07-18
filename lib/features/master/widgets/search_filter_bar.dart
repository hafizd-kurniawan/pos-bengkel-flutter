import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';

class SearchFilterBar extends StatefulWidget {
  final String? searchHint;
  final Function(String)? onSearch;
  final List<FilterOption>? filterOptions;
  final Function(List<String>)? onFilterChanged;
  final VoidCallback? onExport;
  final VoidCallback? onRefresh;
  final bool showExport;
  final bool showRefresh;
  final bool isLoading;

  const SearchFilterBar({
    super.key,
    this.searchHint = 'Cari data...',
    this.onSearch,
    this.filterOptions,
    this.onFilterChanged,
    this.onExport,
    this.onRefresh,
    this.showExport = true,
    this.showRefresh = true,
    this.isLoading = false,
  });

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _selectedFilters = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterDialog() {
    if (widget.filterOptions == null || widget.filterOptions!.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Iconsax.filter, size: 20, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Filter Data'),
            ],
          ),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.filterOptions!.map((option) {
                return CheckboxListTile(
                  title: Text(option.label),
                  subtitle: option.description != null
                      ? Text(option.description!)
                      : null,
                  value: _selectedFilters.contains(option.value),
                  onChanged: (checked) {
                    setDialogState(() {
                      if (checked == true) {
                        _selectedFilters.add(option.value);
                      } else {
                        _selectedFilters.remove(option.value);
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setDialogState(() {
                  _selectedFilters.clear();
                });
              },
              child: const Text('Reset'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onFilterChanged?.call(_selectedFilters);
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Terapkan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Search Field
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: widget.searchHint,
                    prefixIcon: const Icon(Iconsax.search_normal_1),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Iconsax.close_circle),
                            onPressed: () {
                              _searchController.clear();
                              widget.onSearch?.call('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  onChanged: widget.onSearch,
                ),
              ),
              const SizedBox(width: 12),

              // Filter Button
              if (widget.filterOptions != null &&
                  widget.filterOptions!.isNotEmpty) ...[
                OutlinedButton.icon(
                  onPressed: _showFilterDialog,
                  icon: Icon(
                    Iconsax.filter,
                    size: 16,
                    color: _selectedFilters.isNotEmpty
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  label: Text(
                    _selectedFilters.isNotEmpty
                        ? 'Filter (${_selectedFilters.length})'
                        : 'Filter',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _selectedFilters.isNotEmpty
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    side: BorderSide(
                      color: _selectedFilters.isNotEmpty
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],

              // Refresh Button
              if (widget.showRefresh) ...[
                IconButton(
                  onPressed: widget.isLoading ? null : widget.onRefresh,
                  icon: widget.isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Iconsax.refresh),
                  tooltip: 'Refresh',
                ),
                const SizedBox(width: 8),
              ],

              // Export Button
              if (widget.showExport) ...[
                ElevatedButton.icon(
                  onPressed: widget.onExport,
                  icon: const Icon(Iconsax.export, size: 16),
                  label: const Text('Export'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                  ),
                ),
              ],
            ],
          ),

          // Active Filters Display
          if (_selectedFilters.isNotEmpty) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedFilters.map((filter) {
                  final option = widget.filterOptions!
                      .firstWhere((opt) => opt.value == filter);
                  return Chip(
                    label: Text(
                      option.label,
                      style: const TextStyle(fontSize: 12),
                    ),
                    deleteIcon: const Icon(Iconsax.close_circle, size: 16),
                    onDeleted: () {
                      setState(() {
                        _selectedFilters.remove(filter);
                      });
                      widget.onFilterChanged?.call(_selectedFilters);
                    },
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    deleteIconColor: AppColors.primary,
                    side: BorderSide(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class FilterOption {
  final String label;
  final String value;
  final String? description;

  const FilterOption({
    required this.label,
    required this.value,
    this.description,
  });
}

class QuickFilterChips extends StatelessWidget {
  final List<QuickFilter> filters;
  final Function(String) onFilterSelected;

  const QuickFilterChips({
    super.key,
    required this.filters,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          return FilterChip(
            label: Text(filter.label),
            onSelected: (selected) => onFilterSelected(filter.value),
            backgroundColor: AppColors.surface,
            selectedColor: AppColors.primary.withOpacity(0.1),
            checkmarkColor: AppColors.primary,
            side: BorderSide(
              color: AppColors.border,
            ),
          );
        },
      ),
    );
  }
}

class QuickFilter {
  final String label;
  final String value;
  final IconData? icon;

  const QuickFilter({
    required this.label,
    required this.value,
    this.icon,
  });
}