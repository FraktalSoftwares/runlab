-- Migration: Schema inicial do módulo Competições
-- Cria todas as tabelas, constraints, indexes e triggers necessários

-- ============================================================================
-- 1. PROFILES
-- ============================================================================
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name text,
  avatar_url text,
  created_at timestamptz DEFAULT now() NOT NULL,
  updated_at timestamptz DEFAULT now() NOT NULL
);

-- Trigger para updated_at em profiles
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- 2. COMPETITIONS
-- ============================================================================
CREATE TABLE IF NOT EXISTS competitions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  subtitle text,
  location_name text,
  starts_at timestamptz NOT NULL,
  registration_starts_at timestamptz,
  registration_ends_at timestamptz,
  mode text NOT NULL CHECK (mode IN ('indoor', 'outdoor')),
  status text NOT NULL CHECK (status IN ('draft', 'open', 'closed', 'in_progress', 'finished')),
  is_free boolean DEFAULT false NOT NULL,
  cover_image_url text,
  description text,
  prize_description text,
  created_at timestamptz DEFAULT now() NOT NULL,
  updated_at timestamptz DEFAULT now() NOT NULL
);

-- Trigger para updated_at em competitions
CREATE TRIGGER update_competitions_updated_at
  BEFORE UPDATE ON competitions
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Indexes para competitions
CREATE INDEX IF NOT EXISTS idx_competitions_starts_at ON competitions(starts_at);
CREATE INDEX IF NOT EXISTS idx_competitions_status ON competitions(status);

-- ============================================================================
-- 3. COMPETITION_DISTANCES
-- ============================================================================
CREATE TABLE IF NOT EXISTS competition_distances (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  competition_id uuid NOT NULL REFERENCES competitions(id) ON DELETE CASCADE,
  label text NOT NULL,
  meters int NOT NULL CHECK (meters > 0),
  sort_order int DEFAULT 0 NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_competition_distances_competition_id ON competition_distances(competition_id);

-- ============================================================================
-- 4. COMPETITION_SPONSORS
-- ============================================================================
CREATE TABLE IF NOT EXISTS competition_sponsors (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  competition_id uuid NOT NULL REFERENCES competitions(id) ON DELETE CASCADE,
  name text NOT NULL,
  logo_url text,
  sort_order int DEFAULT 0 NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_competition_sponsors_competition_id ON competition_sponsors(competition_id);

-- ============================================================================
-- 5. COMPETITION_DOCUMENTS
-- ============================================================================
CREATE TABLE IF NOT EXISTS competition_documents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  competition_id uuid NOT NULL REFERENCES competitions(id) ON DELETE CASCADE,
  title text NOT NULL,
  file_url text NOT NULL,
  sort_order int DEFAULT 0 NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_competition_documents_competition_id ON competition_documents(competition_id);

-- ============================================================================
-- 6. COMPETITION_LOTS
-- ============================================================================
CREATE TABLE IF NOT EXISTS competition_lots (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  competition_id uuid NOT NULL REFERENCES competitions(id) ON DELETE CASCADE,
  name text NOT NULL,
  description text,
  price_cents int NOT NULL CHECK (price_cents >= 0),
  currency text DEFAULT 'BRL' NOT NULL,
  starts_at timestamptz,
  ends_at timestamptz,
  is_subscription_allowed boolean DEFAULT false NOT NULL,
  is_active boolean DEFAULT true NOT NULL,
  sort_order int DEFAULT 0 NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_competition_lots_competition_id ON competition_lots(competition_id);
CREATE INDEX IF NOT EXISTS idx_competition_lots_is_active ON competition_lots(is_active);

-- ============================================================================
-- 7. COMPETITION_REGISTRATIONS
-- ============================================================================
CREATE TABLE IF NOT EXISTS competition_registrations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  competition_id uuid NOT NULL REFERENCES competitions(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  distance_id uuid REFERENCES competition_distances(id),
  lot_id uuid REFERENCES competition_lots(id),
  status text NOT NULL CHECK (status IN ('pending', 'confirmed', 'cancelled')),
  accepted_terms boolean DEFAULT false NOT NULL,
  created_at timestamptz DEFAULT now() NOT NULL,
  UNIQUE (competition_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_competition_registrations_user_id ON competition_registrations(user_id);
CREATE INDEX IF NOT EXISTS idx_competition_registrations_competition_id ON competition_registrations(competition_id);
CREATE INDEX IF NOT EXISTS idx_competition_registrations_status ON competition_registrations(status);

-- ============================================================================
-- 8. USER_RUNS
-- ============================================================================
CREATE TABLE IF NOT EXISTS user_runs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  competition_id uuid NOT NULL REFERENCES competitions(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  registration_id uuid REFERENCES competition_registrations(id) ON DELETE SET NULL,
  state text NOT NULL DEFAULT 'ready' CHECK (state IN ('ready', 'running', 'paused', 'finished', 'aborted')),
  started_at timestamptz,
  finished_at timestamptz,
  total_time_seconds int DEFAULT 0 NOT NULL CHECK (total_time_seconds >= 0),
  distance_meters int DEFAULT 0 NOT NULL CHECK (distance_meters >= 0),
  avg_pace_seconds_per_km int,
  created_at timestamptz DEFAULT now() NOT NULL,
  updated_at timestamptz DEFAULT now() NOT NULL
);

-- Trigger para updated_at em user_runs
CREATE TRIGGER update_user_runs_updated_at
  BEFORE UPDATE ON user_runs
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Indexes para user_runs
CREATE INDEX IF NOT EXISTS idx_user_runs_competition_id ON user_runs(competition_id);
CREATE INDEX IF NOT EXISTS idx_user_runs_user_id ON user_runs(user_id);
CREATE INDEX IF NOT EXISTS idx_user_runs_state ON user_runs(state);
CREATE INDEX IF NOT EXISTS idx_user_runs_registration_id ON user_runs(registration_id);

-- ============================================================================
-- 9. USER_RUN_EVENTS
-- ============================================================================
CREATE TABLE IF NOT EXISTS user_run_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  run_id uuid NOT NULL REFERENCES user_runs(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  type text NOT NULL CHECK (type IN ('start', 'pause', 'resume', 'finish', 'metric')),
  happened_at timestamptz DEFAULT now() NOT NULL,
  payload jsonb DEFAULT '{}'::jsonb NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_user_run_events_run_id ON user_run_events(run_id);
CREATE INDEX IF NOT EXISTS idx_user_run_events_user_id ON user_run_events(user_id);
CREATE INDEX IF NOT EXISTS idx_user_run_events_happened_at ON user_run_events(happened_at);
CREATE INDEX IF NOT EXISTS idx_user_run_events_type ON user_run_events(type);

-- ============================================================================
-- COMENTÁRIOS PARA DOCUMENTAÇÃO
-- ============================================================================
COMMENT ON TABLE profiles IS 'Perfis de usuários vinculados a auth.users';
COMMENT ON TABLE competitions IS 'Competições/corridas disponíveis';
COMMENT ON TABLE competition_distances IS 'Distâncias disponíveis para cada competição';
COMMENT ON TABLE competition_sponsors IS 'Patrocinadores de cada competição';
COMMENT ON TABLE competition_documents IS 'Documentos (PDFs, URLs) de cada competição';
COMMENT ON TABLE competition_lots IS 'Lotes de inscrição com preços e períodos';
COMMENT ON TABLE competition_registrations IS 'Inscrições dos usuários em competições';
COMMENT ON TABLE user_runs IS 'Sessões de corrida dos usuários';
COMMENT ON TABLE user_run_events IS 'Eventos de estado das corridas (start, pause, resume, finish, metric)';
