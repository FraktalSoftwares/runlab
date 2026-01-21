import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/supabase_config.dart';
import 'app.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carregar .env e inicializar Supabase
  await SupabaseConfig.initialize();
  
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
