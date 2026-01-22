import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/run.dart';
import '../services/run_service.dart';

/// Provider do RunService
final runServiceProvider = Provider<RunService>((ref) {
  return RunService();
});

/// Provider para listar corridas do usuário
final userRunsProvider = FutureProvider.family<List<UserRun>, UserRunsParams>(
  (ref, params) async {
    final service = ref.read(runServiceProvider);
    return service.getUserRuns(
      competitionId: params.competitionId,
      state: params.state,
      limit: params.limit,
    );
  },
);

/// Parâmetros para listagem de corridas
class UserRunsParams {
  final String? competitionId;
  final RunState? state;
  final int? limit;

  UserRunsParams({
    this.competitionId,
    this.state,
    this.limit,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserRunsParams &&
        other.competitionId == competitionId &&
        other.state == state &&
        other.limit == limit;
  }

  @override
  int get hashCode => Object.hash(competitionId, state, limit);
}

/// Provider para buscar uma corrida por ID
final runProvider = FutureProvider.family<UserRun?, String>(
  (ref, runId) async {
    final service = ref.read(runServiceProvider);
    return service.getRunById(runId);
  },
);

/// Provider para eventos de uma corrida
final runEventsProvider = FutureProvider.family<List<UserRunEvent>, String>(
  (ref, runId) async {
    final service = ref.read(runServiceProvider);
    return service.getRunEvents(runId);
  },
);

/// Provider para ranking de uma competição
final competitionLeaderboardProvider = FutureProvider.family<List<LeaderboardEntry>, LeaderboardParams>(
  (ref, params) async {
    final service = ref.read(runServiceProvider);
    return service.getCompetitionLeaderboard(
      params.competitionId,
      distanceMeters: params.distanceMeters,
      limit: params.limit,
    );
  },
);

/// Parâmetros para ranking
class LeaderboardParams {
  final String competitionId;
  final int? distanceMeters;
  final int? limit;

  LeaderboardParams({
    required this.competitionId,
    this.distanceMeters,
    this.limit,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LeaderboardParams &&
        other.competitionId == competitionId &&
        other.distanceMeters == distanceMeters &&
        other.limit == limit;
  }

  @override
  int get hashCode => Object.hash(competitionId, distanceMeters, limit);
}
