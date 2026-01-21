import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/mobile_wrapper.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: 'RunLab',
      routerConfig: router,
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
