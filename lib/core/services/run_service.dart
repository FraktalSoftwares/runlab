import '../config/supabase_config.dart';
import '../models/run.dart';

/// Service para operações relacionadas a corridas
class RunService {
  final _client = SupabaseConfig.client;

  /// Cria uma nova corrida
  Future<UserRun> createRun({
    required String competitionId,
    String? registrationId,
  }) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _client
          .from('user_runs')
          .insert({
            'competition_id': competitionId,
            'user_id': user.id,
            'registration_id': registrationId,
            'state': 'ready',
          })
          .select()
          .single();

      return UserRun.fromJson(Map<String, dynamic>.from(response));
    } catch (e) {
      throw Exception('Erro ao criar corrida: $e');
    }
  }

  /// Busca uma corrida por ID
  Future<UserRun?> getRunById(String runId) async {
    try {
      final response = await _client
          .from('user_runs')
          .select()
          .eq('id', runId)
          .single();

      return UserRun.fromJson(Map<String, dynamic>.from(response));
    } catch (e) {
      if (e.toString().contains('PGRST116')) {
        return null;
      }
      throw Exception('Erro ao buscar corrida: $e');
    }
  }

  /// Lista corridas do usuário, opcionalmente filtradas por competição
  Future<List<UserRun>> getUserRuns({
    String? competitionId,
    RunState? state,
    int? limit,
  }) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      var query = _client
          .from('user_runs')
          .select()
          .eq('user_id', user.id);

      if (competitionId != null) {
        query = query.eq('competition_id', competitionId);
      }

      if (state != null) {
        query = query.eq('state', state.value);
      }

      var orderedQuery = query.order('created_at', ascending: false);

      final response = limit != null
          ? await orderedQuery.limit(limit)
          : await orderedQuery;

      return (response as List<dynamic>)
          .map((json) => UserRun.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao listar corridas: $e');
    }
  }

  /// Atualiza o estado da corrida
  Future<void> updateRunState(
    String runId,
    RunState state, {
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final updates = <String, dynamic>{
        'state': state.value,
      };

      // Atualizar timestamps baseado no estado
      final now = DateTime.now().toUtc().toIso8601String();
      if (state == RunState.running && metadata?['started_at'] == null) {
        updates['started_at'] = now;
      } else if (state == RunState.finished) {
        updates['finished_at'] = now;
        if (metadata?['total_time_seconds'] != null) {
          updates['total_time_seconds'] = metadata!['total_time_seconds'];
        }
        if (metadata?['distance_meters'] != null) {
          updates['distance_meters'] = metadata!['distance_meters'];
        }
        if (metadata?['avg_pace_seconds_per_km'] != null) {
          updates['avg_pace_seconds_per_km'] = metadata!['avg_pace_seconds_per_km'];
        }
      }

      await _client
          .from('user_runs')
          .update(updates)
          .eq('id', runId);
    } catch (e) {
      throw Exception('Erro ao atualizar estado da corrida: $e');
    }
  }

  /// Adiciona um evento à corrida
  Future<UserRunEvent> addRunEvent(
    String runId,
    RunEventType type, {
    Map<String, dynamic>? payload,
  }) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _client
          .from('user_run_events')
          .insert({
            'run_id': runId,
            'user_id': user.id,
            'type': type.value,
            'payload': payload ?? {},
          })
          .select()
          .single();

      return UserRunEvent.fromJson(Map<String, dynamic>.from(response));
    } catch (e) {
      throw Exception('Erro ao adicionar evento: $e');
    }
  }

  /// Inicia a corrida
  Future<void> startRun(String runId) async {
    await updateRunState(runId, RunState.running);
    await addRunEvent(runId, RunEventType.start);
  }

  /// Pausa a corrida
  Future<void> pauseRun(String runId) async {
    await updateRunState(runId, RunState.paused);
    await addRunEvent(runId, RunEventType.pause);
  }

  /// Retoma a corrida
  Future<void> resumeRun(String runId) async {
    await updateRunState(runId, RunState.running);
    await addRunEvent(runId, RunEventType.resume);
  }

  /// Finaliza a corrida com métricas
  Future<void> finishRun(
    String runId, {
    required int totalTimeSeconds,
    required int distanceMeters,
    int? avgPaceSecondsPerKm,
  }) async {
    await updateRunState(
      runId,
      RunState.finished,
      metadata: {
        'total_time_seconds': totalTimeSeconds,
        'distance_meters': distanceMeters,
        'avg_pace_seconds_per_km': avgPaceSecondsPerKm,
      },
    );
    await addRunEvent(
      runId,
      RunEventType.finish,
      payload: {
        'total_time_seconds': totalTimeSeconds,
        'distance_meters': distanceMeters,
        'avg_pace_seconds_per_km': avgPaceSecondsPerKm,
      },
    );
  }

  /// Aborta a corrida
  Future<void> abortRun(String runId) async {
    await updateRunState(runId, RunState.aborted);
  }

  /// Lista eventos de uma corrida
  Future<List<UserRunEvent>> getRunEvents(String runId) async {
    try {
      final response = await _client
          .from('user_run_events')
          .select()
          .eq('run_id', runId)
          .order('happened_at', ascending: true);

      return (response as List)
          .map((json) => UserRunEvent.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao listar eventos: $e');
    }
  }

  /// Busca o ranking de uma competição
  Future<List<LeaderboardEntry>> getCompetitionLeaderboard(
    String competitionId, {
    int? distanceMeters,
    int? limit,
  }) async {
    try {
      var query = _client
          .from('v_competition_leaderboard')
          .select()
          .eq('competition_id', competitionId);

      if (distanceMeters != null) {
        query = query.eq('distance_meters', distanceMeters);
      }

      var orderedQuery = query.order('rank', ascending: true);

      final response = limit != null
          ? await orderedQuery.limit(limit)
          : await orderedQuery;

      return (response as List)
          .map((json) =>
              LeaderboardEntry.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar ranking: $e');
    }
  }

  /// Adiciona uma métrica durante a corrida (ex: distância parcial, pace atual)
  Future<void> addMetric(
    String runId, {
    required Map<String, dynamic> metricData,
  }) async {
    await addRunEvent(
      runId,
      RunEventType.metric,
      payload: metricData,
    );
  }
}
