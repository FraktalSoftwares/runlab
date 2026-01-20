import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';

/// Card do Design System
/// 
/// TODO: Ajustar estilos conforme especificações do Figma
/// - Elevação, sombras, bordas
/// - Variantes (elevated, outlined, filled)
class AppCard extends StatelessWidget {
  final Widget child;
  final AppCardVariant variant;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      margin: margin ?? EdgeInsets.all(AppSpacing.md),
      padding: padding ?? EdgeInsets.all(AppSpacing.lg),
      decoration: _getDecoration(),
      child: child,
    );

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: _getBorderRadius(),
        child: card,
      );
    }

    return card;
  }

  BoxDecoration _getDecoration() {
    // TODO: Substituir por estilos do Figma
    switch (variant) {
      case AppCardVariant.elevated:
        return BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.radiusLG,
          boxShadow: AppShadows.shadowMD,
        );
      case AppCardVariant.outlined:
        return BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.radiusLG,
          border: Border.all(
            color: AppColors.secondary,
            width: 1,
          ),
        );
      case AppCardVariant.filled:
        return BoxDecoration(
          color: AppColors.background,
          borderRadius: AppRadii.radiusLG,
        );
    }
  }

  BorderRadius _getBorderRadius() {
    return AppRadii.radiusLG;
  }
}

enum AppCardVariant {
  elevated,
  outlined,
  filled,
}
