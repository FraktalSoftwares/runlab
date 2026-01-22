# Erro de CORS e 404 nos Logos dos Patrocinadores

## Problema Identificado

Você está enfrentando dois erros ao carregar logos de patrocinadores no Flutter Web:

### 1. Erro de CORS (Cross-Origin Resource Sharing)
```
Access to XMLHttpRequest at 'https://logos-world.net/...' from origin 'http://localhost:58021' 
has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present on the requested resource.
```

**Causa**: O site `logos-world.net` não permite requisições cross-origin do navegador. Isso é uma política de segurança que impede que sites externos façam requisições para outros domínios sem permissão explícita.

### 2. Erro 404 (Not Found)
```
GET https://logos-world.net/wp-content/uploads/2020/11/Salomon-Logo.png net::ERR_FAILED 404 (Not Found)
GET https://logos-world.net/wp-content/uploads/2020/05/Red-Bull-Logo.png net::ERR_FAILED 404 (Not Found)
```

**Causa**: As URLs específicas para os logos de Salomon e Red Bull não existem mais no servidor. Isso pode acontecer porque:
- O site mudou a estrutura de URLs
- As imagens foram removidas
- Os caminhos estão incorretos

## Onde o Problema Ocorre

As URLs problemáticas estão definidas no arquivo:
- `supabase/migrations/20240121000002_seeds_dev.sql`

E são carregadas no código:
- `lib/features/competitions/pages/competition_detail_page.dart` (linha ~575)

## Soluções

### ✅ Solução Recomendada: Usar Supabase Storage

A melhor solução é armazenar os logos no Supabase Storage, que:
- ✅ Suporta CORS corretamente
- ✅ É confiável e controlado por você
- ✅ Já está integrado ao seu projeto
- ✅ Permite controle total sobre as imagens

**Passos para implementar:**

1. **Criar um bucket no Supabase Storage:**
   ```sql
   -- Execute no Supabase Studio ou via SQL
   INSERT INTO storage.buckets (id, name, public) 
   VALUES ('sponsor-logos', 'sponsor-logos', true);
   ```

2. **Fazer upload dos logos:**
   - Acesse o Supabase Studio → Storage
   - Crie o bucket `sponsor-logos` (público)
   - Faça upload dos logos das marcas

3. **Atualizar as URLs no arquivo de seeds:**
   ```sql
   -- Exemplo de URL do Supabase Storage:
   'https://lpxftanpwzfnuebjxfyc.supabase.co/storage/v1/object/public/sponsor-logos/nike.png'
   ```

### 🔄 Solução Temporária: Usar URLs Alternativas

Como solução temporária, você pode usar:
- URLs de placeholder (ex: `https://via.placeholder.com/150`)
- Serviços de logo API que suportam CORS (ex: logo.dev, clearbit)
- Imagens hospedadas em CDNs públicos que suportam CORS

### 🛠️ Solução de Desenvolvimento: Tratamento de Erros

O código já tem um `errorBuilder` que exibe o nome do patrocinador quando a imagem falha. Isso é bom, mas você pode melhorar:

```dart
errorBuilder: (context, error, stackTrace) {
  // Log do erro para debug
  debugPrint('Erro ao carregar logo: $logoUrl - $error');
  
  // Fallback: exibir nome do patrocinador
  return Container(
    // ... código existente
  );
}
```

## Próximos Passos

1. ✅ **Imediato**: Atualizar o arquivo de seeds com URLs que funcionam ou usar placeholders
2. 🔄 **Curto prazo**: Configurar Supabase Storage e fazer upload dos logos
3. 🎯 **Longo prazo**: Criar um sistema de upload de logos no admin do app

## Referências

- [Documentação do Supabase Storage](https://supabase.com/docs/guides/storage)
- [Política CORS do navegador](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)
- [Flutter Image.network error handling](https://api.flutter.dev/flutter/widgets/Image/Image.network.html)
