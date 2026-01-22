import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/run_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/models/auth_state.dart' as app_auth;
import '../../../core/theme/app_colors.dart';

/// Página de ranking da competição
class CompetitionRankingPage extends ConsumerWidget {
  final String competitionId;

  const CompetitionRankingPage({
    super.key,
    required this.competitionId,
  });

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String? _formatPace(int? paceSecondsPerKm) {
    if (paceSecondsPerKm == null) return null;
    final minutes = paceSecondsPerKm ~/ 60;
    final seconds = paceSecondsPerKm % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}/km';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(
      competitionLeaderboardProvider(
        LeaderboardParams(competitionId: competitionId),
      ),
    );
    final authState = ref.watch(authNotifierProvider);
    final currentUserId = authState is app_auth.AuthAuthenticated
        ? authState.user.id
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.neutral200,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Ranking',
          style: TextStyle(
            color: AppColors.neutral100,
            fontSize: 14,
            fontFamily: 'FranklinGothic URW',
            fontWeight: FontWeight.w500,
            height: 1.50,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share,
              color: AppColors.neutral200,
            ),
            onPressed: () {
              // TODO: Implementar compartilhamento
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: leaderboardAsync.when(
        data: (leaderboard) {
          if (leaderboard.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum resultado ainda',
                style: TextStyle(
                  color: AppColors.neutral400,
                  fontSize: 16,
                ),
              ),
            );
          }

          return Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ranking da competição',
                      style: TextStyle(
                        color: AppColors.neutral100,
                        fontSize: 20,
                        fontFamily: 'FranklinGothic URW',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Implementar "Ver tudo"
                      },
                      child: const Text(
                        'Ver tudo',
                        style: TextStyle(
                          color: Color(0xFFCCF725), // Brand-lime-lime-500
                          fontSize: 14,
                          fontFamily: 'FranklinGothic URW',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Cabeçalho da tabela
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text(
                        'Posição',
                        style: const TextStyle(
                          color: AppColors.neutral400,
                          fontSize: 12,
                          fontFamily: 'FranklinGothic URW',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Corredor',
                        style: const TextStyle(
                          color: AppColors.neutral400,
                          fontSize: 12,
                          fontFamily: 'FranklinGothic URW',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text(
                        'Pace',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: AppColors.neutral400,
                          fontSize: 12,
                          fontFamily: 'FranklinGothic URW',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text(
                        'Tempo total',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: AppColors.neutral400,
                          fontSize: 12,
                          fontFamily: 'FranklinGothic URW',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Lista de participantes
              Expanded(
                child: ListView.builder(
                  itemCount: leaderboard.length,
                  itemBuilder: (context, index) {
                    final entry = leaderboard[index];
                    final isCurrentUser = entry.userId == currentUserId;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrentUser
                            ? const Color(0xFFCCF725) // Brand-lime-lime-500
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          // Posição
                          SizedBox(
                            width: 60,
                            child: Text(
                              '${entry.rank}º',
                              style: TextStyle(
                                color: isCurrentUser
                                    ? Colors.black
                                    : AppColors.neutral100,
                                fontSize: 14,
                                fontFamily: 'FranklinGothic URW',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          // Avatar
                          Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.neutral700,
                              image: entry.userAvatarUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(entry.userAvatarUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: entry.userAvatarUrl == null
                                ? const Icon(
                                    Icons.person,
                                    color: AppColors.neutral400,
                                    size: 20,
                                  )
                                : null,
                          ),
                          // Nome
                          Expanded(
                            child: Text(
                              entry.userName ?? 'Usuário',
                              style: TextStyle(
                                color: isCurrentUser
                                    ? Colors.black
                                    : AppColors.neutral100,
                                fontSize: 14,
                                fontFamily: 'FranklinGothic URW',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          // Pace
                          SizedBox(
                            width: 80,
                            child: Text(
                              _formatPace(entry.avgPaceSecondsPerKm) ?? '--:--/km',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: isCurrentUser
                                    ? Colors.black
                                    : AppColors.neutral100,
                                fontSize: 14,
                                fontFamily: 'FranklinGothic URW',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          // Tempo total
                          SizedBox(
                            width: 80,
                            child: Text(
                              _formatTime(entry.totalTimeSeconds),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: isCurrentUser
                                    ? Colors.black
                                    : AppColors.neutral100,
                                fontSize: 14,
                                fontFamily: 'FranklinGothic URW',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Indicadores de página
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.lime500),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Erro ao carregar ranking: $error',
            style: const TextStyle(color: AppColors.red500),
          ),
        ),
      ),
    );
  }
}
