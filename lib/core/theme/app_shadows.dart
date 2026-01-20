import 'package:flutter/material.dart';

/// Tokens de sombras do Design System
/// 
/// TODO: Preencher com valores extraídos do Figma
/// Estrutura pronta para receber:
/// - Sombras pequenas (elevated buttons, chips)
/// - Sombras médias (cards, dialogs)
/// - Sombras grandes (modals, sheets)
class AppShadows {
  // Sombras
  // TODO: Extrair valores exatos do Figma (offset, blur, spread, color, opacity)
  static const BoxShadow none = BoxShadow(
    color: Colors.transparent,
    offset: Offset.zero,
    blurRadius: 0,
    spreadRadius: 0,
  );

  static const BoxShadow sm = BoxShadow(
    color: Colors.black12,
    offset: Offset(0, 1),
    blurRadius: 2,
    spreadRadius: 0,
  );

  static const BoxShadow md = BoxShadow(
    color: Colors.black12,
    offset: Offset(0, 2),
    blurRadius: 4,
    spreadRadius: 0,
  );

  static const BoxShadow lg = BoxShadow(
    color: Colors.black12,
    offset: Offset(0, 4),
    blurRadius: 8,
    spreadRadius: 0,
  );

  static const BoxShadow xl = BoxShadow(
    color: Colors.black12,
    offset: Offset(0, 8),
    blurRadius: 16,
    spreadRadius: 0,
  );

  // Listas de sombras (para usar com BoxDecoration)
  static const List<BoxShadow> shadowSM = [sm];
  static const List<BoxShadow> shadowMD = [md];
  static const List<BoxShadow> shadowLG = [lg];
  static const List<BoxShadow> shadowXL = [xl];

  // Evitar instanciação
  AppShadows._();
}
