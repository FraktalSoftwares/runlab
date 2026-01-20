/// Tokens de espaçamento do Design System
/// 
/// TODO: Preencher com valores extraídos do Figma
/// Estrutura pronta para receber:
/// - Espaçamentos base (4px, 8px, 16px, etc.)
/// - Espaçamentos específicos (padding, margin, gap)
class AppSpacing {
  // Espaçamentos base (sistema de 4px ou 8px)
  // TODO: Verificar sistema de espaçamento do Figma
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Espaçamentos específicos
  // TODO: Extrair valores exatos do Figma
  static const double paddingXS = xs;
  static const double paddingSM = sm;
  static const double paddingMD = md;
  static const double paddingLG = lg;
  static const double paddingXL = xl;

  static const double marginXS = xs;
  static const double marginSM = sm;
  static const double marginMD = md;
  static const double marginLG = lg;
  static const double marginXL = xl;

  static const double gapXS = xs;
  static const double gapSM = sm;
  static const double gapMD = md;
  static const double gapLG = lg;
  static const double gapXL = xl;

  // Evitar instanciação
  AppSpacing._();
}
