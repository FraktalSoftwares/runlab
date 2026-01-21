import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/auth_state.dart' as app_auth;
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/widgets.dart';

/// Splash Screen
///
/// Baseada no design do Figma (node-id: 163:5025)
/// Exibe o splash e navega para home (se logado) ou onboarding (se não) após auth pronto.
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _hasNavigated = false;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    _timeoutTimer = Timer(const Duration(seconds: 3), () {
      if (mounted &&
          !_hasNavigated &&
          ref.read(authNotifierProvider) is app_auth.AuthInitial) {
        _hasNavigated = true;
        context.go('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  void _navigateIfReady(app_auth.AppAuthState auth) {
    if (_hasNavigated || !mounted) return;
    if (auth is app_auth.AuthInitial) return;

    _hasNavigated = true;
    if (auth is app_auth.AuthAuthenticated) {
      context.go('/');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<app_auth.AppAuthState>(authNotifierProvider, (prev, next) {
      if (next is! app_auth.AuthInitial) _navigateIfReady(next);
    });

    final auth = ref.watch(authNotifierProvider);
    if (auth is! app_auth.AuthInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _navigateIfReady(auth));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: _buildLogo()),
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
