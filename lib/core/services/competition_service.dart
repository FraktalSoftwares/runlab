import '../config/supabase_config.dart';
import '../models/competition.dart';

/// Service para operações relacionadas a competições
class CompetitionService {
  final _client = SupabaseConfig.client;

  /// Lista todas as competições, opcionalmente filtradas por status
  Future<List<Competition>> listCompetitions({
    CompetitionStatus? status,
    CompetitionMode? mode,
    int? limit,
  }) async {
    try {
      var query = _client.from('competitions').select();

      if (status != null) {
        query = query.eq('status', status.value);
      }

      if (mode != null) {
        query = query.eq('mode', mode.value);
      }

      var orderedQuery = query.order('starts_at', ascending: true);

      final response = limit != null
          ? await orderedQuery.limit(limit)
          : await orderedQuery;

      return (response as List<dynamic>)
          .map((json) => Competition.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao listar competições: $e');
    }
  }

  /// Busca uma competição por ID
  Future<Competition?> getCompetitionById(String id) async {
    try {
      final response = await _client
          .from('competitions')
          .select()
          .eq('id', id)
          .single();

      return Competition.fromJson(Map<String, dynamic>.from(response));
    } catch (e) {
      if (e.toString().contains('PGRST116')) {
        // Registro não encontrado
        return null;
      }
      throw Exception('Erro ao buscar competição: $e');
    }
  }

  /// Busca detalhes completos de uma competição (usando RPC)
  Future<Map<String, dynamic>?> getCompetitionDetails(String id) async {
    try {
      final response = await _client.rpc('get_competition_details', params: {
        'p_competition_id': id,
      });

      return response as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Erro ao buscar detalhes da competição: $e');
    }
  }

  /// Lista distâncias de uma competição
  Future<List<CompetitionDistance>> getCompetitionDistances(
    String competitionId,
  ) async {
    try {
      final response = await _client
          .from('competition_distances')
          .select()
          .eq('competition_id', competitionId)
          .order('sort_order', ascending: true);

      return (response as List)
          .map((json) =>
              CompetitionDistance.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar distâncias: $e');
    }
  }

  /// Lista lotes de uma competição
  Future<List<CompetitionLot>> getCompetitionLots(
    String competitionId, {
    bool? onlyActive,
  }) async {
    try {
      var query = _client
          .from('competition_lots')
          .select()
          .eq('competition_id', competitionId);

      if (onlyActive == true) {
        query = query.eq('is_active', true);
      }

      final response = await query.order('sort_order', ascending: true);

      return (response as List)
          .map((json) => CompetitionLot.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar lotes: $e');
    }
  }

  /// Lista patrocinadores de uma competição
  Future<List<CompetitionSponsor>> getCompetitionSponsors(
    String competitionId,
  ) async {
    try {
      final response = await _client
          .from('competition_sponsors')
          .select()
          .eq('competition_id', competitionId)
          .order('sort_order', ascending: true);

      return (response as List)
          .map((json) =>
              CompetitionSponsor.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar patrocinadores: $e');
    }
  }

  /// Lista documentos de uma competição
  Future<List<CompetitionDocument>> getCompetitionDocuments(
    String competitionId,
  ) async {
    try {
      final response = await _client
          .from('competition_documents')
          .select()
          .eq('competition_id', competitionId)
          .order('sort_order', ascending: true);

      return (response as List)
          .map((json) =>
              CompetitionDocument.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar documentos: $e');
    }
  }

  /// Verifica se o usuário está inscrito na competição
  Future<bool> isUserRegistered(String competitionId) async {
    try {
      final response = await _client.rpc('is_user_registered', params: {
        'p_competition_id': competitionId,
      });

      return response as bool? ?? false;
    } catch (e) {
      throw Exception('Erro ao verificar inscrição: $e');
    }
  }

  /// Busca a inscrição do usuário na competição
  Future<CompetitionRegistration?> getUserRegistration(
    String competitionId,
  ) async {
    try {
      final response = await _client.rpc(
        'get_user_competition_registration',
        params: {
          'p_competition_id': competitionId,
        },
      );

      if (response == null || (response as List).isEmpty) {
        return null;
      }

      final registrationData = (response).first;
      return CompetitionRegistration.fromJson(
        Map<String, dynamic>.from(registrationData),
      );
    } catch (e) {
      throw Exception('Erro ao buscar inscrição: $e');
    }
  }

  /// Cria uma nova inscrição
  Future<CompetitionRegistration> createRegistration({
    required String competitionId,
    required String distanceId,
    required String lotId,
    required bool acceptedTerms,
  }) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _client
          .from('competition_registrations')
          .insert({
            'competition_id': competitionId,
            'user_id': user.id,
            'distance_id': distanceId,
            'lot_id': lotId,
            'status': 'pending',
            'accepted_terms': acceptedTerms,
          })
          .select()
          .single();

      return CompetitionRegistration.fromJson(
        Map<String, dynamic>.from(response),
      );
    } catch (e) {
      if (e.toString().contains('duplicate key')) {
        throw Exception('Você já está inscrito nesta competição');
      }
      throw Exception('Erro ao criar inscrição: $e');
    }
  }

  /// Atualiza o status de uma inscrição
  Future<void> updateRegistrationStatus(
    String registrationId,
    RegistrationStatus status,
  ) async {
    try {
      await _client
          .from('competition_registrations')
          .update({'status': status.value})
          .eq('id', registrationId);
    } catch (e) {
      throw Exception('Erro ao atualizar inscrição: $e');
    }
  }

  /// Cancela uma inscrição
  Future<void> cancelRegistration(String registrationId) async {
    await updateRegistrationStatus(registrationId, RegistrationStatus.cancelled);
  }
}
