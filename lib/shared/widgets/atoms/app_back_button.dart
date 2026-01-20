import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

/// Botão de voltar circular reutilizável
///
/// Baseado no design do Figma (node-id: 68-9814)
/// Botão circular com ícone verde de seta para esquerda
class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AppBackButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed ?? () {
          if (context.canPop()) {
            context.pop();
          }
        },
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 50,
          height: 50,
          constraints: const BoxConstraints(
            minWidth: 50,
            maxWidth: 50,
            minHeight: 50,
            maxHeight: 50,
          ),
          decoration: const BoxDecoration(
            color: AppColors.neutral750,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.chevron_left,
              size: 28,
              color: AppColors.lime500,
            ),
          ),
        ),
      ),
    );
  }
}
