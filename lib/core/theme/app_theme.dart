import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
// TODO: Importar app_spacing, app_radii, app_shadows quando necessário

/// Tema principal da aplicação
/// 
/// TODO: Integrar com tokens do Figma quando começar a implementar componentes
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _buildColorScheme(),
      textTheme: _buildTextTheme(),
      // TODO: Adicionar mais customizações do tema conforme necessário
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _buildColorScheme(brightness: Brightness.dark),
      textTheme: _buildTextTheme(),
      // TODO: Adicionar mais customizações do tema conforme necessário
    );
  }

  static ColorScheme _buildColorScheme({Brightness brightness = Brightness.light}) {
    if (brightness == Brightness.dark) {
      // Dark theme com cores do Figma
      return ColorScheme.dark(
        primary: AppColors.lime500,
        surface: AppColors.background,
        onPrimary: AppColors.neutral800,
        onSurface: AppColors.textPrimary,
      );
    } else {
      // Light theme
      return ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
      );
    }
  }

  static TextTheme _buildTextTheme() {
    // TODO: Substituir por valores reais do Figma
    return AppTypography.baseTextTheme;
  }
}
