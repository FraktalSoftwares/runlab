import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/auth_provider.dart';
import '../providers/onboarding_form_provider.dart';
import '../widgets/onboarding_step_background.dart';
import '../widgets/onboarding_step_header.dart';

/// Step 3 (opcional): Treina com assessoria/influenciador? Código.
/// Fundo conforme Figma 163-4226: overlay escuro e gradiente na base.
class OnboardingStep3Page extends ConsumerStatefulWidget {
  const OnboardingStep3Page({super.key});

  @override
  ConsumerState<OnboardingStep3Page> createState() => _OnboardingStep3PageState();
}

class _OnboardingStep3PageState extends ConsumerState<OnboardingStep3Page> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit({bool skipAdvisor = false}) async {
    if (_isLoading) return;
    final form = ref.read(onboardingFormProvider);
    final auth = ref.read(authServiceProvider);

    setState(() => _isLoading = true);
    try {
      await auth.updateProfileOnboarding(
        preferredDistance: form.preferredDistance,
        runningExperience: form.runningExperience,
        advisorCode: skipAdvisor ? null : (_codeController.text.trim().isEmpty ? null : _codeController.text.trim()),
        markOnboardingCompleted: true,
      );
      await ref.read(authNotifierProvider.notifier).refreshProfile();
      ref.read(onboardingFormProvider.notifier).clear();
      if (mounted) context.go('/');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: Stack(
        children: [
          const OnboardingStepBackground(),
          _buildContent(context),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: OnboardingStepHeader(
                step: 3,
                onBack: () => context.go('/onboarding/step-2'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      top: 0,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            top: 120,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: bottomPadding > 0 ? bottomPadding + AppSpacing.lg : AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '(OPCIONAL)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.neutral500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Treina com alguma assessoria ou influenciador?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral200,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.neutral750,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.neutral600, width: 1),
                ),
                child: TextField(
                  controller: _codeController,
                  enabled: !_isLoading,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.neutral200,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Digite o código ou escolha na lista',
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      color: AppColors.neutral500,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: GestureDetector(
                  onTap: _isLoading ? null : () => _submit(skipAdvisor: true),
                  child: const Text(
                    'Pular',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.lime500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _isLoading ? null : () => _submit(skipAdvisor: false),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isLoading ? AppColors.neutral750 : AppColors.lime500,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Center(
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.neutral500),
                              )
                            : const Text(
                                'Avançar',
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
      ),
    );
  }
}
