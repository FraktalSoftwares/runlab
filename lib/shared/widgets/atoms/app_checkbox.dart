import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';

/// Checkbox customizado do Design System
///
/// Baseado no design do Figma
class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Widget? label;
  final String? labelText;
  final bool enabled;

  const AppCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.labelText,
    this.enabled = true,
  }) : assert(
          label != null || labelText != null,
          'Deve fornecer label ou labelText',
        );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: Checkbox(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeColor: AppColors.lime500,
            checkColor: AppColors.neutral800,
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.disabled;
              }
              if (states.contains(WidgetState.selected)) {
                return AppColors.lime500;
              }
              return Colors.transparent;
            }),
            side: BorderSide(
              color: AppColors.neutral500,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              top: AppSpacing.sm + 2, // Alinhar com o checkbox
            ),
            child: label ??
                Text(
                  labelText!,
                  style: TextStyle(
                    fontSize: AppTypography.bodySmall,
                    fontWeight: AppTypography.medium,
                    color: AppColors.neutral500,
                    height: 1.5,
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
