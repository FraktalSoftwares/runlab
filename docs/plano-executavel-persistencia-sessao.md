# Plano executável: Persistência de sessão e fluxo pós-refresh

Checklist de passos com alterações concretas. Executar na ordem.

---

## Parte 1: Router (`lib/app/router.dart`)

### 1.1 Guardar o GoRouter em variável e adicionar `ref.listen`

**Onde:** `appRouterProvider`, função do `Provider<GoRouter>`.

**De:**
```dart
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
```

**Para:**
```dart
final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
```

---

### 1.2 Trocar o `return` final do Provider

**Onde:** Final do bloco do `GoRouter`, antes do `);` que fecha o `GoRouter(`.

**De:**
```dart
    GoRoute(
      path: '/ui-kit',
      name: 'ui-kit',
      builder: (context, state) => const UIKitPage(),
    ),
    ],
  );
});
```

**Para:**
```dart
    GoRoute(
      path: '/ui-kit',
      name: 'ui-kit',
      builder: (context, state) => const UIKitPage(),
    ),
    ],
  );

  ref.listen<app_auth.AppAuthState>(authNotifierProvider, (prev, next) {
    router.refresh();
  });

  return router;
});
```

---

### 1.3 Incluir regra para AuthInitial no `redirect`

**Onde:** No início do bloco `redirect`, logo após `final authState = ref.read(authNotifierProvider);` e antes de `final publicRoutes = ...`.

**Inserir:**
```dart
      // Auth ainda não resolvido: / vai para /splash para ela decidir
      if (authState is app_auth.AuthInitial && state.uri.path == '/') {
        return '/splash';
      }
```

---

### 1.4 Ampliar regra para autenticados (splash e onboarding)

**Onde:** No `redirect`, no bloco que trata autenticado em login/signup.

**De:**
```dart
      // Se está autenticado e tenta acessar login/signup, redirecionar para home
      if (isAuthenticated && (state.uri.path == '/login' || state.uri.path == '/signup')) {
        return '/';
      }
```

**Para:**
```dart
      // Se está autenticado em login, signup, splash ou onboarding, redirecionar para home
      if (isAuthenticated &&
          (state.uri.path == '/login' ||
              state.uri.path == '/signup' ||
              state.uri.path == '/splash' ||
              state.uri.path == '/onboarding')) {
        return '/';
      }
```

---

## Parte 2: Splash (`lib/features/splash/pages/splash_page.dart`)

### 2.1 Imports

**Onde:** No topo do arquivo.

**De:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/widgets.dart';
```

**Para:**
```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/auth_state.dart' as app_auth;
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/widgets.dart';
```

---

### 2.2 Trocar para ConsumerStatefulWidget

**De:**
```dart
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Configurar status bar para light content (texto branco)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    
    // Navegar para onboarding após 2 segundos (tempo de exibição do splash)
    _navigateToOnboarding();
  }

  Future<void> _navigateToOnboarding() async {
    // Aguardar 2 segundos para exibir o splash
    await Future.delayed(const Duration(seconds: 2));
    
    // Verificar se o widget ainda está montado antes de navegar
    if (mounted) {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: _buildLogo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AppLogo(
      variant: AppLogoVariant.green,
      width: 56,
      height: 74,
    );
  }
}
```

**Para:**
```dart
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _hasNavigated = false;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    _timeoutTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && !_hasNavigated &&
          ref.read(authNotifierProvider) is app_auth.AuthInitial) {
        _hasNavigated = true;
        context.go('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  void _navigateIfReady(app_auth.AppAuthState auth) {
    if (_hasNavigated || !mounted) return;
    if (auth is app_auth.AuthInitial) return;

    _hasNavigated = true;
    if (auth is app_auth.AuthAuthenticated) {
      context.go('/');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<app_auth.AppAuthState>(authNotifierProvider, (prev, next) {
      if (next is! app_auth.AuthInitial) _navigateIfReady(next);
    });

    final auth = ref.watch(authNotifierProvider);
    if (auth is! app_auth.AuthInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _navigateIfReady(auth));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: _buildLogo()),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AppLogo(
      variant: AppLogoVariant.green,
      width: 56,
      height: 74,
    );
  }
}
```

**Nota:** O bloco "De" inclui a classe inteira (até `_buildLogo` e o `}` final). O "Para" substitui tudo isso de uma vez; o `_buildLogo` permanece no "Para" com a mesma implementação.

---

## Resumo da ordem de execução

| # | Arquivo | Ação |
|---|---------|------|
| 1 | `lib/app/router.dart` | 1.1 Criar variável `router` |
| 2 | `lib/app/router.dart` | 1.2 `ref.listen` + `return router` |
| 3 | `lib/app/router.dart` | 1.3 Regra AuthInitial `'/'` → `'/splash'` |
| 4 | `lib/app/router.dart` | 1.4 Incluir `/splash` e `/onboarding` na regra de autenticado |
| 5 | `lib/features/splash/pages/splash_page.dart` | 2.1 Novos imports |
| 6 | `lib/features/splash/pages/splash_page.dart` | 2.2 ConsumerStatefulWidget, initState, dispose, _navigateIfReady, build com ref.listen/ref.watch, Scaffold e _buildLogo |

---

## Como validar

1. **Logado + F5 em `/`:** deve ir para `/` (home/Bootstrap).
2. **Não logado + F5:** deve ir para Splash e em seguida para Onboarding.
3. **Logado + URL `/onboarding`:** redirect para `/`.
4. **Não logado + URL `/`:** redirect para `/login` (comportamento atual mantido).

---

*Documento criado em 20/01/2026.*
