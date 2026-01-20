import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Ícone do Design System
/// 
/// TODO: Ajustar conforme especificações do Figma
/// - Tamanhos, cores, variantes
class AppIcon extends StatelessWidget {
  final IconData icon;
  final AppIconSize size;
  final AppIconColor color;
  final Color? customColor;

  const AppIcon(
    this.icon, {
    super.key,
    this.size = AppIconSize.medium,
    this.color = AppIconColor.primary,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: _getSize(),
      color: customColor ?? _getColor(),
    );
  }

  double _getSize() {
    // TODO: Substituir por tamanhos do Figma
    switch (size) {
      case AppIconSize.small:
        return 16;
      case AppIconSize.medium:
        return 24;
      case AppIconSize.large:
        return 32;
      case AppIconSize.xlarge:
        return 48;
    }
  }

  Color _getColor() {
    // TODO: Substituir por cores do Figma
    switch (color) {
      case AppIconColor.primary:
        return AppColors.primary;
      case AppIconColor.secondary:
        return AppColors.secondary;
      case AppIconColor.error:
        return AppColors.error;
      case AppIconColor.success:
        return AppColors.success;
      case AppIconColor.disabled:
        return AppColors.disabled;
    }
  }
}

enum AppIconSize {
  small,
  medium,
  large,
  xlarge,
}

enum AppIconColor {
  primary,
  secondary,
  error,
  success,
  disabled,
}
