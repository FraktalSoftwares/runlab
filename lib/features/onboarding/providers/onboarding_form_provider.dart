import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado do formulário de onboarding (Steps 1–3).
class OnboardingFormState {
  final String? preferredDistance;
  final String? runningExperience;
  final String? advisorCode;

  const OnboardingFormState({
    this.preferredDistance,
    this.runningExperience,
    this.advisorCode,
  });
}

class OnboardingFormNotifier extends StateNotifier<OnboardingFormState> {
  OnboardingFormNotifier() : super(const OnboardingFormState());

  void setPreferredDistance(String? value) {
    state = OnboardingFormState(
      preferredDistance: value,
      runningExperience: state.runningExperience,
      advisorCode: state.advisorCode,
    );
  }

  void setRunningExperience(String? value) {
    state = OnboardingFormState(
      preferredDistance: state.preferredDistance,
      runningExperience: value,
      advisorCode: state.advisorCode,
    );
  }

  void setAdvisorCode(String? value) {
    state = OnboardingFormState(
      preferredDistance: state.preferredDistance,
      runningExperience: state.runningExperience,
      advisorCode: value,
    );
  }

  void clear() {
    state = const OnboardingFormState();
  }
}

final onboardingFormProvider =
    StateNotifierProvider<OnboardingFormNotifier, OnboardingFormState>((ref) {
  return OnboardingFormNotifier();
});
