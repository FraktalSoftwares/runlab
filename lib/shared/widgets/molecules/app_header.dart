import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../atoms/app_back_button.dart';

/// Header reutilizável para páginas
///
/// Baseado no design do Figma (node-id: 787-9257)
/// Inclui botão de voltar e título centralizado
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool showBackButton;

  const AppHeader({
    super.key,
    required this.title,
    this.onBackPressed,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return PreferredSize(
      preferredSize: Size.fromHeight(44 + topPadding),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
        ),
        child: SafeArea(
          bottom: false,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 0,
              right: AppSpacing.md,
              top: AppSpacing.sm,
              bottom: AppSpacing.sm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Botão de voltar - posicionado para que o ícone comece em 16px
                if (showBackButton)
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: AppBackButton(
                      onPressed: onBackPressed,
                    ),
                  ),
                // Espaçamento flexível para centralizar o título (se houver)
                if (title.isNotEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: AppTypography.titleMedium,
                          fontWeight: AppTypography.medium,
                          color: AppColors.neutral200,
                        ),
                      ),
                    ),
                  )
                else
                  const Spacer(),
                // Container circular à direita para balancear o botão de voltar
                if (showBackButton && title.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(right: 5),
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
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                else if (showBackButton)
                  const SizedBox(width: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    // Tamanho padrão - será ajustado dinamicamente no build com o padding do topo
    return const Size.fromHeight(44);
  }
}
