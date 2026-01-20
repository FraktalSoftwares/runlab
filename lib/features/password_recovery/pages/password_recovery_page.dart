import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/widgets.dart';

/// Tela de Recuperação de Senha
///
/// Baseada no design do Figma (node-id: 58-5117)
class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({super.key});

  @override
  State<PasswordRecoveryPage> createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
              SizedBox(height: AppSpacing.lg),
              // Título
              Text(
                'Recuperação de senha',
                style: TextStyle(
                  fontSize: AppTypography.headlineSmall,
                  fontWeight: AppTypography.bold,
                  color: AppColors.neutral200,
                  height: 1.5,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              // Subtítulo
              Text(
                'Digite seu e-mail e enviaremos um link para redefinir sua senha.',
                style: TextStyle(
                  fontSize: AppTypography.bodyMedium,
                  fontWeight: AppTypography.regular,
                  color: AppColors.neutral400,
                  height: 1.5,
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              // Campo de e-mail ou telefone
              AppFormField(
                label: 'E-mail ou telefone',
                hint: 'Digite seu endereço de e-mail',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(
                  Icons.email,
                  size: 22,
                  color: AppColors.neutral500,
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              // Botão Enviar link de recuperação
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _emailController.text.isNotEmpty
                      ? () {
                          context.push('/password-recovery/confirmation');
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
                    'Enviar link de recuperação',
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
