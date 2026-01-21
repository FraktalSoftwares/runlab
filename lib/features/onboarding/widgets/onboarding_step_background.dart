import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Fundo dos Steps (Figma 163-4226): mesma imagem de boas-vindas.
/// Imagem em tela cheia com overlay escuro e gradiente na base.
class OnboardingStepBackground extends StatelessWidget {
  static const String _imageAsset = 'assets/images/boas_vindas_background.png';

  const OnboardingStepBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Imagem de fundo (mesma de boas-vindas; opacidade 0.9)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(color: AppColors.background),
              child: Opacity(
                opacity: 0.9,
                child: Image.asset(
                  _imageAsset,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.grey.shade900, Colors.black],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.fitness_center,
                          size: 200,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),  // 1. Imagem
          // 2. Overlay escuro em tela cheia (contraste para o texto)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, 0.45),
              ),
            ),
          ),
          // 3. Gradiente mais forte na base (Figma: "heavier towards the bottom")
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 433,
            child: IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color.fromRGBO(0, 0, 0, 0.5),
                      Color.fromRGBO(0, 0, 0, 0.82),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
