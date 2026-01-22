# Troubleshooting - Falha de Deploy na Vercel

## Problema
O deploy na Vercel está falhando com erro: "Falha ao compilar e implantar"

## Possíveis Causas e Soluções

### 1. Variáveis de Ambiente Não Configuradas

**Sintoma**: Build falha com erro sobre variáveis não definidas

**Solução**: 
Configure as seguintes variáveis de ambiente na Vercel:
- Settings → Environment Variables
- Adicione:
  - `SUPABASE_URL`: URL do seu projeto Supabase (ex: `https://xxx.supabase.co`)
  - `SUPABASE_ANON_KEY`: Chave anon do Supabase (Project Settings → API → `anon` `public`)

### 2. Erros de Compilação Dart

**Sintoma**: Build falha durante `flutter build web`

**Solução**:
- Execute localmente: `flutter analyze` para verificar erros
- Execute: `flutter build web` para testar o build localmente
- Corrija todos os erros antes de fazer push

### 3. Problemas com o Script de Build

**Sintoma**: Script `vercel-build.sh` falha

**Solução**:
- Verifique se o script tem permissão de execução
- Teste o script localmente:
  ```bash
  bash scripts/vercel-build.sh
  ```

### 4. Dependências Faltando ou Incompatíveis

**Sintoma**: Erro ao resolver dependências

**Solução**:
- Execute: `flutter pub get` localmente
- Verifique se `pubspec.lock` está commitado
- Se necessário, execute: `flutter pub upgrade`

### 5. Timeout no Build

**Sintoma**: Build demora muito e é cancelado

**Solução**:
- A Vercel tem limite de tempo para builds
- O build do Flutter pode demorar (instala SDK, baixa dependências)
- Considere usar GitHub Actions para build e apenas fazer deploy na Vercel

### 6. Problemas com Flutter SDK

**Sintoma**: Erro ao clonar ou instalar Flutter

**Solução**:
- O script `vercel-build.sh` clona o Flutter automaticamente
- Verifique se a versão do Flutter está correta (stable)
- Pode ser problema temporário de rede

## Verificação Local

Antes de fazer push, sempre teste localmente:

```bash
# 1. Verificar análise estática
flutter analyze

# 2. Resolver dependências
flutter pub get

# 3. Testar build web
touch .env
flutter build web \
  --dart-define=SUPABASE_URL="sua_url" \
  --dart-define=SUPABASE_ANON_KEY="sua_chave"

# 4. Verificar se build/web foi criado
ls -la build/web/
```

## Logs de Debug

Para ver logs detalhados do build na Vercel:
1. Acesse o dashboard da Vercel
2. Vá em Deployments
3. Clique no deployment que falhou
4. Veja os logs completos do build

## Workflow Recomendado

1. **Desenvolvimento Local**:
   ```bash
   flutter run -d chrome
   ```

2. **Antes de Commit**:
   ```bash
   flutter analyze
   flutter test
   flutter build web
   ```

3. **Commit e Push**:
   ```bash
   git add .
   git commit -m "sua mensagem"
   git push origin main
   ```

4. **Verificar Deploy**:
   - Aguarde o GitHub Actions ou Vercel processar
   - Verifique os logs se falhar

## Configuração Alternativa: GitHub Actions

Se o build direto na Vercel continuar falhando, use GitHub Actions:

1. O workflow `.github/workflows/deploy-vercel.yml` já está configurado
2. Configure os secrets no GitHub:
   - Settings → Secrets and variables → Actions
   - Adicione: `VERCEL_TOKEN`, `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID`
3. Desative "Deploy on push" na Vercel (Settings → Git → Deploy on push: OFF)

## Contato

Se o problema persistir:
1. Verifique os logs completos na Vercel
2. Teste o build localmente
3. Verifique se todas as variáveis de ambiente estão configuradas
