import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/auth_state.dart' as app_auth;
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/auth_provider.dart';

/// Tela de Boas-vindas (pós-verificação de email).
/// Exibe saudação personalizada e botão "Começar agora" → Step 1.
class BoasVindasPage extends ConsumerWidget {
  const BoasVindasPage({super.key});

  static const _imageAsset = 'assets/images/boas_vindas_background.png';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    final authState = ref.watch(authNotifierProvider);
    String greeting = 'Bem-vindo ao RunLab!';
    if (authState is app_auth.AuthAuthenticated) {
      final full = (authState.profile?['full_name'] ?? authState.user.userMetadata?['full_name'])?.toString().trim() ?? '';
      final firstName = full.isNotEmpty ? full.split(RegExp(r'\s+')).first : null;
      if (firstName != null && firstName.isNotEmpty) {
        final isFeminino = authState.profile?['gender'] == 'Feminino';
        greeting = isFeminino ? 'Bem-vinda ao RunLab, $firstName!' : 'Bem-vindo ao RunLab, $firstName!';
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: Stack(
        children: [
          _buildBackgroundImage(),
          _buildBottomGradient(),
          _buildBottomContent(context, greeting),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(color: AppColors.background),
        child: Opacity(
          opacity: 0.75,
          child: Image.asset(
            _imageAsset,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.grey.shade900, Colors.black],
                  ),
                ),
                child: Center(
                  child: Icon(Icons.fitness_center, size: 200, color: Colors.grey.shade800),
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Color.fromRGBO(0, 0, 0, 0.5),
                Color.fromRGBO(0, 0, 0, 0.25),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomContent(BuildContext context, String greeting) {
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
          bottom: bottomPadding > 0 ? bottomPadding + AppSpacing.lg : AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: AppColors.neutral200,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aqui começa sua jornada de corrida. Vamos personalizar sua experiência.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.neutral400,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.go('/onboarding/step-1'),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.lime500,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Center(
                      child: Text(
                        'Começar agora',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.neutral800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
