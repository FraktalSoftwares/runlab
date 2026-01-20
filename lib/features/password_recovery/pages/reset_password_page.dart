import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/widgets.dart';

/// Tela de Redefinição de Senha
///
/// Baseada no design do Figma (node-id: 58-5136)
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    return _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _passwordController.text == _confirmPasswordController.text;
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.xxl),
              // Título
              Text(
                'Defina sua nova senha',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: AppColors.neutral200,
                  height: 1.5,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              // Subtítulo
              Text(
                'Tudo certo! Agora é só definir uma nova senha para acessar sua conta.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.neutral400,
                  height: 1.5,
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              // Campo Insira a senha
              AppFormField(
                label: 'Insira a senha',
                hint: 'Insira sua senha',
                controller: _passwordController,
                obscureText: _obscurePassword,
                showObscureToggle: true,
                onObscureToggle: (value) {
                  setState(() {
                    _obscurePassword = value;
                  });
                },
                prefixIcon: Icon(
                  Icons.lock_outline,
                  size: 22,
                  color: AppColors.neutral400,
                ),
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: AppSpacing.lg),
              // Campo Confirmar senha
              AppFormField(
                label: 'Confirmar senha',
                hint: 'Confirme sua nova senha',
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                showObscureToggle: true,
                onObscureToggle: (value) {
                  setState(() {
                    _obscureConfirmPassword = value;
                  });
                },
                prefixIcon: Icon(
                  Icons.lock_outline,
                  size: 22,
                  color: AppColors.neutral400,
                ),
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: AppSpacing.xl),
              // Botão Atualizar senha
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isFormValid()
                      ? () {
                          context.push('/password-recovery/success');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lime500,
                    foregroundColor: AppColors.neutral800,
                    disabledBackgroundColor: AppColors.neutral750,
                    disabledForegroundColor: AppColors.neutral500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Atualizar senha',
                    style: TextStyle(
                      fontSize: AppTypography.bodyLarge,
                      fontWeight: AppTypography.medium,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
