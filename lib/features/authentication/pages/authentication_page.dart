import 'package:flutter/material.dart';
import '../../../shared/widgets/widgets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Tela de Autenticação
/// 
/// Baseada no design do Figma
class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logos horizontais
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppLogo(variant: AppLogoVariant.green),
                  SizedBox(width: AppSpacing.xl),
                  AppLogo(variant: AppLogoVariant.white),
                ],
              ),
              SizedBox(height: AppSpacing.xxl),
              // Ícones circulares verdes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppPrimaryCTA(
                    onPressed: () {
                      // TODO: Implementar ação de email
                    },
                    child: Icon(
                      Icons.email,
                      color: AppColors.textPrimary,
                      size: 32,
                    ),
                  ),
                  SizedBox(width: AppSpacing.xl),
                  AppPrimaryCTA(
                    onPressed: () {
                      // TODO: Implementar ação de check
                    },
                    child: Icon(
                      Icons.check,
                      color: AppColors.textPrimary,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
