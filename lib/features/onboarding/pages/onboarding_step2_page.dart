import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/onboarding_form_provider.dart';
import '../widgets/onboarding_step_background.dart';
import '../widgets/onboarding_step_header.dart';

/// Step 2: Há quanto tempo você corre?
/// Fundo conforme Figma 163-4226: overlay escuro e gradiente na base.
class OnboardingStep2Page extends ConsumerStatefulWidget {
  const OnboardingStep2Page({super.key});

  static const _options = [
    'Até 6 meses',
    'Entre 6 meses e 2 anos',
    'Mais de 2 anos',
  ];

  @override
  ConsumerState<OnboardingStep2Page> createState() => _OnboardingStep2PageState();
}

class _OnboardingStep2PageState extends ConsumerState<OnboardingStep2Page> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final fromProvider = ref.watch(onboardingFormProvider).runningExperience;
    final effectiveSelected = _selected ?? fromProvider;
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
          _buildContent(context, effectiveSelected),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: OnboardingStepHeader(
                step: 2,
                onBack: () => context.go('/onboarding/step-1'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, String? effectiveSelected) {
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
                'Há quanto tempo você corre?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral200,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ...OnboardingStep2Page._options.map((opt) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _buildOption(opt, effectiveSelected),
                  )),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: effectiveSelected != null
                        ? () {
                            ref.read(onboardingFormProvider.notifier).setRunningExperience(effectiveSelected);
                            context.go('/onboarding/step-3');
                          }
                        : null,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      decoration: BoxDecoration(
                        color: effectiveSelected != null ? AppColors.lime500 : AppColors.neutral750,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Center(
                        child: Text(
                          'Avançar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: effectiveSelected != null ? AppColors.neutral800 : AppColors.neutral500,
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

  Widget _buildOption(String label, String? effectiveSelected) {
    final isSelected = effectiveSelected == label;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selected = label),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.lime500 : AppColors.neutral600,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.neutral200,
            ),
          ),
        ),
      ),
    );
  }
}
