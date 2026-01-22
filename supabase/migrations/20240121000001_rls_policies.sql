-- Migration: RLS (Row Level Security) e Policies
-- Habilita RLS em todas as tabelas e cria policies de segurança

-- ============================================================================
-- 1. PROFILES - RLS habilitado, usuário acessa apenas próprio perfil
-- ============================================================================
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Policy: SELECT - usuário vê apenas o próprio perfil
CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

-- Policy: INSERT - usuário cria apenas o próprio perfil
CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Policy: UPDATE - usuário atualiza apenas o próprio perfil
CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- ============================================================================
-- 2. COMPETITIONS - Leitura pública, escrita apenas admin/service_role
-- ============================================================================
ALTER TABLE competitions ENABLE ROW LEVEL SECURITY;

-- Policy: SELECT - leitura pública (qualquer usuário autenticado pode ver)
CREATE POLICY "Competitions are viewable by authenticated users"
  ON competitions FOR SELECT
  TO authenticated
  USING (true);

-- Policy: INSERT/UPDATE/DELETE - apenas service_role (via SQL/admin)
-- Não criamos policies para INSERT/UPDATE/DELETE, então apenas service_role pode modificar

-- ============================================================================
-- 3. COMPETITION_DISTANCES - Leitura pública, escrita apenas admin
-- ============================================================================
ALTER TABLE competition_distances ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Competition distances are viewable by authenticated users"
  ON competition_distances FOR SELECT
  TO authenticated
  USING (true);

-- ============================================================================
-- 4. COMPETITION_SPONSORS - Leitura pública, escrita apenas admin
-- ============================================================================
ALTER TABLE competition_sponsors ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Competition sponsors are viewable by authenticated users"
  ON competition_sponsors FOR SELECT
  TO authenticated
  USING (true);

-- ============================================================================
-- 5. COMPETITION_DOCUMENTS - Leitura pública, escrita apenas admin
-- ============================================================================
ALTER TABLE competition_documents ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Competition documents are viewable by authenticated users"
  ON competition_documents FOR SELECT
  TO authenticated
  USING (true);

-- ============================================================================
-- 6. COMPETITION_LOTS - Leitura pública, escrita apenas admin
-- ============================================================================
ALTER TABLE competition_lots ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Competition lots are viewable by authenticated users"
  ON competition_lots FOR SELECT
  TO authenticated
  USING (true);

-- ============================================================================
-- 7. COMPETITION_REGISTRATIONS - Usuário acessa apenas próprias inscrições
-- ============================================================================
ALTER TABLE competition_registrations ENABLE ROW LEVEL SECURITY;

-- Policy: SELECT - usuário vê apenas as próprias inscrições
CREATE POLICY "Users can view own registrations"
  ON competition_registrations FOR SELECT
  USING (auth.uid() = user_id);

-- Policy: INSERT - usuário cria apenas suas próprias inscrições
CREATE POLICY "Users can insert own registrations"
  ON competition_registrations FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Policy: UPDATE - usuário atualiza apenas as próprias inscrições
CREATE POLICY "Users can update own registrations"
  ON competition_registrations FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- 8. USER_RUNS - Usuário acessa apenas próprias corridas
-- ============================================================================
ALTER TABLE user_runs ENABLE ROW LEVEL SECURITY;

-- Policy: SELECT - usuário vê apenas as próprias corridas
CREATE POLICY "Users can view own runs"
  ON user_runs FOR SELECT
  USING (auth.uid() = user_id);

-- Policy: INSERT - usuário cria apenas suas próprias corridas
CREATE POLICY "Users can insert own runs"
  ON user_runs FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Policy: UPDATE - usuário atualiza apenas as próprias corridas
CREATE POLICY "Users can update own runs"
  ON user_runs FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- 9. USER_RUN_EVENTS - Usuário acessa apenas próprios eventos
-- ============================================================================
ALTER TABLE user_run_events ENABLE ROW LEVEL SECURITY;

-- Policy: SELECT - usuário vê apenas os próprios eventos
CREATE POLICY "Users can view own run events"
  ON user_run_events FOR SELECT
  USING (auth.uid() = user_id);

-- Policy: INSERT - usuário cria apenas seus próprios eventos
CREATE POLICY "Users can insert own run events"
  ON user_run_events FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Policy: UPDATE - usuário atualiza apenas os próprios eventos
CREATE POLICY "Users can update own run events"
  ON user_run_events FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- COMENTÁRIOS
-- ============================================================================
COMMENT ON POLICY "Users can view own profile" ON profiles IS 'Permite que usuários vejam apenas o próprio perfil';
COMMENT ON POLICY "Competitions are viewable by authenticated users" ON competitions IS 'Permite leitura pública de competições para usuários autenticados';
COMMENT ON POLICY "Users can view own registrations" ON competition_registrations IS 'Permite que usuários vejam apenas as próprias inscrições';
COMMENT ON POLICY "Users can view own runs" ON user_runs IS 'Permite que usuários vejam apenas as próprias corridas';
COMMENT ON POLICY "Users can view own run events" ON user_run_events IS 'Permite que usuários vejam apenas os próprios eventos de corrida';
