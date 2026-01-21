#!/bin/bash
set -e

# Em caso de erro, mostra o comando que falhou
trap 'echo ">>> ERRO: comando falhou: $BASH_COMMAND" 1>&2' ERR

# Flutter não vem no ambiente da Vercel — instalamos no build.
# Defina SUPABASE_URL e SUPABASE_ANON_KEY nas variáveis de ambiente do projeto na Vercel.

echo ">>> 1/5 Clonando Flutter (stable)..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable .flutter
export PATH="$PWD/.flutter/bin:$PATH"

echo ">>> 2/5 Verificando Flutter (primeira execução baixa Dart/artefatos)..."
flutter --version

echo ">>> 3/5 Resolvendo dependências..."
flutter pub get

echo ">>> 4/5 Build web (SUPABASE_* vêm das env da Vercel)..."
flutter build web \
  --dart-define=SUPABASE_URL="${SUPABASE_URL:-}" \
  --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY:-}"

echo ">>> 5/5 Build concluído. Saída: build/web"
ls -la build/web/ | head -20
