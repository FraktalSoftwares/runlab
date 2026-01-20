import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Componente Logo do RunLab
/// 
/// Usa imagens SVG locais (assets)
class AppLogo extends StatelessWidget {
  final AppLogoVariant variant;
  final double? width;
  final double? height;

  const AppLogo({
    super.key,
    this.variant = AppLogoVariant.white,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final logoAsset = _getLogoAsset();
    final logoWidth = width ?? 56.0;
    final logoHeight = height ?? 74.0;

    return SvgPicture.asset(
      logoAsset,
      width: logoWidth,
      height: logoHeight,
      fit: BoxFit.contain,
      placeholderBuilder: (BuildContext context) => SizedBox(
        width: logoWidth,
        height: logoHeight,
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  String _getLogoAsset() {
    switch (variant) {
      case AppLogoVariant.white:
        return 'assets/logos/logo_branca.svg';
      case AppLogoVariant.green:
        return 'assets/logos/logo_verde.svg';
      case AppLogoVariant.yellow:
        // Fallback para logo branca
        return 'assets/logos/logo_branca.svg';
    }
  }
}

enum AppLogoVariant {
  white,
  green,
  yellow, // Mantido para compatibilidade
}
