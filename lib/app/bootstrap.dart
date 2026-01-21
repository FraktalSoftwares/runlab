import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/supabase_config.dart';
import 'app.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await SupabaseConfig.initialize();
  } catch (e, st) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[RunLab] Erro no bootstrap: $e\n$st');
    }
    runApp(_BootstrapErrorScreen(message: e.toString(), stackTrace: st));
    return;
  }

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

/// Tela exibida quando o bootstrap falha (ex.: SUPABASE_URL/SUPABASE_ANON_KEY ausentes).
class _BootstrapErrorScreen extends StatelessWidget {
  const _BootstrapErrorScreen({
    required this.message,
    this.stackTrace,
  });

  final String message;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Erro ao iniciar o RunLab',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SelectableText(
                  message,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
                if (stackTrace != null) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Stack trace:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    stackTrace.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                const Text(
                  'Se estiver em deploy (ex.: Vercel), confira se SUPABASE_URL e '
                  'SUPABASE_ANON_KEY estão definidas nas variáveis de ambiente e '
                  'são passadas ao build via --dart-define.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
