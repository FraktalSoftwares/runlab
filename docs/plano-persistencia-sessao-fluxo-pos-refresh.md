# Plano: Persistência de sessão e fluxo pós-refresh

## Contexto

Após login bem-sucedido, o usuário vai para a home (`/`). Ao atualizar o navegador (F5) ou reabrir o app:

- **Problema 1:** O app vai sempre para a tela de **Onboarding**, mesmo com o usuário logado.
- **Problema 2:** Na Onboarding, ao tocar em "Criar conta" ou "Entrar" estando **já autenticado**, o redirect envia para **/** (Bootstrap). O esperado é que, estando logado, o usuário nem chegue ao Onboarding.

**Comportamento desejado:**

- **Usuário logado** → ao atualizar/abrir: ir para a **home** (`/`).
- **Usuário não logado** → ao atualizar/abrir: ir para o **Onboarding** (e de lá para login/signup).

---

## Causas identificadas

1. **Splash** ignora o estado de autenticação e sempre chama `context.go('/onboarding')` após 2 segundos.
2. **Redirect** do GoRouter não trata o estado **AuthInitial** (auth ainda sendo resolvido) nem redireciona usuários autenticados que estejam em `/splash` ou `/onboarding` para a home.
3. O **redirect** só é executado em navegação; quando o auth muda (ex.: de `AuthInitial` para `AuthAuthenticated`) enquanto o usuário está em `/splash`, o redirect não é reavaliado.

---

## 1. Splash: decisão por estado de auth

**Arquivo:** `lib/features/splash/pages/splash_page.dart`

### Alterações

- Trocar de `StatefulWidget` para **`ConsumerStatefulWidget`** para usar `ref` (Riverpod).
- **Remover** o `_navigateToOnboarding()` fixo que faz `context.go('/onboarding')` após 2 segundos.
- **Nova lógica de navegação:**
  - **AuthAuthenticated** → `context.go('/')` (home)
  - **AuthUnauthenticated** → `context.go('/onboarding')`
  - **AuthInitial** → permanecer na Splash até o auth sair de Initial.
- **Timeout de 3 segundos:** se após 3s o estado continuar `AuthInitial` (Supabase lento ou falha), fazer `context.go('/onboarding')` como fail-safe.
- **Evitar dupla navegação:** usar um `_hasNavigated` no `State` e checar antes de cada `context.go`; garantir `mounted` antes de navegar e definir `_hasNavigated = true` ao navegar.

### Implementação

- Usar `ref.watch(authNotifierProvider)` no `build` para reagir a mudanças de auth.
- Usar `ref.listen(authNotifierProvider, (prev, next) { ... })` para reagir **quando** o estado sair de `AuthInitial` (o `ref.listen` não dispara para o valor inicial; o `ref.watch` cobre o caso em que a Splash já abre com auth resolvido).
- No `build`: se `auth is! AuthInitial && !_hasNavigated`, marcar `_hasNavigated` e em `WidgetsBinding.instance.addPostFrameCallback` executar `context.go('/')` ou `context.go('/onboarding')` conforme o tipo.
- No `ref.listen`: se `next is! AuthInitial && !_hasNavigated`, marcar e fazer o `context.go` correspondente.
- Em `initState`: criar `Timer(Duration(seconds: 3), () { ... })`. No callback: se `mounted && !_hasNavigated && ref.read(authNotifierProvider) is AuthInitial`, então `_hasNavigated = true` e `context.go('/onboarding')`.
- Imports: `package:flutter_riverpod/flutter_riverpod.dart`, `dart:async` (Timer), `go_router`, `app_auth` (auth_state).

---

## 2. Router: redirect e `router.refresh`

**Arquivo:** `lib/app/router.dart`

### Alterações no `redirect`

- **AuthInitial:**
  - Se `state.uri.path == '/'`: fazer `return '/splash'`. Assim, em cold start/refresh com rota `/`, não se mostra home nem login antes do auth; a Splash espera e decide.
- **AuthAuthenticated:**
  - Manter: `'/login'` ou `'/signup'` → `'/'`.
  - **Adicionar:** `'/splash'` ou `'/onboarding'` → `'/'`. Assim, se o usuário logado cair nessas telas (URL direta ou race), vai para a home.
- **AuthUnauthenticated:**
  - Manter: `'/'` → `'/login'`.
  - Manter o resto da lógica (rotas públicas, etc.).

### Reavaliar redirect quando o auth mudar

- O `redirect` do GoRouter só roda em navegação. Se o auth mudar de `AuthInitial` para `AuthAuthenticated` enquanto o usuário está em `/splash`, o redirect não seria reexecutado.
- Para forçar a reexecução: chamar **`router.refresh()`** sempre que o `authNotifierProvider` mudar.
- No `appRouterProvider`, após criar o `GoRouter`:
  ```dart
  ref.listen<app_auth.AppAuthState>(authNotifierProvider, (prev, next) {
    router.refresh();
  });
  ```
- Assim, ao sair de `AuthInitial` ou ao alterar entre `AuthAuthenticated` e `AuthUnauthenticated`, o `redirect` é reavaliado.

---

## 3. Sobre "Criar conta" / "Entrar" indo para Bootstrap

- Com o redirect novo, usuário autenticado em `/onboarding` é enviado para `'/'` (home). Ele deixa de ver o Onboarding nesse cenário.
- Se, por atraso, ainda tocar em "Criar conta" ou "Entrar", o redirect atual já manda `'/signup'` e `'/login'` para `'/'` quando autenticado; isso continua correto. Nenhuma alteração nos botões da Onboarding.

---

## 4. Fluxo desejado (resumo)

- **Logado + refresh/abrir app:** `redirect` ou Splash enviam para **`/`** (home).
- **Não logado + refresh/abrir app:** Splash (ou redirect) envia para **`/onboarding`**; de lá, "Criar conta" e "Entrar" levam a `/signup` e `/login`.

### Diagrama

```
Cold start ou F5 (URL: /, /splash ou /onboarding)
    │
    ▼
┌───redirect───────────────────────────────────────┐
│ • AuthInitial e path='/'        → /splash        │
│ • AuthAuthenticated e /splash,  → /              │
│   /onboarding, /login, /signup                   │
│ • AuthUnauthenticated e path='/'→ /login         │
│ • Demais casos                  → manter         │
└──────────────────────────────────────────────────┘
    │
    ▼ (se foi para /splash)
┌───Splash (auth?)─────────────────────────────────┐
│ • AuthInitial     → esperar; se 3s → /onboarding │
│ • AuthAuthenticated → /                          │
│ • AuthUnauthenticated → /onboarding              │
└──────────────────────────────────────────────────┘
```

---

## 5. Arquivos a alterar

| Arquivo | Alterações |
|---------|------------|
| `lib/features/splash/pages/splash_page.dart` | ConsumerStatefulWidget; `ref.watch`/`ref.listen` em `authNotifierProvider`; lógica de navegação por auth; timeout 3s; `_hasNavigated`; remover `_navigateToOnboarding` fixo. |
| `lib/app/router.dart` | No `redirect`: AuthInitial e `'/'` → `'/splash'`; AuthAuthenticated e `'/splash'` ou `'/onboarding'` → `'/'`. `ref.listen(authNotifierProvider, (_, __) => router.refresh())` no `appRouterProvider`. |

---

## 6. Imports necessários

### Splash

- `package:flutter_riverpod/flutter_riverpod.dart`
- `dart:async` (Timer)
- `go_router`
- `app_auth` (auth_state)

### Router

- Já utiliza `ref` e `authNotifierProvider`; apenas acrescentar o `ref.listen` e a chamada a `router.refresh()`.

---

## 7. Ordem sugerida de implementação

1. Ajustar o **redirect** e o **`ref.listen`** em `lib/app/router.dart`.
2. Refatorar a **Splash** em `lib/features/splash/pages/splash_page.dart` com a nova lógica e o timeout.

---

*Documento criado em 20/01/2026.*
