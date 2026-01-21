import 'package:supabase_flutter/supabase_flutter.dart';

/// Estado de autenticação do usuário (renomeado para evitar conflito com gotrue)
sealed class AppAuthState {
  const AppAuthState();
}

/// Estado inicial (carregando)
class AuthInitial extends AppAuthState {
  const AuthInitial();
}

/// Estado de carregamento
class AuthLoading extends AppAuthState {
  const AuthLoading();
}

/// Estado autenticado
class AuthAuthenticated extends AppAuthState {
  final User user;
  final Map<String, dynamic>? profile;

  const AuthAuthenticated({
    required this.user,
    this.profile,
  });
}

/// Estado não autenticado
class AuthUnauthenticated extends AppAuthState {
  const AuthUnauthenticated();
}

/// Estado de erro
class AuthError extends AppAuthState {
  final String message;

  const AuthError(this.message);
}
