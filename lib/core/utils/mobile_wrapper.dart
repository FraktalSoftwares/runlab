import 'package:flutter/material.dart';
import 'breakpoints.dart';

/// Wrapper para garantir que o app seja sempre mobile
/// 
/// Força o layout mobile mesmo em web/desktop
/// Útil para desenvolvimento e testes
class MobileWrapper extends StatelessWidget {
  final Widget child;

  const MobileWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Em web/desktop, centraliza e limita a largura
        if (constraints.maxWidth > AppBreakpoints.mobileWidth) {
          return Center(
            child: Container(
              width: AppBreakpoints.mobileWidth,
              height: constraints.maxHeight,
              decoration: BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(0, 0, 0, 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: child,
            ),
          );
        }
        
        // Em mobile real, renderiza normalmente
        return child;
      },
    );
  }
}
