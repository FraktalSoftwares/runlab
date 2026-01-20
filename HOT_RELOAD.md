# Guia de Hot Reload/Hot Restart

## Como aplicar mudanças sem reiniciar o servidor

### Hot Reload (mudanças simples)
- Pressione `r` (minúsculo) no terminal onde o Flutter está rodando
- Funciona para mudanças em widgets, cores, textos simples

### Hot Restart (mudanças estruturais)
- Pressione `R` (maiúsculo) no terminal onde o Flutter está rodando
- Use quando:
  - Mudar estrutura de widgets
  - Adicionar/remover propriedades de classes
  - Mudar inicializações de variáveis
  - Mudar imports

### Quando reiniciar completamente
- Apenas quando:
  - Mudar dependências no `pubspec.yaml`
  - Mudar configurações nativas (Android/iOS)
  - Problemas de compilação

## Dica
Mantenha o terminal do Flutter visível e use `R` (maiúsculo) sempre que fizer mudanças estruturais. É muito mais rápido que reiniciar!

## Erros Comuns

### "Bad state: No active isolate to resume"
Este erro aparece às vezes quando você faz hot restart e o aplicativo já foi finalizado ou não há um isolate ativo. **Geralmente não é um problema sério** e pode ser ignorado se o app continuar funcionando.

**Causas comuns:**
- O app foi fechado/encerrado antes do hot restart
- Problemas temporários com o debugger (especialmente em modo web)
- O hot restart foi tentado em um momento em que o app não estava mais ativo

**Soluções:**
1. **Ignore o erro** se o app continuar funcionando normalmente
2. Se o app parar de responder, **reinicie completamente** o servidor Flutter
3. Em modo web, às vezes é necessário **recarregar a página** no navegador
4. Se persistir, feche o servidor e inicie novamente com `flutter run`
