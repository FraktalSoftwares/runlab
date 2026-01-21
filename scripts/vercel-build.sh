#!/bin/bash
set -e

# Flutter não vem no ambiente da Vercel — instalamos no build.
# Defina SUPABASE_URL e SUPABASE_ANON_KEY nas variáveis de ambiente do projeto na Vercel.

echo ">>> Instalando Flutter (stable)..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable .flutter
export PATH="$PWD/.flutter/bin:$PATH"

echo ">>> Flutter: ativando web..."
flutter config --enable-web

echo ">>> Resolvendo dependências..."
flutter pub get

echo ">>> Build web (--dart-define a partir das env da Vercel)..."
flutter build web \
  --dart-define=SUPABASE_URL="${SUPABASE_URL:-}" \
  --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY:-}"

echo ">>> Build concluído. Saída: build/web"
