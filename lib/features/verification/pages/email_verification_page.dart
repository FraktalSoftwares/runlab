import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/widgets.dart';

/// Tela de Verificação de Email
///
/// Baseada no design do Figma (node-id: 58-5003, 58-5035)
class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final List<TextEditingController> _codeControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
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
        title: 'Verificação',
        onBackPressed: () => context.pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.xxl),
              // Ícone de email (estrutura do Figma: 100x100 externo, 80x80 interno)
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
                        child: Icon(
                          Icons.email,
                          size: 36,
                          color: AppColors.neutral800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              // Título e texto explicativo
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Vamos confirmar seu e-mail',
                      style: TextStyle(
                        color: AppColors.neutral200,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Enviamos um código para seu e-mail.\nDigite abaixo para confirmar.',
                      style: TextStyle(
                        color: AppColors.neutral400,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 48),
              // Campos de código OTP
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(4, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index < 3 ? 6 : 0,
                      ),
                      child: _buildCodeField(index),
                    ),
                  );
                }),
              ),
              SizedBox(height: AppSpacing.lg),
              // Link "Não chegou o código?"
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Não chegou o código?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.neutral500,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.all(12),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 77,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: Colors.black.withValues(alpha: 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO: Implementar reenvio de código
                            },
                            child: Text(
                              'Reenviar',
                              style: TextStyle(
                                color: AppColors.lime500,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Botão Continuar
              Container(
                width: double.infinity,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: _isCodeComplete() ? AppColors.lime500 : AppColors.neutral750,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Stack(
                  children: [
                    if (_isCodeComplete())
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.02),
                          ),
                        ),
                      ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _isCodeComplete()
                            ? () {
                                // TODO: Validar código e navegar
                                context.go('/');
                              }
                            : null,
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          width: double.infinity,
                          height: 48,
                          alignment: Alignment.center,
                          child: Text(
                            'Continuar',
                            style: TextStyle(
                              color: _isCodeComplete() ? AppColors.neutral800 : AppColors.neutral500,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeField(int index) {
    final hasValue = _codeControllers[index].text.isNotEmpty;

    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: ShapeDecoration(
        color: hasValue ? AppColors.lime500 : Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: hasValue ? Colors.transparent : AppColors.neutral600,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      child: Center(
        child: TextField(
          controller: _codeControllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: TextStyle(
            color: hasValue ? AppColors.neutral800 : AppColors.neutral500,
            fontSize: 48,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            setState(() {});
            if (value.isNotEmpty && index < 3) {
              _focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }

  bool _isCodeComplete() {
    return _codeControllers.every((controller) => controller.text.isNotEmpty);
  }
}
