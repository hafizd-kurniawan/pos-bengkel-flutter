import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final Function(int) onPageChanged;
  final Function(int)? onItemsPerPageChanged;
  final List<int> itemsPerPageOptions;
  final bool showItemsPerPage;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.onPageChanged,
    this.onItemsPerPageChanged,
    this.itemsPerPageOptions = const [10, 25, 50, 100],
    this.showItemsPerPage = true,
  });

  @override
  Widget build(BuildContext context) {
    if (totalItems == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Items info
          Expanded(
            child: Text(
              'Menampilkan ${_getStartItem()} - ${_getEndItem()} dari $totalItems data',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          // Items per page selector
          if (showItemsPerPage && onItemsPerPageChanged != null) ...[
            const Text(
              'Tampilkan:',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 8),
            DropdownButton<int>(
              value: itemsPerPage,
              items: itemsPerPageOptions.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value'),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  onItemsPerPageChanged!(newValue);
                }
              },
              underline: Container(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 16),
          ],

          // Pagination buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // First page
              IconButton(
                onPressed: currentPage > 1 ? () => onPageChanged(1) : null,
                icon: const Icon(Iconsax.previous),
                tooltip: 'Halaman pertama',
                iconSize: 18,
              ),

              // Previous page
              IconButton(
                onPressed: currentPage > 1 
                    ? () => onPageChanged(currentPage - 1) 
                    : null,
                icon: const Icon(Iconsax.arrow_left_2),
                tooltip: 'Halaman sebelumnya',
                iconSize: 18,
              ),

              // Page numbers
              ..._buildPageNumbers(),

              // Next page
              IconButton(
                onPressed: currentPage < totalPages 
                    ? () => onPageChanged(currentPage + 1) 
                    : null,
                icon: const Icon(Iconsax.arrow_right_3),
                tooltip: 'Halaman selanjutnya',
                iconSize: 18,
              ),

              // Last page
              IconButton(
                onPressed: currentPage < totalPages 
                    ? () => onPageChanged(totalPages) 
                    : null,
                icon: const Icon(Iconsax.next),
                tooltip: 'Halaman terakhir',
                iconSize: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getStartItem() {
    if (totalItems == 0) return 0;
    return ((currentPage - 1) * itemsPerPage) + 1;
  }

  int _getEndItem() {
    final endItem = currentPage * itemsPerPage;
    return endItem > totalItems ? totalItems : endItem;
  }

  List<Widget> _buildPageNumbers() {
    List<Widget> pageNumbers = [];
    
    // Calculate visible page range
    int startPage = (currentPage - 2).clamp(1, totalPages);
    int endPage = (currentPage + 2).clamp(1, totalPages);
    
    // Adjust range to show 5 pages when possible
    if (endPage - startPage < 4) {
      if (startPage == 1) {
        endPage = (startPage + 4).clamp(1, totalPages);
      } else if (endPage == totalPages) {
        startPage = (endPage - 4).clamp(1, totalPages);
      }
    }

    // Add ellipsis and first page if needed
    if (startPage > 1) {
      pageNumbers.add(_buildPageButton(1));
      if (startPage > 2) {
        pageNumbers.add(_buildEllipsis());
      }
    }

    // Add page numbers in range
    for (int i = startPage; i <= endPage; i++) {
      pageNumbers.add(_buildPageButton(i));
    }

    // Add ellipsis and last page if needed
    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        pageNumbers.add(_buildEllipsis());
      }
      pageNumbers.add(_buildPageButton(totalPages));
    }

    return pageNumbers;
  }

  Widget _buildPageButton(int page) {
    final isCurrentPage = page == currentPage;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: isCurrentPage ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: isCurrentPage ? null : () => onPageChanged(page),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: isCurrentPage 
                  ? null 
                  : Border.all(color: AppColors.border),
            ),
            child: Text(
              '$page',
              style: TextStyle(
                fontSize: 14,
                fontWeight: isCurrentPage ? FontWeight.w600 : FontWeight.w500,
                color: isCurrentPage ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 32,
      height: 32,
      alignment: Alignment.center,
      child: const Text(
        '...',
        style: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class SimplePaginationControls extends StatelessWidget {
  final int currentPage;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final String? infoText;

  const SimplePaginationControls({
    super.key,
    required this.currentPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
    this.onNext,
    this.onPrevious,
    this.infoText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (infoText != null)
            Text(
              infoText!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            )
          else
            Text(
              'Halaman $currentPage',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: hasPreviousPage ? onPrevious : null,
                icon: const Icon(Iconsax.arrow_left_2),
                tooltip: 'Sebelumnya',
                iconSize: 18,
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: hasNextPage ? onNext : null,
                icon: const Icon(Iconsax.arrow_right_3),
                tooltip: 'Selanjutnya',
                iconSize: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }
}