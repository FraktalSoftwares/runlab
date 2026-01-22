import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Barra de busca e filtro para competições - Design refinado conforme Figma
class CompetitionSearchBar extends StatelessWidget {
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onFilterTap;

  const CompetitionSearchBar({
    super.key,
    this.searchController,
    this.onSearchChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Campo de busca
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 112),
              child: Container(
                height: 48,
                padding: const EdgeInsets.only(left: 20, right: 102),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: AppColors.neutral750,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  style: const TextStyle(
                    color: AppColors.neutral200,
                    fontSize: 16,
                    fontFamily: AppTypography.fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Buscar competições',
                    hintStyle: const TextStyle(
                      color: AppColors.neutral500,
                      fontSize: 16,
                      fontFamily: AppTypography.fontFamily,
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.neutral500,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Botão de filtro
          Container(
            padding: const EdgeInsets.all(12),
            decoration: ShapeDecoration(
              color: AppColors.neutral750,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1198.80),
              ),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onFilterTap,
              icon: const Icon(
                Icons.tune,
                color: AppColors.lime500,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
