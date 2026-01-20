import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/widgets.dart';

/// Tela de Login
///
/// Baseada no design do Figma (node-id: 58-5075)
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Estados
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
        title: '',
        onBackPressed: () => context.pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.lg),
              // Título centralizado
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Bem-vindo de volta!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppTypography.headlineSmall,
                    fontWeight: AppTypography.bold,
                    color: AppColors.neutral200,
                    height: 1.5,
                  ),
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
              SizedBox(height: AppSpacing.lg),
              // Campo de senha
              AppFormField(
                label: 'Senha',
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
                  Icons.lock,
                  size: 22,
                  color: AppColors.neutral500,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              // Link "Esqueceu sua senha?"
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    context.push('/password-recovery');
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Esqueceu sua senha?',
                    style: TextStyle(
                      fontSize: AppTypography.bodySmall,
                      fontWeight: AppTypography.medium,
                      color: AppColors.error,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              // Botão Continuar
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // Navegar para tela de confirmação de login
                    context.push('/login/confirmation');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lime500,
                    foregroundColor: AppColors.neutral800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continuar',
                    style: TextStyle(
                      fontSize: AppTypography.bodyLarge,
                      fontWeight: AppTypography.medium,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              // Texto "Não tem uma conta?"
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: AppTypography.bodySmall,
                      fontWeight: AppTypography.regular,
                      color: AppColors.neutral500,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(text: 'Não tem uma conta? '),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            context.push('/signup');
                          },
                          child: Text(
                            'Crie agora',
                            style: TextStyle(
                              fontSize: AppTypography.bodySmall,
                              fontWeight: AppTypography.medium,
                              color: AppColors.lime500,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              // Separador "ou"
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.neutral750,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      'ou',
                      style: TextStyle(
                        fontSize: AppTypography.bodySmall,
                        fontWeight: AppTypography.regular,
                        color: AppColors.neutral500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.neutral750,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xl),
              // Botão "Entrar com o Google"
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Implementar login com Google
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.neutral750,
                    foregroundColor: AppColors.neutral200,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo do Google
                      SvgPicture.asset(
                        'assets/logos/logo_google.svg',
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(width: AppSpacing.md),
                      Text(
                        'Entrar com o Google',
                        style: TextStyle(
                          fontSize: AppTypography.bodyLarge,
                          fontWeight: AppTypography.medium,
                          height: 1.5,
                        ),
                      ),
                    ],
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
