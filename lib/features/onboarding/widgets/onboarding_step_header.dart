import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/atoms/app_back_button.dart';
import 'onboarding_progress.dart';

/// Header dos Steps: botão voltar + barra de progresso.
/// Fundo transparente; o pai deve colocar sobre a imagem.
class OnboardingStepHeader extends StatelessWidget {
  final int step;
  final VoidCallback? onBack;

  const OnboardingStepHeader({
    super.key,
    required this.step,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          AppBackButton(onPressed: onBack),
          Expanded(
            child: Center(
              child: OnboardingProgress(step: step),
            ),
          ),
          const SizedBox(width: 50),
        ],
      ),
    );
  }
}
