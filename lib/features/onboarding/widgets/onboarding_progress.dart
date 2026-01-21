import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Barra de progresso com 3 segmentos (Steps 1–3).
/// O segmento [i] fica preenchido (lime) quando i <= step.
class OnboardingProgress extends StatelessWidget {
  final int step;

  const OnboardingProgress({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final filled = (i + 1) <= step;
        return Padding(
          padding: EdgeInsets.only(right: i < 2 ? 6 : 0),
          child: Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: filled ? AppColors.lime500 : AppColors.neutral600,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        );
      }),
    );
  }
}
