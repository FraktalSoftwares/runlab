-- Migration: Seeds para desenvolvimento
-- Insere dados mínimos para desenvolvimento e testes
-- ⚠️ APENAS PARA DESENVOLVIMENTO - NÃO USAR EM PRODUÇÃO

-- ============================================================================
-- COMPETIÇÃO 1: OPEN (Inscrições Abertas)
-- ============================================================================
INSERT INTO competitions (
  id, title, subtitle, location_name, starts_at, registration_starts_at, registration_ends_at,
  mode, status, is_free, cover_image_url, description, prize_description
) VALUES (
  '00000000-0000-0000-0000-000000000001',
  'Corrida da Mantiqueira',
  'Serra da Mantiqueira',
  'Campos do Jordão, SP',
  NOW() + INTERVAL '30 days',
  NOW() - INTERVAL '5 days',
  NOW() + INTERVAL '20 days',
  'outdoor',
  'open',
  false,
  'https://images.unsplash.com/photo-1571008887538-b36bb32f4571?w=800',
  'Corrida de montanha pela bela Serra da Mantiqueira. Percurso desafiador com paisagens incríveis.',
  'Medalha para todos os participantes. Troféus para os 3 primeiros colocados de cada categoria.'
) ON CONFLICT (id) DO NOTHING;

-- Distâncias
INSERT INTO competition_distances (competition_id, label, meters, sort_order) VALUES
  ('00000000-0000-0000-0000-000000000001', '5km', 5000, 1),
  ('00000000-0000-0000-0000-000000000001', '10km', 10000, 2),
  ('00000000-0000-0000-0000-000000000001', '21km', 21000, 3)
ON CONFLICT DO NOTHING;

-- Patrocinadores
INSERT INTO competition_sponsors (competition_id, name, logo_url, sort_order) VALUES
  ('00000000-0000-0000-0000-000000000001', 'Nike', 'https://logos-world.net/wp-content/uploads/2020/04/Nike-Logo.png', 1),
  ('00000000-0000-0000-0000-000000000001', 'Gatorade', 'https://logos-world.net/wp-content/uploads/2020/11/Gatorade-Logo.png', 2),
  ('00000000-0000-0000-0000-000000000001', 'Adidas', 'https://logos-world.net/wp-content/uploads/2020/04/Adidas-Logo.png', 3)
ON CONFLICT DO NOTHING;

-- Documentos
INSERT INTO competition_documents (competition_id, title, file_url, sort_order) VALUES
  ('00000000-0000-0000-0000-000000000001', 'Edital Completo', 'https://example.com/edital-mantiqueira.pdf', 1),
  ('00000000-0000-0000-0000-000000000001', 'Regulamento', 'https://example.com/regulamento-mantiqueira.pdf', 2)
ON CONFLICT DO NOTHING;

-- Lotes
INSERT INTO competition_lots (
  competition_id, name, description, price_cents, currency, starts_at, ends_at,
  is_subscription_allowed, is_active, sort_order
) VALUES
  (
    '00000000-0000-0000-0000-000000000001',
    'Lote 1 — Medalha Garantida',
    'Primeiro lote com desconto especial',
    12000,
    'BRL',
    NOW() - INTERVAL '5 days',
    NOW() + INTERVAL '10 days',
    true,
    true,
    1
  ),
  (
    '00000000-0000-0000-0000-000000000001',
    'Lote 2 — Regular',
    'Lote regular de inscrições',
    15000,
    'BRL',
    NOW() + INTERVAL '10 days',
    NOW() + INTERVAL '20 days',
    true,
    true,
    2
  ),
  (
    '00000000-0000-0000-0000-000000000001',
    'Lote 3 — Última Chance',
    'Último lote antes do evento',
    18000,
    'BRL',
    NOW() + INTERVAL '20 days',
    NOW() + INTERVAL '25 days',
    false,
    true,
    3
  )
ON CONFLICT DO NOTHING;

-- ============================================================================
-- COMPETIÇÃO 2: CLOSED (Inscrições Fechadas)
-- ============================================================================
INSERT INTO competitions (
  id, title, subtitle, location_name, starts_at, registration_starts_at, registration_ends_at,
  mode, status, is_free, cover_image_url, description, prize_description
) VALUES (
  '00000000-0000-0000-0000-000000000002',
  'Maratona de São Paulo',
  'Centro Histórico',
  'São Paulo, SP',
  NOW() + INTERVAL '15 days',
  NOW() - INTERVAL '30 days',
  NOW() - INTERVAL '5 days',
  'outdoor',
  'closed',
  false,
  'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=800',
  'Maratona pelo centro histórico de São Paulo. Percurso urbano com pontos turísticos.',
  'Medalha exclusiva e kit do corredor premium.'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO competition_distances (competition_id, label, meters, sort_order) VALUES
  ('00000000-0000-0000-0000-000000000002', '10km', 10000, 1),
  ('00000000-0000-0000-0000-000000000002', '21km', 21000, 2),
  ('00000000-0000-0000-0000-000000000002', '42km', 42195, 3)
ON CONFLICT DO NOTHING;

INSERT INTO competition_sponsors (competition_id, name, logo_url, sort_order) VALUES
  ('00000000-0000-0000-0000-000000000002', 'Asics', 'https://logos-world.net/wp-content/uploads/2020/04/Asics-Logo.png', 1),
  ('00000000-0000-0000-0000-000000000002', 'Powerade', 'https://logos-world.net/wp-content/uploads/2020/11/Powerade-Logo.png', 2)
ON CONFLICT DO NOTHING;

INSERT INTO competition_documents (competition_id, title, file_url, sort_order) VALUES
  ('00000000-0000-0000-0000-000000000002', 'Edital', 'https://example.com/edital-sp.pdf', 1)
ON CONFLICT DO NOTHING;

INSERT INTO competition_lots (
  competition_id, name, description, price_cents, currency, starts_at, ends_at,
  is_subscription_allowed, is_active, sort_order
) VALUES
  (
    '00000000-0000-0000-0000-000000000002',
    'Lote Único',
    'Lote único de inscrições',
    20000,
    'BRL',
    NOW() - INTERVAL '30 days',
    NOW() - INTERVAL '5 days',
    false,
    false,
    1
  )
ON CONFLICT DO NOTHING;

-- ============================================================================
-- COMPETIÇÃO 3: IN_PROGRESS (Corrida em Andamento)
-- ============================================================================
INSERT INTO competitions (
  id, title, subtitle, location_name, starts_at, registration_starts_at, registration_ends_at,
  mode, status, is_free, cover_image_url, description, prize_description
) VALUES (
  '00000000-0000-0000-0000-000000000003',
  'Corrida Noturna do Ibirapuera',
  'Parque Ibirapuera',
  'São Paulo, SP',
  NOW() - INTERVAL '1 hour',
  NOW() - INTERVAL '60 days',
  NOW() - INTERVAL '1 day',
  'outdoor',
  'in_progress',
  true,
  'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=800',
  'Corrida noturna gratuita no Parque Ibirapuera. Venha correr conosco!',
  'Medalha para todos os participantes.'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO competition_distances (competition_id, label, meters, sort_order) VALUES
  ('00000000-0000-0000-0000-000000000003', '5km', 5000, 1),
  ('00000000-0000-0000-0000-000000000003', '10km', 10000, 2)
ON CONFLICT DO NOTHING;

INSERT INTO competition_sponsors (competition_id, name, logo_url, sort_order) VALUES
  ('00000000-0000-0000-0000-000000000003', 'Puma', 'https://logos-world.net/wp-content/uploads/2020/04/Puma-Logo.png', 1)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- COMPETIÇÃO 4: FINISHED (Finalizada)
-- ============================================================================
INSERT INTO competitions (
  id, title, subtitle, location_name, starts_at, registration_starts_at, registration_ends_at,
  mode, status, is_free, cover_image_url, description, prize_description
) VALUES (
  '00000000-0000-0000-0000-000000000004',
  'Corrida Indoor do Shopping',
  'Esteira Eletrônica',
  'São Paulo, SP',
  NOW() - INTERVAL '7 days',
  NOW() - INTERVAL '90 days',
  NOW() - INTERVAL '10 days',
  'indoor',
  'finished',
  false,
  'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
  'Corrida indoor em esteiras eletrônicas. Perfeita para quem prefere ambiente climatizado.',
  'Medalha e certificado digital para todos os participantes.'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO competition_distances (competition_id, label, meters, sort_order) VALUES
  ('00000000-0000-0000-0000-000000000004', '5km', 5000, 1),
  ('00000000-0000-0000-0000-000000000004', '10km', 10000, 2),
  ('00000000-0000-0000-0000-000000000004', '21km', 21000, 3)
ON CONFLICT DO NOTHING;

INSERT INTO competition_sponsors (competition_id, name, logo_url, sort_order) VALUES
  ('00000000-0000-0000-0000-000000000004', 'New Balance', 'https://logos-world.net/wp-content/uploads/2020/04/New-Balance-Logo.png', 1),
  ('00000000-0000-0000-0000-000000000004', 'Under Armour', 'https://logos-world.net/wp-content/uploads/2020/04/Under-Armour-Logo.png', 2)
ON CONFLICT DO NOTHING;

INSERT INTO competition_documents (competition_id, title, file_url, sort_order) VALUES
  ('00000000-0000-0000-0000-000000000004', 'Resultados', 'https://example.com/resultados-indoor.pdf', 1)
ON CONFLICT DO NOTHING;

INSERT INTO competition_lots (
  competition_id, name, description, price_cents, currency, starts_at, ends_at,
  is_subscription_allowed, is_active, sort_order
) VALUES
  (
    '00000000-0000-0000-0000-000000000004',
    'Lote Promocional',
    'Lote com desconto',
    8000,
    'BRL',
    NOW() - INTERVAL '90 days',
    NOW() - INTERVAL '30 days',
    true,
    false,
    1
  ),
  (
    '00000000-0000-0000-0000-000000000004',
    'Lote Regular',
    'Lote regular',
    10000,
    'BRL',
    NOW() - INTERVAL '30 days',
    NOW() - INTERVAL '10 days',
    true,
    false,
    2
  )
ON CONFLICT DO NOTHING;
