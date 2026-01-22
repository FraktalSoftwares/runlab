import 'package:flutter/material.dart';

/// Tokens de tipografia do Design System
/// 
/// TODO: Preencher com valores extraídos do Figma
/// Estrutura pronta para receber:
/// - Família de fontes
/// - Tamanhos de fonte (display, headline, title, body, label, caption)
/// - Pesos de fonte (regular, medium, semibold, bold)
/// - Alturas de linha
/// - Espaçamento entre letras
class AppTypography {
  // Família de fontes
  // TODO: Adicionar fontes ao pubspec.yaml
  static const String fontFamily = 'FranklinGothic URW';

  // Tamanhos de fonte
  // TODO: Extrair valores exatos do Figma
  static const double displayLarge = 57;
  static const double displayMedium = 45;
  static const double displaySmall = 36;

  static const double headlineLarge = 32;
  static const double headlineMedium = 28;
  static const double headlineSmall = 24;

  static const double titleLarge = 22;
  static const double titleMedium = 16;
  static const double titleSmall = 14;

  static const double bodyLarge = 16;
  static const double bodyMedium = 14;
  static const double bodySmall = 12;

  static const double labelLarge = 14;
  static const double labelMedium = 12;
  static const double labelSmall = 11;

  static const double caption = 12;

  // Pesos de fonte
  // TODO: Verificar pesos disponíveis no Figma
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // TextTheme base (Material 3)
  // TODO: Customizar com valores do Figma
  static TextTheme get baseTextTheme {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: displayLarge,
        fontWeight: regular,
        fontFamily: fontFamily,
      ),
      displayMedium: TextStyle(
        fontSize: displayMedium,
        fontWeight: regular,
        fontFamily: fontFamily,
      ),
      displaySmall: TextStyle(
        fontSize: displaySmall,
        fontWeight: regular,
        fontFamily: fontFamily,
      ),
      headlineLarge: TextStyle(
        fontSize: headlineLarge,
        fontWeight: regular,
        fontFamily: fontFamily,
      ),
      headlineMedium: TextStyle(
        fontSize: headlineMedium,
        fontWeight: regular,
        fontFamily: fontFamily,
      ),
      headlineSmall: TextStyle(
        fontSize: headlineSmall,
        fontWeight: regular,
        fontFamily: fontFamily,
      ),
      titleLarge: TextStyle(
        fontSize: titleLarge,
        fontWeight: medium,
        fontFamily: fontFamily,
      ),
      titleMedium: TextStyle(
        fontSize: titleMedium,
        fontWeight: medium,
        fontFamily: fontFamily,
      ),
      titleSmall: TextStyle(
        fontSize: titleSmall,
        fontWeight: medium,
        fontFamily: fontFamily,
      ),
      bodyLarge: TextStyle(
        fontSize: bodyLarge,
        fontWeight: regular,
        fontFamily: fontFamily,
      ),
      bodyMedium: TextStyle(
        fontSize: bodyMedium,
        fontWeight: regular,
        fontFamily: fontFamily,
      ),
      bodySmall: TextStyle(
        fontSize: bodySmall,
        fontWeight: regular,
        fontFamily: fontFamily,
      ),
      labelLarge: TextStyle(
        fontSize: labelLarge,
        fontWeight: medium,
        fontFamily: fontFamily,
      ),
      labelMedium: TextStyle(
        fontSize: labelMedium,
        fontWeight: medium,
        fontFamily: fontFamily,
      ),
      labelSmall: TextStyle(
        fontSize: labelSmall,
        fontWeight: medium,
        fontFamily: fontFamily,
      ),
    );
  }

  // Evitar instanciação
  AppTypography._();
}
