import 'package:flutter/material.dart';

/// Tokens de raios de borda (border radius) do Design System
/// 
/// TODO: Preencher com valores extraídos do Figma
/// Estrutura pronta para receber:
/// - Raios pequenos (buttons, chips)
/// - Raios médios (cards, dialogs)
/// - Raios grandes (modals, sheets)
class AppRadii {
  // Raios de borda
  // TODO: Extrair valores exatos do Figma
  static const double none = 0.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 9999.0; // Para círculos e pills

  // BorderRadius helpers
  static const BorderRadius radiusXS = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusSM = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMD = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLG = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXL = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusFull = BorderRadius.all(Radius.circular(full));

  // Evitar instanciação
  AppRadii._();
}
