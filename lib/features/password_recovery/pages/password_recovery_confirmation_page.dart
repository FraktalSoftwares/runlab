import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/widgets.dart';

/// Tela de Confirmação de Recuperação de Senha
///
/// Baseada no design do Figma (node-id: 58-5156)
class PasswordRecoveryConfirmationPage extends StatefulWidget {
  const PasswordRecoveryConfirmationPage({super.key});

  @override
  State<PasswordRecoveryConfirmationPage> createState() =>
      _PasswordRecoveryConfirmationPageState();
}

class _PasswordRecoveryConfirmationPageState
    extends State<PasswordRecoveryConfirmationPage> {
  int _countdownSeconds = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _canResend = false;
    _countdownSeconds = 60;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_countdownSeconds > 0) {
            _countdownSeconds--;
          } else {
            _canResend = true;
            _timer?.cancel();
          }
        });
      }
    });
  }

  void _handleResend() {
    if (_canResend) {
      // TODO: Implementar reenvio de email
      _startCountdown();
    }
  }

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
      extendBody: true,
      appBar: AppHeader(
        title: 'Recuperação de senha',
        onBackPressed: () => context.pop(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    // Ícone de sucesso
                    Container(
                      width: 100,
                      height: 100,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(117.65),
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Círculo externo (anel escuro)
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: ShapeDecoration(
                                color: AppColors.neutral750,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.71),
                                ),
                              ),
                            ),
                          ),
                          // Círculo interno verde limão com checkmark
                          Positioned(
                            left: 10,
                            top: 10,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: ShapeDecoration(
                                color: AppColors.lime500,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 36,
                                color: AppColors.neutral800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.xl),
                    // Mensagem de confirmação
                    Text(
                      'Um link de recuperação\nfoi enviado para o seu email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.neutral200,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Botão Reenviar email na parte inferior
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _canResend ? _handleResend : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neutral750,
                    foregroundColor: AppColors.neutral200,
                    disabledBackgroundColor: AppColors.neutral750,
                    disabledForegroundColor: AppColors.neutral500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _canResend
                        ? 'Reenviar email'
                        : 'Reenviar email (${_countdownSeconds}s)',
                    style: TextStyle(
                      fontSize: AppTypography.bodyLarge,
                      fontWeight: AppTypography.medium,
                      height: 1.5,
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
