import 'package:flutter/material.dart';
import 'router.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/mobile_wrapper.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'RunLab',
      routerConfig: appRouter,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Usar dark theme por padrão
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Wrapper mobile para garantir layout fixo mesmo em web
        return MobileWrapper(child: child ?? const SizedBox());
      },
    );
  }
}
