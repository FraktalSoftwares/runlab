import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';

/// Botão do Design System
/// 
/// TODO: Ajustar estilos conforme especificações do Figma
/// - Cores, tamanhos, estados (hover, pressed, disabled)
/// - Variantes (primary, secondary, outline, text)
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final Widget? icon;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle(context);
    final buttonSize = _getButtonSize();

    Widget button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: isLoading
          ? SizedBox(
              width: buttonSize.iconSize,
              height: buttonSize.iconSize,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getTextColor(context),
                ),
              ),
            )
          : Row(
              mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  icon!,
                  SizedBox(width: AppSpacing.xs),
                ],
                Text(
                  label,
                  style: _getTextStyle(),
                ),
              ],
            ),
    );

    if (isFullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final backgroundColor = _getBackgroundColor(context);
    final foregroundColor = _getTextColor(context);
    final padding = _getPadding();

    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.radiusMD,
          ),
          // TODO: Adicionar elevation, shadows do Figma
        );
      case AppButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: backgroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: backgroundColor, width: 1),
            borderRadius: AppRadii.radiusMD,
          ),
        );
      case AppButtonVariant.text:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: foregroundColor,
          padding: padding,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.radiusMD,
          ),
        );
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    // TODO: Substituir por cores do Figma
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.primary;
      case AppButtonVariant.secondary:
        return AppColors.primary;
      case AppButtonVariant.text:
        return Colors.transparent;
    }
  }

  Color _getTextColor(BuildContext context) {
    // TODO: Substituir por cores do Figma
    switch (variant) {
      case AppButtonVariant.primary:
        return Colors.white;
      case AppButtonVariant.secondary:
        return AppColors.primary;
      case AppButtonVariant.text:
        return AppColors.primary;
    }
  }

  TextStyle _getTextStyle() {
    // TODO: Substituir por tipografia do Figma
    switch (size) {
      case AppButtonSize.small:
        return AppTypography.baseTextTheme.labelSmall!.copyWith(
          fontWeight: AppTypography.medium,
        );
      case AppButtonSize.medium:
        return AppTypography.baseTextTheme.labelMedium!.copyWith(
          fontWeight: AppTypography.medium,
        );
      case AppButtonSize.large:
        return AppTypography.baseTextTheme.labelLarge!.copyWith(
          fontWeight: AppTypography.semibold,
        );
    }
  }

  EdgeInsets _getPadding() {
    // TODO: Substituir por espaçamentos do Figma
    switch (size) {
      case AppButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case AppButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
      case AppButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        );
    }
  }

  _ButtonSize _getButtonSize() {
    switch (size) {
      case AppButtonSize.small:
        return _ButtonSize(iconSize: 16);
      case AppButtonSize.medium:
        return _ButtonSize(iconSize: 20);
      case AppButtonSize.large:
        return _ButtonSize(iconSize: 24);
    }
  }
}

class _ButtonSize {
  final double iconSize;
  _ButtonSize({required this.iconSize});
}

enum AppButtonVariant {
  primary,
  secondary,
  text,
}

enum AppButtonSize {
  small,
  medium,
  large,
}
