/// Breakpoints do Design System - Mobile Only
/// 
/// App 100% mobile - sem responsividade web
/// Baseado no design do Figma (390px de largura padrão)
class AppBreakpoints {
  // Largura padrão do design mobile (iPhone/Android)
  static const double mobileWidth = 390.0;
  static const double mobileHeight = 844.0; // Altura padrão iPhone

  // Helpers - sempre retorna true para mobile (app é 100% mobile)
  static bool isMobile(double width) => true;
  static bool isTablet(double width) => false;
  static bool isDesktop(double width) => false;

  // Largura máxima do conteúdo (baseado no Figma)
  static const double maxContentWidth = mobileWidth;

  // Evitar instanciação
  AppBreakpoints._();
}
