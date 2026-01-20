import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/widgets.dart';

/// Tela de Onboarding
/// 
/// Baseada no design do Figma (node-id: 58:4956)
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Configurar status bar para light content
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true, // Remove barra branca do rodapé
      extendBodyBehindAppBar: true, // Permite conteúdo atrás do app bar
      body: Stack(
        children: [
          // Imagem de fundo
          _buildBackgroundImage(),
          
          // Gradiente escuro na parte inferior
          _buildBottomGradient(),
          
          // Safe area do topo (status bar) - Positioned deve estar diretamente no Stack
          _buildTopContent(context),
          
          // Conteúdo central (texto RUNLAB CHALLENGE YOURSELF)
          _buildCenterContent(),
          
          // Conteúdo inferior (texto e botões)
          _buildBottomContent(context),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
        ),
        child: Opacity(
          opacity: 0.75,
          child: Image.network(
            'https://lpxftanpwzfnuebjxfyc.supabase.co/storage/v1/object/public/sistema/onboarding_imagem.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey.shade900,
                      Colors.black,
                    ],
                  ),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: AppColors.lime500,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              // Fallback caso a imagem não carregue
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey.shade900,
                      Colors.black,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.fitness_center,
                    size: 200,
                    color: Colors.grey.shade800,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBottomGradient() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 433,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                const Color.fromRGBO(0, 0, 0, 0.5),
                const Color.fromRGBO(0, 0, 0, 0.25),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopContent(BuildContext context) {
    return Positioned(
      top: 0,
      left: AppSpacing.md,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + AppSpacing.md, // Status bar + espaço
        ),
        child: AppLogo(
          variant: AppLogoVariant.white,
          width: 40,
          height: 53,
        ),
      ),
    );
  }

  Widget _buildCenterContent() {
    return Positioned(
      left: AppSpacing.md,
      right: AppSpacing.md,
      top: 0,
      bottom: 0,
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RUNLAB',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lime500,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'CHALLENGE',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lime500,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'YOURSELF',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lime500,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomContent(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: bottomPadding > 0 ? bottomPadding + AppSpacing.lg : AppSpacing.lg, // Apenas padding necessário
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Texto motivacional
            Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.lg),
              child: Text(
                'Corra no seu ritmo.\nEvolua com a gente.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: AppColors.neutral200,
                  height: 1.08, // 26px / 24px
                ),
              ),
            ),
            
            // Botões
            Row(
              children: [
                Expanded(
                  child: _buildPrimaryButton(
                    label: 'Criar conta',
                    onPressed: () {
                      context.push('/signup');
                    },
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildSecondaryButton(
                    label: 'Entrar',
                    onPressed: () {
                      context.push('/login');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.lime500,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(999),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.neutral800,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.lime500,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(999),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.lime500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
