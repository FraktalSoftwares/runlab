-- Migration: Corrigir função get_competition_details
-- Problema: ORDER BY dentro de jsonb_agg causava erro de GROUP BY
-- Solução: Usar subquery ordenada e depois aplicar jsonb_agg

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
