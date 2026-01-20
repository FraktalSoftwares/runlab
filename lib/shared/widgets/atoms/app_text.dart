import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Componente de texto do Design System
/// 
/// TODO: Ajustar conforme especificações do Figma
/// - Variantes de texto (display, headline, title, body, label, caption)
/// - Cores, pesos, alturas de linha
class AppText extends StatelessWidget {
  final String text;
  final AppTextVariant variant;
  final AppTextColor color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppText(
    this.text, {
    super.key,
    this.variant = AppTextVariant.body,
    this.color = AppTextColor.primary,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _getTextStyle(),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle _getTextStyle() {
    final baseStyle = _getBaseStyle();
    final textColor = _getColor();

    return baseStyle.copyWith(
      color: textColor,
      fontWeight: fontWeight ?? baseStyle.fontWeight,
    );
  }

  TextStyle _getBaseStyle() {
    // TODO: Substituir por tipografia do Figma
    switch (variant) {
      case AppTextVariant.displayLarge:
        return AppTypography.baseTextTheme.displayLarge!;
      case AppTextVariant.displayMedium:
        return AppTypography.baseTextTheme.displayMedium!;
      case AppTextVariant.displaySmall:
        return AppTypography.baseTextTheme.displaySmall!;
      case AppTextVariant.headlineLarge:
        return AppTypography.baseTextTheme.headlineLarge!;
      case AppTextVariant.headlineMedium:
        return AppTypography.baseTextTheme.headlineMedium!;
      case AppTextVariant.headlineSmall:
        return AppTypography.baseTextTheme.headlineSmall!;
      case AppTextVariant.titleLarge:
        return AppTypography.baseTextTheme.titleLarge!;
      case AppTextVariant.titleMedium:
        return AppTypography.baseTextTheme.titleMedium!;
      case AppTextVariant.titleSmall:
        return AppTypography.baseTextTheme.titleSmall!;
      case AppTextVariant.body:
        return AppTypography.baseTextTheme.bodyLarge!;
      case AppTextVariant.bodySmall:
        return AppTypography.baseTextTheme.bodySmall!;
      case AppTextVariant.label:
        return AppTypography.baseTextTheme.labelLarge!;
      case AppTextVariant.caption:
        return AppTypography.baseTextTheme.bodySmall!;
    }
  }

  Color _getColor() {
    // TODO: Substituir por cores do Figma
    switch (color) {
      case AppTextColor.primary:
        return AppColors.textPrimary;
      case AppTextColor.secondary:
        return AppColors.textSecondary;
      case AppTextColor.disabled:
        return AppColors.textDisabled;
      case AppTextColor.error:
        return AppColors.error;
      case AppTextColor.success:
        return AppColors.success;
    }
  }
}

enum AppTextVariant {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  body,
  bodySmall,
  label,
  caption,
}

enum AppTextColor {
  primary,
  secondary,
  disabled,
  error,
  success,
}
