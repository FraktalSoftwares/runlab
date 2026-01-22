import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app/pages/bootstrap_page.dart';
import '../app/pages/ui_kit_page.dart';
import '../../features/competitions/pages/competitions_page.dart';
import '../../features/competitions/pages/competition_detail_page.dart';
import '../../features/competitions/pages/competition_registration_page.dart';
import '../../features/competitions/pages/competition_ranking_page.dart';
import '../../features/runs/pages/run_countdown_page.dart';
import '../../features/runs/pages/run_start_page.dart';
import '../../features/runs/pages/run_active_page.dart';
import '../../features/runs/pages/run_paused_page.dart';
import '../../features/authentication/pages/authentication_page.dart';
import '../../features/splash/pages/splash_page.dart';
import '../../features/onboarding/pages/onboarding_page.dart';
import '../../features/onboarding/pages/boas_vindas_page.dart';
import '../../features/onboarding/pages/onboarding_step1_page.dart';
import '../../features/onboarding/pages/onboarding_step2_page.dart';
import '../../features/onboarding/pages/onboarding_step3_page.dart';
import '../../features/signup/pages/signup_page.dart';
import '../../features/login/pages/login_page.dart';
import '../../features/login/pages/login_confirmation_page.dart';
import '../../features/verification/pages/email_verification_page.dart';
import '../../features/password_recovery/pages/password_recovery_page.dart';
import '../../features/password_recovery/pages/password_recovery_confirmation_page.dart';
import '../../features/password_recovery/pages/reset_password_page.dart';
import '../../features/password_recovery/pages/password_reset_success_page.dart';
import '../../core/models/auth_state.dart' as app_auth;
import '../../core/providers/auth_provider.dart';

/// Provider do GoRouter
final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);

      // Auth ainda não resolvido: / vai para /splash para ela decidir
      if (authState is app_auth.AuthInitial && state.uri.path == '/') {
        return '/splash';
      }

      // Rotas públicas (não requerem autenticação)
      final publicRoutes = [
        '/splash',
        '/onboarding',
        '/login',
        '/signup',
        '/password-recovery',
        '/password-recovery/confirmation',
        '/password-recovery/reset',
        '/password-recovery/success',
        '/verification/email',
        '/login/confirmation',
      ];
      
      final isPublicRoute = publicRoutes.contains(state.uri.path);
      final isAuthenticated = authState is app_auth.AuthAuthenticated;

      // Não autenticado: rota protegida ou / → /login
      if (!isAuthenticated) {
        if (!isPublicRoute && state.uri.path != '/') return '/login';
        if (state.uri.path == '/') return '/login';
        return null;
      }

      // AuthAuthenticated: árvore de redirect (email confirmado + onboarding)
      final path = state.uri.path;
      final auth = authState;
      final emailConfirmed = auth.user.emailConfirmedAt != null;
      final onboardingCompleted = auth.profile?['onboarding_completed_at'] != null;

      // 1) Email NÃO confirmado → /verification/email (exceto se já está lá ou em password-recovery)
      if (!emailConfirmed) {
        if (path != '/verification/email' && !path.startsWith('/password-recovery')) {
          return '/verification/email';
        }
        return null;
      }

      // 2) Email confirmado, onboarding NÃO concluído
      if (!onboardingCompleted) {
        const onboardingSteps = [
          '/onboarding/boas-vindas',
          '/onboarding/step-1',
          '/onboarding/step-2',
          '/onboarding/step-3',
        ];
        if (onboardingSteps.contains(path)) return null;
        // /, /splash, /login, /signup, /onboarding, /authentication, /password-recovery/*, /ui-kit, etc.
        return '/onboarding/boas-vindas';
      }

      // 3) Email confirmado, onboarding concluído
      const onboardingSteps = [
        '/onboarding/boas-vindas',
        '/onboarding/step-1',
        '/onboarding/step-2',
        '/onboarding/step-3',
      ];
      if (onboardingSteps.contains(path)) return '/';
      if (path == '/login' || path == '/signup' || path == '/splash' || path == '/onboarding') {
        return '/';
      }

      return null;
    },
    routes: [
    GoRoute(
      path: '/',
      name: 'competitions',
      builder: (context, state) => const CompetitionsPage(),
    ),
    GoRoute(
      path: '/bootstrap',
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
      path: '/onboarding/boas-vindas',
      name: 'onboarding-boas-vindas',
      builder: (context, state) => const BoasVindasPage(),
    ),
    GoRoute(
      path: '/onboarding/step-1',
      name: 'onboarding-step-1',
      builder: (context, state) => const OnboardingStep1Page(),
    ),
    GoRoute(
      path: '/onboarding/step-2',
      name: 'onboarding-step-2',
      builder: (context, state) => const OnboardingStep2Page(),
    ),
    GoRoute(
      path: '/onboarding/step-3',
      name: 'onboarding-step-3',
      builder: (context, state) => const OnboardingStep3Page(),
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
    GoRoute(
      path: '/competitions/:id',
      name: 'competition-detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return CompetitionDetailPage(competitionId: id);
      },
    ),
    GoRoute(
      path: '/competitions/:id/register',
      name: 'competition-registration',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return CompetitionRegistrationPage(competitionId: id);
      },
    ),
    GoRoute(
      path: '/competitions/:id/ranking',
      name: 'competition-ranking',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return CompetitionRankingPage(competitionId: id);
      },
    ),
    GoRoute(
      path: '/runs/:runId/countdown',
      name: 'run-countdown',
      builder: (context, state) {
        final runId = state.pathParameters['runId']!;
        return RunCountdownPage(runId: runId);
      },
    ),
    GoRoute(
      path: '/runs/:runId/start',
      name: 'run-start',
      builder: (context, state) {
        final runId = state.pathParameters['runId']!;
        return RunStartPage(runId: runId);
      },
    ),
    GoRoute(
      path: '/runs/:runId/active',
      name: 'run-active',
      builder: (context, state) {
        final runId = state.pathParameters['runId']!;
        return RunActivePage(runId: runId);
      },
    ),
    GoRoute(
      path: '/runs/:runId/paused',
      name: 'run-paused',
      builder: (context, state) {
        final runId = state.pathParameters['runId']!;
        return RunPausedPage(runId: runId);
      },
    ),
    ],
  );

  ref.listen<app_auth.AppAuthState>(authNotifierProvider, (prev, next) {
    router.refresh();
  });

  return router;
});
