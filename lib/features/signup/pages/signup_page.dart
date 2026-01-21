import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/models/auth_state.dart' as app_auth;
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/widgets.dart';

/// Tela de Cadastro
///
/// Baseada no design do Figma (node-id: 58:4960)
class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
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
  bool _isLoading = false;
  String? _errorMessage;

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

  bool _isFormValid() {
    return _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _passwordController.text == _confirmPasswordController.text &&
        _passwordController.text.length >= 6 &&
        _isValidEmail(_emailController.text);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _handleSignUp() async {
    if (!_isFormValid()) {
      setState(() {
        if (_passwordController.text != _confirmPasswordController.text) {
          _errorMessage = 'As senhas não coincidem';
        } else if (_passwordController.text.length < 6) {
          _errorMessage = 'A senha deve ter pelo menos 6 caracteres';
        } else if (!_isValidEmail(_emailController.text)) {
          _errorMessage = 'Email inválido';
        } else {
          _errorMessage = 'Preencha todos os campos';
        }
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authNotifier = ref.read(authNotifierProvider.notifier);
      
      await authNotifier.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
        birthDate: _birthDateController.text.isNotEmpty
            ? _birthDateController.text
            : null,
        gender: _selectedGender,
      );

      final authState = ref.read(authNotifierProvider);
      
      if (authState is app_auth.AuthAuthenticated) {
        // Usuário autenticado, navegar para home ou verificação
        if (mounted) {
          context.push('/verification/email');
        }
      } else if (authState is app_auth.AuthError) {
        setState(() {
          _errorMessage = authState.message;
          _isLoading = false;
        });
      } else {
        // Usuário criado mas não autenticado (precisa confirmar email)
        // Navegar para tela de verificação mesmo assim
        if (mounted) {
          context.push('/verification/email');
        }
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao criar conta: ${e.toString()}';
        _isLoading = false;
      });
      print('Erro no signup: $e');
    }
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
                  // Mensagem de erro
                  if (_errorMessage != null) ...[
                    Container(
                      padding: EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 20,
                          ),
                          SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: AppColors.error,
                                fontSize: AppTypography.bodySmall,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                  ],
                  SizedBox(height: AppSpacing.xl),
                  // Botão Criar conta
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: (_termsAccepted && _dataUsageAccepted && !_isLoading)
                          ? _handleSignUp
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
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.neutral800,
                                ),
                              ),
                            )
                          : Text(
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
