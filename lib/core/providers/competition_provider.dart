import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/competition.dart';
import '../services/competition_service.dart';

/// Provider do CompetitionService
final competitionServiceProvider = Provider<CompetitionService>((ref) {
  return CompetitionService();
});

/// Provider para listar competições
final competitionsProvider = FutureProvider.family<List<Competition>, CompetitionListParams>(
  (ref, params) async {
    final service = ref.read(competitionServiceProvider);
    return service.listCompetitions(
      status: params.status,
      mode: params.mode,
      limit: params.limit,
    );
  },
);

/// Parâmetros para listagem de competições
class CompetitionListParams {
  final CompetitionStatus? status;
  final CompetitionMode? mode;
  final int? limit;

  CompetitionListParams({
    this.status,
    this.mode,
    this.limit,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CompetitionListParams &&
        other.status == status &&
        other.mode == mode &&
        other.limit == limit;
  }

  @override
  int get hashCode => Object.hash(status, mode, limit);
}

/// Provider para buscar uma competição por ID
final competitionProvider = FutureProvider.family<Competition?, String>(
  (ref, competitionId) async {
    final service = ref.read(competitionServiceProvider);
    return service.getCompetitionById(competitionId);
  },
);

/// Provider para detalhes completos de uma competição
final competitionDetailsProvider = FutureProvider.family<Map<String, dynamic>?, String>(
  (ref, competitionId) async {
    final service = ref.read(competitionServiceProvider);
    return service.getCompetitionDetails(competitionId);
  },
);

/// Provider para distâncias de uma competição
final competitionDistancesProvider = FutureProvider.family<List<CompetitionDistance>, String>(
  (ref, competitionId) async {
    final service = ref.read(competitionServiceProvider);
    return service.getCompetitionDistances(competitionId);
  },
);

/// Provider para lotes de uma competição
final competitionLotsProvider = FutureProvider.family<List<CompetitionLot>, String>(
  (ref, competitionId) async {
    final service = ref.read(competitionServiceProvider);
    return service.getCompetitionLots(competitionId, onlyActive: true);
  },
);

/// Provider para patrocinadores de uma competição
final competitionSponsorsProvider = FutureProvider.family<List<CompetitionSponsor>, String>(
  (ref, competitionId) async {
    final service = ref.read(competitionServiceProvider);
    return service.getCompetitionSponsors(competitionId);
  },
);

/// Provider para documentos de uma competição
final competitionDocumentsProvider = FutureProvider.family<List<CompetitionDocument>, String>(
  (ref, competitionId) async {
    final service = ref.read(competitionServiceProvider);
    return service.getCompetitionDocuments(competitionId);
  },
);

/// Provider para verificar se usuário está inscrito
final userIsRegisteredProvider = FutureProvider.family<bool, String>(
  (ref, competitionId) async {
    final service = ref.read(competitionServiceProvider);
    return service.isUserRegistered(competitionId);
  },
);

/// Provider para buscar inscrição do usuário
final userRegistrationProvider = FutureProvider.family<CompetitionRegistration?, String>(
  (ref, competitionId) async {
    final service = ref.read(competitionServiceProvider);
    return service.getUserRegistration(competitionId);
  },
);
