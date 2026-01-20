import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Tela de Confirmação de Login
///
/// Baseada no design do Figma (node-id: 163-4324)
class LoginConfirmationPage extends StatefulWidget {
  const LoginConfirmationPage({super.key});

  @override
  State<LoginConfirmationPage> createState() => _LoginConfirmationPageState();
}

class _LoginConfirmationPageState extends State<LoginConfirmationPage> {
  @override
  void initState() {
    super.initState();
    // Configurar status bar para light content
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    
    // Navegar para a tela principal após alguns segundos
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    // Aguardar alguns segundos para exibir a confirmação
    await Future.delayed(const Duration(seconds: 2));
    
    // Verificar se o widget ainda está montado antes de navegar
    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone de sucesso (círculo verde com checkmark)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.lime500,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.neutral750,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.check,
                  size: 48,
                  color: AppColors.neutral800,
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              // Mensagem de sucesso
              Text(
                'Login realizado com sucesso!',
                style: TextStyle(
                  fontSize: AppTypography.titleMedium,
                  fontWeight: AppTypography.medium,
                  color: AppColors.neutral200,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.xl),
              // Botão com loading
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 300),
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: AppColors.lime500,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.lime500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
