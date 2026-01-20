import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radii.dart';

/// Campo de formulário customizado do Design System
///
/// Baseado no design do Figma para a tela de cadastro
class AppFormField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final bool showObscureToggle;
  final ValueChanged<bool>? onObscureToggle;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? trailingIcon;
  final VoidCallback? onTrailingTap;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const AppFormField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.showObscureToggle = false,
    this.onObscureToggle,
    this.keyboardType,
    this.prefixIcon,
    this.trailingIcon,
    this.onTrailingTap,
    this.enabled = true,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppTypography.bodySmall,
              fontWeight: AppTypography.semibold,
              color: AppColors.neutral300,
              height: 1.5,
            ),
          ),
        ),
        // Input container
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.neutral750,
            borderRadius: AppRadii.radiusFull,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Prefix icon
              if (prefixIcon != null) ...[
                Padding(
                  padding: EdgeInsets.only(
                    left: AppSpacing.md,
                    right: 0,
                  ),
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: prefixIcon,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
              ],
              // Text field
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  enabled: enabled,
                  onChanged: onChanged,
                  focusNode: focusNode,
                  style: TextStyle(
                    fontSize: AppTypography.bodyLarge,
                    fontWeight: AppTypography.regular,
                    color: AppColors.neutral400,
                    height: 1.5,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: AppTypography.bodyLarge,
                      fontWeight: AppTypography.regular,
                      color: AppColors.neutral400,
                      height: 1.5,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                      horizontal: 0,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              // Trailing icon (toggle visibility ou dropdown)
              if (trailingIcon != null || showObscureToggle) ...[
                SizedBox(width: AppSpacing.xs),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: showObscureToggle
                        ? () => onObscureToggle?.call(!obscureText)
                        : onTrailingTap,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 40,
                      height: 40,
                      padding: EdgeInsets.all(10),
                      child: showObscureToggle
                          ? Icon(
                              obscureText ? Icons.visibility_off : Icons.visibility,
                              size: 20,
                              color: AppColors.neutral400,
                            )
                          : trailingIcon,
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.xs),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
