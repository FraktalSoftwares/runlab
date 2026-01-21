import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Configuração e inicialização do Supabase
class SupabaseConfig {
  static Future<void> initialize() async {
    // Carregar .env quando existir (mobile; na web o asset pode 404 e usamos --dart-define)
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // .env ausente ou inacessível (ex.: web sem o arquivo no bundle)
    }

    final supabaseUrl = dotenv.env['SUPABASE_URL'] ??
        String.fromEnvironment('SUPABASE_URL', defaultValue: '');
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ??
        String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception(
        'SUPABASE_URL e SUPABASE_ANON_KEY são obrigatórios. '
        'Crie um .env na raiz do projeto ou rode com:\n'
        '  --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...',
      );
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
