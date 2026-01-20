import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Primary CTA - Botão verde em formato de meio círculo
/// 
/// Baseado no design do Figma
class AppPrimaryCTA extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double? width;
  final double? height;

  const AppPrimaryCTA({
    super.key,
    required this.child,
    this.onPressed,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width ?? 80,
        height: height ?? 80,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Container(
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}
