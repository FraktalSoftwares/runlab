import 'package:go_router/go_router.dart';
import '../app/pages/bootstrap_page.dart';
import '../app/pages/ui_kit_page.dart';
import '../../features/authentication/pages/authentication_page.dart';
import '../../features/splash/pages/splash_page.dart';
import '../../features/onboarding/pages/onboarding_page.dart';
import '../../features/signup/pages/signup_page.dart';
import '../../features/login/pages/login_page.dart';
import '../../features/login/pages/login_confirmation_page.dart';
import '../../features/verification/pages/email_verification_page.dart';
import '../../features/password_recovery/pages/password_recovery_page.dart';
import '../../features/password_recovery/pages/password_recovery_confirmation_page.dart';
import '../../features/password_recovery/pages/reset_password_page.dart';
import '../../features/password_recovery/pages/password_reset_success_page.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/',
      name: 'bootstrap',
      builder: (context, state) => const BootstrapPage(),
    ),
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/authentication',
      name: 'authentication',
      builder: (context, state) => const AuthenticationPage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/login/confirmation',
      name: 'login-confirmation',
      builder: (context, state) => const LoginConfirmationPage(),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: '/verification/email',
      name: 'email-verification',
      builder: (context, state) => const EmailVerificationPage(),
    ),
    GoRoute(
      path: '/password-recovery',
      name: 'password-recovery',
      builder: (context, state) => const PasswordRecoveryPage(),
    ),
    GoRoute(
      path: '/password-recovery/confirmation',
      name: 'password-recovery-confirmation',
      builder: (context, state) => const PasswordRecoveryConfirmationPage(),
    ),
    GoRoute(
      path: '/password-recovery/reset',
      name: 'reset-password',
      builder: (context, state) => const ResetPasswordPage(),
    ),
    GoRoute(
      path: '/password-recovery/success',
      name: 'password-reset-success',
      builder: (context, state) => const PasswordResetSuccessPage(),
    ),
    GoRoute(
      path: '/ui-kit',
      name: 'ui-kit',
      builder: (context, state) => const UIKitPage(),
    ),
  ],
);
