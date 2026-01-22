# Setup Supabase - RunLab

Este documento descreve como configurar e usar o Supabase CLI no projeto RunLab.

## Pré-requisitos

- Node.js e npm instalados
- Conta no Supabase (para deploy remoto)

## Instalação do Supabase CLI

O Supabase CLI não pode ser instalado globalmente via npm. Use `npx` para executar comandos:

```bash
npx supabase@latest <comando>
```

Ou crie um alias no seu shell:

```bash
alias supabase='npx supabase@latest'
```

## Estrutura do Projeto

```
supabase/
├── config.toml          # Configuração do Supabase CLI
├── migrations/          # Migrations versionadas (SQL)
│   └── YYYYMMDDHHMMSS_nome.sql
└── seed.sql             # Seeds opcionais (dados de desenvolvimento)
```

## Comandos Principais

### Iniciar Supabase Local

Inicia todos os serviços localmente (PostgreSQL, API, Auth, Storage, etc.):

```bash
npx supabase@latest start
```

Isso inicia:
- **PostgreSQL**: `postgresql://postgres:postgres@127.0.0.1:54322/postgres`
- **API**: `http://127.0.0.1:54321`
- **Studio**: `http://127.0.0.1:54323` (interface web)
- **Inbucket** (email testing): `http://127.0.0.1:54324`

### Parar Supabase Local

```bash
npx supabase@latest stop
```

### Criar Nova Migration

Cria um novo arquivo de migration com timestamp:

```bash
npx supabase@latest migration new <nome_da_migration>
```

Exemplo:
```bash
npx supabase@latest migration new initial_schema
# Cria: supabase/migrations/20240121120000_initial_schema.sql
```

### Aplicar Migrations

**Reset completo** (apaga tudo e recria do zero):
```bash
npx supabase@latest db reset
```

**Aplicar apenas migrations pendentes**:
```bash
npx supabase@latest migration up
```

### Vincular ao Projeto Remoto

1. Obtenha o **Project Reference** no dashboard do Supabase (Settings → General → Reference ID)
2. Vincule:
```bash
npx supabase@latest link --project-ref <project-ref>
```

### Aplicar Migrations no Remoto

Depois de vincular, envie as migrations:

```bash
npx supabase@latest db push
```

**⚠️ ATENÇÃO**: `db push` aplica migrations no banco de produção. Use com cuidado!

### Ver Status das Migrations

```bash
npx supabase@latest migration list
```

## Variáveis de Ambiente

### Local (`.env`)

Crie um arquivo `.env` na raiz do projeto:

```env
SUPABASE_URL=http://127.0.0.1:54321
SUPABASE_ANON_KEY=<chave_anon_local>
```

Para obter a chave anon local:
```bash
npx supabase@latest status
```

### Produção (Vercel)

Configure no dashboard da Vercel:
- **Settings → Environment Variables**
- `SUPABASE_URL`: URL do seu projeto Supabase (ex: `https://xxx.supabase.co`)
- `SUPABASE_ANON_KEY`: Chave anon do Supabase (Project Settings → API → `anon` `public`)

## Workflow de Desenvolvimento

1. **Desenvolvimento Local**:
   ```bash
   npx supabase@latest start
   # Desenvolva e teste localmente
   ```

2. **Criar Migration**:
   ```bash
   npx supabase@latest migration new minha_mudanca
   # Edite o arquivo SQL criado
   ```

3. **Testar Migration**:
   ```bash
   npx supabase@latest db reset  # Aplica todas as migrations
   ```

4. **Aplicar no Remoto** (após revisão):
   ```bash
   npx supabase@latest db push
   ```

## Seeds (Dados de Desenvolvimento)

Os seeds são aplicados automaticamente após as migrations quando você roda `db reset`.

Arquivo: `supabase/seed.sql`

**⚠️ IMPORTANTE**: Seeds são apenas para desenvolvimento. Não inclua dados sensíveis ou de produção.

## Acessar Supabase Studio Local

Após iniciar o Supabase local:

```bash
npx supabase@latest start
```

Acesse: http://127.0.0.1:54323

O Studio permite:
- Ver tabelas e dados
- Executar queries SQL
- Gerenciar autenticação
- Testar APIs

## Troubleshooting

### Porta já em uso

Se as portas padrão estiverem ocupadas, edite `supabase/config.toml` e altere:
- `[db].port` (padrão: 54322)
- `[api].port` (padrão: 54321)
- `[studio].port` (padrão: 54323)

### Erro ao iniciar

```bash
npx supabase@latest stop
npx supabase@latest start
```

### Limpar tudo e recomeçar

```bash
npx supabase@latest stop --no-backup
npx supabase@latest start
```

## Referências

- [Documentação Supabase CLI](https://supabase.com/docs/guides/cli)
- [Guia de Migrations](https://supabase.com/docs/guides/cli/local-development#database-migrations)
- [RLS (Row Level Security)](https://supabase.com/docs/guides/auth/row-level-security)
