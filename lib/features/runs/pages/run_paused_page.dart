import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/run_tracking_provider.dart';
import '../../../core/providers/run_provider.dart';
import '../../../core/providers/competition_provider.dart';
import '../../../core/theme/app_colors.dart';

/// Página de corrida pausada com estatísticas e opções
class RunPausedPage extends ConsumerWidget {
  final String runId;

  const RunPausedPage({
    super.key,
    required this.runId,
  });

  String _formatTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  String _formatDistance(int meters) {
    return '${(meters / 1000).toStringAsFixed(2)}';
  }

  String? _formatPace(int? paceSecondsPerKm) {
    if (paceSecondsPerKm == null) return null;
    final minutes = paceSecondsPerKm ~/ 60;
    final seconds = paceSecondsPerKm % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}km';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackingState = ref.watch(runTrackingProvider(runId));
    final trackingNotifier = ref.read(runTrackingProvider(runId).notifier);
    final runAsync = ref.watch(runProvider(runId));
    final competitionId = runAsync.value?.competitionId;
    final userId = runAsync.value?.userId;

    // Buscar ranking atual do usuário
    int? currentRank;
    String? challengeDistance;

    if (competitionId != null) {
      final leaderboardAsync = ref.watch(
        competitionLeaderboardProvider(
          LeaderboardParams(competitionId: competitionId),
        ),
      );
      leaderboardAsync.whenData((leaderboard) {
        // Encontrar posição do usuário atual
        if (userId != null && leaderboard.isNotEmpty) {
          final userEntry = leaderboard.firstWhere(
            (entry) => entry.userId == userId,
            orElse: () => leaderboard.first,
          );
          currentRank = userEntry.rank;
        }
      });

      final distancesAsync = ref.watch(competitionDistancesProvider(competitionId));
      distancesAsync.whenData((distances) {
        if (distances.isNotEmpty) {
          // Pega a maior distância como desafio
          final maxDistance = distances
              .map((d) => d.meters)
              .reduce((a, b) => a > b ? a : b);
          challengeDistance = '${(maxDistance / 1000).toStringAsFixed(0)}km';
        }
      });
    }

    // Usar valores padrão se ainda não carregados
    final displayRank = currentRank ?? 0;
    final displayChallenge = challengeDistance ?? '--km';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              
              // Mapa placeholder
              Container(
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.neutral800,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'Mapa',
                    style: TextStyle(
                      color: AppColors.neutral400,
                      fontSize: 16,
                      fontFamily: 'FranklinGothic URW',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Métricas
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Primeira linha: Km percorridos, Tempo total, Pace
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatDistance(trackingState.distanceMeters),
                                style: const TextStyle(
                                  color: Color(0xFFCCF725), // Brand-lime-lime-500
                                  fontSize: 32,
                                  fontFamily: 'FranklinGothic URW',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                'Km percorridos',
                                style: TextStyle(
                                  color: AppColors.neutral400,
                                  fontSize: 14,
                                  fontFamily: 'FranklinGothic URW',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _formatTime(trackingState.elapsedSeconds),
                                style: const TextStyle(
                                  color: Color(0xFFCCF725), // Brand-lime-lime-500
                                  fontSize: 32,
                                  fontFamily: 'FranklinGothic URW',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                'Tempo total',
                                style: TextStyle(
                                  color: AppColors.neutral400,
                                  fontSize: 14,
                                  fontFamily: 'FranklinGothic URW',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _formatPace(trackingState.currentPaceSecondsPerKm) ?? '--:--km',
                                style: const TextStyle(
                                  color: Color(0xFFCCF725), // Brand-lime-lime-500
                                  fontSize: 32,
                                  fontFamily: 'FranklinGothic URW',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                'Pace',
                                style: TextStyle(
                                  color: AppColors.neutral400,
                                  fontSize: 14,
                                  fontFamily: 'FranklinGothic URW',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Segunda linha: Desafio, Colocação atual
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayChallenge,
                                style: const TextStyle(
                                  color: Color(0xFFCCF725), // Brand-lime-lime-500
                                  fontSize: 32,
                                  fontFamily: 'FranklinGothic URW',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                'Desafio',
                                style: TextStyle(
                                  color: AppColors.neutral400,
                                  fontSize: 14,
                                  fontFamily: 'FranklinGothic URW',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                displayRank > 0 ? '$displayRankº lugar' : '--',
                                style: const TextStyle(
                                  color: Color(0xFFCCF725), // Brand-lime-lime-500
                                  fontSize: 32,
                                  fontFamily: 'FranklinGothic URW',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                'Colocação atual',
                                style: TextStyle(
                                  color: AppColors.neutral400,
                                  fontSize: 14,
                                  fontFamily: 'FranklinGothic URW',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Botões de controle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botão Stop (cinza)
                    GestureDetector(
                      onTap: () async {
                        await trackingNotifier.finishRun();
                        if (context.mounted && competitionId != null) {
                          context.pushReplacement('/competitions/$competitionId/ranking');
                        }
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const ShapeDecoration(
                          color: AppColors.neutral700,
                          shape: CircleBorder(),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.stop,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Botão Play (verde - retomar)
                    GestureDetector(
                      onTap: () async {
                        await trackingNotifier.resumeRun();
                        if (context.mounted) {
                          context.pushReplacement('/runs/$runId/active');
                        }
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const ShapeDecoration(
                          color: Color(0xFFCCF725), // Brand-lime-lime-500
                          shape: CircleBorder(),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Indicadores de página
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Botão "Ver resultado da corrida"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () async {
                    await trackingNotifier.finishRun();
                    if (context.mounted && competitionId != null) {
                      context.pushReplacement('/competitions/$competitionId/ranking');
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFCCF725), // Brand-lime-lime-500
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Ver resultado da corrida',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'FranklinGothic URW',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Link "Preciso de ajuda"
              TextButton(
                onPressed: () {
                  // TODO: Implementar ajuda
                },
                child: const Text(
                  'Preciso de ajuda',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'FranklinGothic URW',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
