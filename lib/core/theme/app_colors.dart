import 'package:flutter/material.dart';

/// Tokens de cores do Design System
/// 
/// TODO: Preencher com valores extraídos do Figma
/// Estrutura pronta para receber:
/// - Cores primárias
/// - Cores secundárias
/// - Cores semânticas (success, error, warning, info)
/// - Cores neutras (background, surface, text)
/// - Cores de estado (hover, pressed, disabled)
class AppColors {
  // Cores primárias (verde brilhante do design)
  static const Color primary = Color(0xFF00FF88); // Verde brilhante
  static const Color primaryLight = Color(0xFF33FFAA);
  static const Color primaryDark = Color(0xFF00CC6A);

  // Cores secundárias
  static const Color secondary = Color(0xFF6B7280); // Cinza neutro
  static const Color secondaryLight = Color(0xFF9CA3AF);
  static const Color secondaryDark = Color(0xFF4B5563);

  // Cores semânticas
  static const Color success = Color(0xFF00FF88); // Verde brilhante
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Cores neutras (dark theme) - Extraídas do Figma
  static const Color background = Color(0xFF000000); // Brand/neutral/neutral-900 (base)
  static const Color surface = Color(0xFF191919); // Brand/neutral/neutral-750
  static const Color textPrimary = Color(0xFFFFFFFF); // Brand/neutral/neutral-100
  static const Color textSecondary = Color(0xFF9CA3AF); // Texto cinza claro
  static const Color textDisabled = Color(0xFF6B7280);

  // Cores específicas do design - Extraídas do Figma
  static const Color logoYellow = Color(0xFFFFD700); // Amarelo do logo
  static const Color logoWhite = Color(0xFFFFFFFF); // Branco do logo
  static const Color lime500 = Color(0xFFCCF725); // Brand/lime/lime-500 (base) - Verde neon do logo
  static const Color yellow500 = Color(0xFFFFD60A); // Brand/yellow/yellow-500 (base)
  static const Color red500 = Color(0xFFFF3922); // Brand/red/red-500 (base)
  static const Color neutral100 = Color(0xFFFFFFFF); // Brand/neutral/neutral-100
  static const Color neutral200 = Color(0xFFF5F5F5); // Brand/neutral/neutral-200
  static const Color neutral300 = Color(0xFFE0E0E0); // Brand/neutral/neutral-300
  static const Color neutral400 = Color(0xFFB2B2B2); // Brand/neutral/neutral-400
  static const Color neutral500 = Color(0xFF808080); // Brand/neutral/neutral-500
  static const Color neutral600 = Color(0xFF4C4C4C); // Brand/neutral/neutral-600
  static const Color neutral700 = Color(0xFF262626); // Brand/neutral/neutral-700
  static const Color neutral750 = Color(0xFF191919); // Brand/neutral/neutral-750
  static const Color neutral800 = Color(0xFF121212); // Brand/neutral/neutral-800

  // Cores de estado
  // TODO: Extrair do Figma
  static const Color hover = Colors.black12;
  static const Color pressed = Colors.black26;
  static const Color disabled = Colors.black12;

  // Evitar instanciação
  AppColors._();
}
