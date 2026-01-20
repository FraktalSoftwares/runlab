import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';

/// Campo de texto do Design System
/// 
/// TODO: Ajustar estilos conforme especificações do Figma
/// - Cores, bordas, estados (focused, error, disabled)
/// - Placeholder, label, helper text
class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: _getLabelStyle(hasError),
          ),
          SizedBox(height: AppSpacing.xs),
        ],
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          enabled: enabled,
          maxLines: maxLines,
          maxLength: maxLength,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            helperText: helperText,
            errorText: errorText,
            filled: true,
            fillColor: _getFillColor(),
            border: _getBorder(hasError),
            enabledBorder: _getBorder(hasError),
            focusedBorder: _getFocusedBorder(hasError),
            errorBorder: _getErrorBorder(),
            focusedErrorBorder: _getErrorBorder(),
            disabledBorder: _getDisabledBorder(),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            // TODO: Adicionar mais estilos do Figma
          ),
          style: _getTextStyle(),
        ),
      ],
    );
  }

  TextStyle _getLabelStyle(bool hasError) {
    // TODO: Substituir por tipografia do Figma
    return AppTypography.baseTextTheme.labelMedium!.copyWith(
      color: hasError ? AppColors.error : AppColors.textPrimary,
      fontWeight: AppTypography.medium,
    );
  }

  TextStyle _getTextStyle() {
    // TODO: Substituir por tipografia do Figma
    return AppTypography.baseTextTheme.bodyLarge!.copyWith(
      color: AppColors.textPrimary,
    );
  }

  Color _getFillColor() {
    // TODO: Substituir por cores do Figma
    return AppColors.surface;
  }

  InputBorder _getBorder(bool hasError) {
    // TODO: Substituir por estilos do Figma
    return OutlineInputBorder(
      borderRadius: AppRadii.radiusMD,
      borderSide: BorderSide(
        color: hasError ? AppColors.error : AppColors.secondary,
        width: 1,
      ),
    );
  }

  InputBorder _getFocusedBorder(bool hasError) {
    // TODO: Substituir por estilos do Figma
    return OutlineInputBorder(
      borderRadius: AppRadii.radiusMD,
      borderSide: BorderSide(
        color: hasError ? AppColors.error : AppColors.primary,
        width: 2,
      ),
    );
  }

  InputBorder _getErrorBorder() {
    // TODO: Substituir por estilos do Figma
    return OutlineInputBorder(
      borderRadius: AppRadii.radiusMD,
      borderSide: BorderSide(
        color: AppColors.error,
        width: 1,
      ),
    );
  }

  InputBorder _getDisabledBorder() {
    // TODO: Substituir por estilos do Figma
    return OutlineInputBorder(
      borderRadius: AppRadii.radiusMD,
      borderSide: BorderSide(
        color: AppColors.disabled,
        width: 1,
      ),
    );
  }
}
