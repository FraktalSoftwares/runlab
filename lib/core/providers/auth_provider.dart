import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/auth_state.dart' as app_auth;
import '../services/auth_service.dart';

/// Provider do AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Notifier de autenticação
class AuthNotifier extends StateNotifier<app_auth.AppAuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const app_auth.AuthInitial()) {
    _init();
  }

  Future<void> _init() async {
    // Verificar se já existe uma sessão
    final session = _authService.currentSession;
    if (session != null) {
      final profile = await _authService.getProfile();
      state = app_auth.AuthAuthenticated(
        user: session.user,
        profile: profile,
      );
    } else {
      state = const app_auth.AuthUnauthenticated();
    }

    // Escutar mudanças de autenticação
    _authService.authStateChanges.listen((event) {
      final session = event.session;
      if (session != null) {
        final user = session.user;
        if (user != null) {
          _loadProfile(user);
        } else {
          state = const app_auth.AuthUnauthenticated();
        }
      } else {
        state = const app_auth.AuthUnauthenticated();
      }
    });
  }

  Future<void> _loadProfile(User user) async {
    final profile = await _authService.getProfile();
    state = app_auth.AuthAuthenticated(user: user, profile: profile);
  }

  /// Recarrega o perfil do usuário atual (ex.: após concluir onboarding).
  Future<void> refreshProfile() async {
    final session = _authService.currentSession;
    if (session == null) return;
    final profile = await _authService.getProfile();
    state = app_auth.AuthAuthenticated(user: session.user, profile: profile);
  }

  /// Criar conta
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    String? birthDate,
    String? gender,
  }) async {
    state = const app_auth.AuthLoading();
    try {
      final response = await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
        birthDate: birthDate,
        gender: gender,
      );

      // Se o usuário foi criado, mesmo que precise confirmar email
      if (response.user != null) {
        // Se há sessão, usuário está autenticado
        if (response.session != null) {
          final profile = await _authService.getProfile();
          state = app_auth.AuthAuthenticated(
            user: response.user!,
            profile: profile,
          );
        } else {
          // Usuário criado mas precisa confirmar email
          // Ainda assim, considerar sucesso e navegar para verificação
          state = const app_auth.AuthUnauthenticated();
        }
      } else {
        state = const app_auth.AuthUnauthenticated();
      }
    } catch (e) {
      state = app_auth.AuthError(_getErrorMessage(e));
    }
  }

  /// Fazer login
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const app_auth.AuthLoading();
    try {
      final response = await _authService.signIn(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final profile = await _authService.getProfile();
        state = app_auth.AuthAuthenticated(
          user: response.user!,
          profile: profile,
        );
      } else {
        state = const app_auth.AuthUnauthenticated();
      }
    } catch (e) {
      state = app_auth.AuthError(_getErrorMessage(e));
    }
  }

  /// Fazer logout
  Future<void> signOut() async {
    state = const app_auth.AuthLoading();
    try {
      await _authService.signOut();
      state = const app_auth.AuthUnauthenticated();
    } catch (e) {
      state = app_auth.AuthError(_getErrorMessage(e));
    }
  }

  /// Verificar email (mockado)
  Future<bool> verifyEmail(String code) async {
    return await _authService.verifyEmail(code);
  }

  /// Obter mensagem de erro amigável
  String _getErrorMessage(dynamic error) {
    if (error is AuthException) {
      final message = error.message.toLowerCase();
      final statusCode = error.statusCode;
      
      // Log do erro completo para debug
      print('AuthException: message="$message", statusCode=$statusCode');
      print('Erro completo: $error');
      
      // Verificar se a mensagem contém o código de erro específico
      final errorString = error.toString().toLowerCase();
      
      // Erro específico de email inválido
      if (errorString.contains('email_address_invalid') || 
          message.contains('email') && message.contains('invalid')) {
        return 'Email inválido. O Supabase rejeitou este email. Isso pode acontecer se:\n'
            '• O email não atende às validações do Supabase\n'
            '• O Supabase está bloqueando emails de teste\n'
            '• Há configurações de validação mais rigorosas\n\n'
            'Solução: Tente usar um email real ou verifique as configurações no dashboard do Supabase.';
      }
      if (message.contains('email') && message.contains('already')) {
        return 'Email já cadastrado';
      }
      if (message.contains('password') && message.contains('invalid')) {
        return 'Senha inválida';
      }
      if (message.contains('weak')) {
        return 'Senha muito fraca. Use pelo menos 6 caracteres';
      }
      // Erro 400 geral
      if (statusCode == 400) {
        return 'Dados inválidos: ${error.message}';
      }
      return error.message;
    }
    // Log de erros não-AuthException
    print('Erro não-AuthException: $error');
    return 'Erro ao realizar operação. Tente novamente.';
  }
}

/// Provider do AuthNotifier
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, app_auth.AppAuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
