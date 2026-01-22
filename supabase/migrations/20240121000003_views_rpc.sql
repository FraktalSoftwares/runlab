-- Migration: Views e RPCs para simplificar queries no client
-- Cria views agregadas e funções auxiliares

-- ============================================================================
-- VIEW: v_competitions_with_meta
-- Agrega informações úteis sobre competições (contagem de inscritos, etc.)
-- ============================================================================
CREATE OR REPLACE VIEW v_competitions_with_meta AS
SELECT 
  c.*,
  COUNT(DISTINCT r.id) as registration_count,
  COUNT(DISTINCT CASE WHEN r.status = 'confirmed' THEN r.id END) as confirmed_registrations_count
FROM competitions c
LEFT JOIN competition_registrations r ON r.competition_id = c.id
GROUP BY c.id;

COMMENT ON VIEW v_competitions_with_meta IS 'View agregada com metadados das competições (contagem de inscrições)';

-- ============================================================================
-- VIEW: v_competition_leaderboard
-- Ranking de corridas finalizadas por competição
-- ============================================================================
CREATE OR REPLACE VIEW v_competition_leaderboard AS
SELECT 
  r.competition_id,
  r.id as run_id,
  r.user_id,
  r.distance_meters,
  r.total_time_seconds,
  r.avg_pace_seconds_per_km,
  r.finished_at,
  ROW_NUMBER() OVER (
    PARTITION BY r.competition_id, r.distance_meters 
    ORDER BY r.total_time_seconds ASC NULLS LAST
  ) as rank,
  -- Informações do perfil (se disponível)
  p.full_name as user_name,
  p.avatar_url as user_avatar_url
FROM user_runs r
LEFT JOIN profiles p ON p.id = r.user_id
WHERE r.state = 'finished'
  AND r.total_time_seconds > 0
  AND r.distance_meters > 0;

COMMENT ON VIEW v_competition_leaderboard IS 'Ranking de corridas finalizadas, ordenado por tempo (menor primeiro)';

-- ============================================================================
-- RPC: is_user_registered
-- Verifica se um usuário está inscrito em uma competição
-- ============================================================================
CREATE OR REPLACE FUNCTION is_user_registered(
  p_competition_id uuid,
  p_user_id uuid DEFAULT auth.uid()
)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_count int;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM competition_registrations
  WHERE competition_id = p_competition_id
    AND user_id = p_user_id
    AND status IN ('pending', 'confirmed');
  
  RETURN v_count > 0;
END;
$$;

COMMENT ON FUNCTION is_user_registered IS 'Verifica se o usuário autenticado (ou especificado) está inscrito na competição';

-- ============================================================================
-- RPC: get_user_competition_registration
-- Retorna a inscrição do usuário em uma competição (se existir)
-- ============================================================================
CREATE OR REPLACE FUNCTION get_user_competition_registration(
  p_competition_id uuid,
  p_user_id uuid DEFAULT auth.uid()
)
RETURNS TABLE (
  id uuid,
  competition_id uuid,
  user_id uuid,
  distance_id uuid,
  lot_id uuid,
  status text,
  accepted_terms boolean,
  created_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    r.id,
    r.competition_id,
    r.user_id,
    r.distance_id,
    r.lot_id,
    r.status,
    r.accepted_terms,
    r.created_at
  FROM competition_registrations r
  WHERE r.competition_id = p_competition_id
    AND r.user_id = p_user_id
  LIMIT 1;
END;
$$;

COMMENT ON FUNCTION get_user_competition_registration IS 'Retorna a inscrição do usuário autenticado (ou especificado) na competição';

-- ============================================================================
-- RPC: get_competition_details
-- Retorna detalhes completos de uma competição com todos os relacionamentos
-- ============================================================================
CREATE OR REPLACE FUNCTION get_competition_details(p_competition_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_result jsonb;
BEGIN
  SELECT jsonb_build_object(
    'competition', row_to_json(c.*),
    'distances', COALESCE((
      SELECT jsonb_agg(row_to_json(d))
      FROM (
        SELECT *
        FROM competition_distances
        WHERE competition_id = c.id
        ORDER BY sort_order
      ) d
    ), '[]'::jsonb),
    'sponsors', COALESCE((
      SELECT jsonb_agg(row_to_json(s))
      FROM (
        SELECT *
        FROM competition_sponsors
        WHERE competition_id = c.id
        ORDER BY sort_order
      ) s
    ), '[]'::jsonb),
    'documents', COALESCE((
      SELECT jsonb_agg(row_to_json(doc))
      FROM (
        SELECT *
        FROM competition_documents
        WHERE competition_id = c.id
        ORDER BY sort_order
      ) doc
    ), '[]'::jsonb),
    'lots', COALESCE((
      SELECT jsonb_agg(row_to_json(l))
      FROM (
        SELECT *
        FROM competition_lots
        WHERE competition_id = c.id
          AND is_active = true
        ORDER BY sort_order
      ) l
    ), '[]'::jsonb),
    'registration_count', (
      SELECT COUNT(*)
      FROM competition_registrations r
      WHERE r.competition_id = c.id
        AND r.status = 'confirmed'
    ),
    'user_is_registered', is_user_registered(c.id, auth.uid())
  )
  INTO v_result
  FROM competitions c
  WHERE c.id = p_competition_id;
  
  RETURN v_result;
END;
$$;

COMMENT ON FUNCTION get_competition_details IS 'Retorna detalhes completos de uma competição com todos os relacionamentos em formato JSON';
