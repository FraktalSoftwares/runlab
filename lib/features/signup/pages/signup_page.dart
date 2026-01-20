import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/widgets.dart';

/// Tela de Cadastro
///
/// Baseada no design do Figma (node-id: 58:4960)
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Controllers
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _genderController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Estados
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _termsAccepted = false;
  bool _dataUsageAccepted = false;
  String? _selectedGender;

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(
            'Gênero',
            style: TextStyle(
              fontSize: AppTypography.bodySmall,
              fontWeight: AppTypography.semibold,
              color: AppColors.neutral300,
              height: 1.5,
            ),
          ),
        ),
        // Dropdown container
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.neutral750,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedGender,
                isExpanded: true,
                hint: Text(
                  'Selecione',
                  style: TextStyle(
                    fontSize: AppTypography.bodyLarge,
                    fontWeight: AppTypography.regular,
                    color: AppColors.neutral400,
                    height: 1.5,
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: AppColors.neutral400,
                ),
                items: ['Masculino', 'Feminino'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: AppTypography.bodyLarge,
                        fontWeight: AppTypography.regular,
                        color: AppColors.neutral400,
                        height: 1.5,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                    _genderController.text = newValue ?? '';
                  });
                },
                dropdownColor: AppColors.neutral750,
                style: TextStyle(
                  fontSize: AppTypography.bodyLarge,
                  fontWeight: AppTypography.regular,
                  color: AppColors.neutral400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
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
              // Título da página
              Text(
                'Vamos começar?',
                style: TextStyle(
                  fontSize: AppTypography.headlineSmall,
                  fontWeight: AppTypography.regular,
                  color: AppColors.neutral200,
                  height: 1.5,
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              // Form fields
              Column(
                children: [
                  // Nome Completo
                  AppFormField(
                    label: 'Nome Completo',
                    hint: 'Digite seu nome e sobrenome',
                    controller: _nameController,
                    prefixIcon: Icon(
                      Icons.account_circle,
                      size: 22,
                      color: AppColors.neutral500,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  // Data de nascimento
                  AppFormField(
                    label: 'Data de nascimento',
                    hint: 'DD/MM/AAAA',
                    controller: _birthDateController,
                    keyboardType: TextInputType.datetime,
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      size: 22,
                      color: AppColors.neutral500,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  // Gênero
                  _buildGenderDropdown(),
                  SizedBox(height: AppSpacing.lg),
                  // E-mail ou telefone
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
                  // Criar senha
                  AppFormField(
                    label: 'Criar senha',
                    hint: 'Crie uma senha segura',
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
                  SizedBox(height: AppSpacing.lg),
                  // Confirmar senha
                  AppFormField(
                    label: 'Confirmar senha',
                    hint: 'Repita sua senha',
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    showObscureToggle: true,
                    onObscureToggle: (value) {
                      setState(() {
                        _obscureConfirmPassword = value;
                      });
                    },
                    prefixIcon: Icon(
                      Icons.lock,
                      size: 22,
                      color: AppColors.neutral500,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  // Checkboxes
                  AppCheckbox(
                    value: _termsAccepted,
                    onChanged: (value) {
                      setState(() {
                        _termsAccepted = value ?? false;
                      });
                    },
                    label: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: AppTypography.bodySmall,
                          fontWeight: AppTypography.medium,
                          color: AppColors.neutral200,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(text: 'Concordo com os '),
                          TextSpan(
                            text: 'termos de uso',
                            style: TextStyle(color: AppColors.lime500),
                          ),
                          TextSpan(text: ' e a '),
                          TextSpan(
                            text: 'política de privacidade.',
                            style: TextStyle(color: AppColors.lime500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  AppCheckbox(
                    value: _dataUsageAccepted,
                    onChanged: (value) {
                      setState(() {
                        _dataUsageAccepted = value ?? false;
                      });
                    },
                    label: Text(
                      'Permito que meus dados sejam usados pelo RunLab\nem rankings, eventos e parcerias.',
                      style: TextStyle(
                        fontSize: AppTypography.bodySmall,
                        fontWeight: AppTypography.medium,
                        color: AppColors.neutral200,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl),
                  // Botão Criar conta
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _termsAccepted && _dataUsageAccepted
                          ? () {
                              // Navegar para tela de verificação de email
                              context.push('/verification/email');
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
                        'Criar conta',
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
            ],
          ),
        ),
      ),
    );
  }
}
