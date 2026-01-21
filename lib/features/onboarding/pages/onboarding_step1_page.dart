import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/onboarding_form_provider.dart';
import '../widgets/onboarding_step_background.dart';
import '../widgets/onboarding_step_header.dart';

/// Step 1: Qual sua distância preferida?
/// Fundo conforme Figma 163-4226: overlay escuro e gradiente na base.
class OnboardingStep1Page extends ConsumerStatefulWidget {
  const OnboardingStep1Page({super.key});

  static const _options = [
    'Até 5 km',
    'De 6 km a 20 km',
    'De 21 km a 41 km',
    'Acima de 42 km',
  ];

  @override
  ConsumerState<OnboardingStep1Page> createState() => _OnboardingStep1PageState();
}

class _OnboardingStep1PageState extends ConsumerState<OnboardingStep1Page> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final fromProvider = ref.watch(onboardingFormProvider).preferredDistance;
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
                step: 1,
                onBack: () => context.go('/onboarding/boas-vindas'),
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
                'Qual sua distância preferida?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral200,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ...OnboardingStep1Page._options.map((opt) => Padding(
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
                            ref.read(onboardingFormProvider.notifier).setPreferredDistance(effectiveSelected);
                            context.go('/onboarding/step-2');
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
