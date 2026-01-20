import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/widgets.dart';

/// Splash Screen
/// 
/// Baseada no design do Figma (node-id: 163:5025)
/// Exibe o splash e navega automaticamente para o onboarding após carregar
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Configurar status bar para light content (texto branco)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    
    // Navegar para onboarding após 2 segundos (tempo de exibição do splash)
    _navigateToOnboarding();
  }

  Future<void> _navigateToOnboarding() async {
    // Aguardar 2 segundos para exibir o splash
    await Future.delayed(const Duration(seconds: 2));
    
    // Verificar se o widget ainda está montado antes de navegar
    if (mounted) {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Logo centralizado
            Center(
              child: _buildLogo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AppLogo(
      variant: AppLogoVariant.green,
      width: 56,
      height: 74,
    );
  }
}
