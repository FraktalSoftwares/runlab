import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

/// Serviço de autenticação
class AuthService {
  final _supabase = SupabaseConfig.client;

  /// Obter usuário atual
  User? get currentUser => _supabase.auth.currentUser;

  /// Obter sessão atual
  Session? get currentSession => _supabase.auth.currentSession;

  /// Criar conta e perfil
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    String? birthDate,
    String? gender,
  }) async {
    try {
      // Limpar email (sem toLowerCase para preservar o formato original)
      final cleanEmail = email.trim();
      
      // Validar formato básico de email
      final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegex.hasMatch(cleanEmail)) {
        throw AuthException('Email inválido. Verifique o formato do email.');
      }
      
      // Debug: log do email que será enviado
      print('Tentando criar conta com email: "$cleanEmail" (length: ${cleanEmail.length})');
      
      // Criar usuário no Supabase Auth
      // Nota: Se email confirmation estiver habilitado no Supabase,
      // o usuário precisará confirmar o email antes de fazer login
      final authResponse = await _supabase.auth.signUp(
        email: cleanEmail,
        password: password,
        data: {
          'full_name': fullName,
        },
      );
      
      print('Resposta do signup: user=${authResponse.user?.id}, session=${authResponse.session != null}');

      if (authResponse.user != null) {
        // Criar perfil na tabela profiles
        // birth_date: converter DD/MM/AAAA ou DDMMAAAA para YYYY-MM-DD (PostgreSQL)
        final isoBirthDate = _parseBirthDateToIso(birthDate);
        try {
          await _supabase.from('profiles').insert({
            'id': authResponse.user!.id,
            'full_name': fullName,
            'birth_date': isoBirthDate,
            'gender': gender,
          });
        } catch (e) {
          // Se falhar ao criar perfil, logar mas não falhar o signup
          print('Erro ao criar perfil: $e');
        }
      }

      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  /// Fazer login
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Fazer logout
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// Obter perfil do usuário atual
  /// Usa maybeSingle() para não lançar quando não há perfil (0 rows)
  Future<Map<String, dynamic>?> getProfile() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response == null) return null;
      return Map<String, dynamic>.from(response as Map);
    } catch (e) {
      return null;
    }
  }

  /// Converte data em formato brasileiro (DD/MM/AAAA ou DDMMAAAA) para ISO (YYYY-MM-DD).
  /// Retorna null se vazio ou inválido.
  static String? _parseBirthDateToIso(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final s = raw.trim().replaceAll('/', '');
    if (s.length != 8) return null;
    // DDMMYYYY -> YYYY-MM-DD
    final dd = s.substring(0, 2);
    final mm = s.substring(2, 4);
    final yyyy = s.substring(4, 8);
    final d = int.tryParse(dd);
    final m = int.tryParse(mm);
    final y = int.tryParse(yyyy);
    if (d == null || m == null || y == null) return null;
    if (d < 1 || d > 31 || m < 1 || m > 12 || y < 1900 || y > 2100) return null;
    return '$yyyy-$mm-$dd';
  }

  /// Atualizar perfil com dados do onboarding (distância, experiência, assessoria).
  /// Se [markOnboardingCompleted] for true, define [onboarding_completed_at] no perfil.
  Future<void> updateProfileOnboarding({
    String? preferredDistance,
    String? runningExperience,
    String? advisorCode,
    bool markOnboardingCompleted = false,
  }) async {
    final user = currentUser;
    if (user == null) return;

    final updates = <String, dynamic>{};
    if (preferredDistance != null) updates['preferred_distance'] = preferredDistance;
    if (runningExperience != null) updates['running_experience'] = runningExperience;
    if (advisorCode != null) updates['advisor_code'] = advisorCode;
    if (markOnboardingCompleted) {
      updates['onboarding_completed_at'] = DateTime.now().toUtc().toIso8601String();
    }
    if (updates.isEmpty) return;

    await _supabase.from('profiles').update(updates).eq('id', user.id);
  }

  /// Verificar código OTP (mockado por enquanto)
  Future<bool> verifyEmail(String code) async {
    // TODO: Implementar verificação via Brevo API
    // Por enquanto, apenas retorna true se o código não estiver vazio
    return code.isNotEmpty && code.length == 4;
  }

  /// Stream de mudanças de autenticação (retorna eventos do Supabase)
  Stream get authStateChanges {
    return _supabase.auth.onAuthStateChange;
  }
}
