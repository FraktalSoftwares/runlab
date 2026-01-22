import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/competition.dart';
import '../../../core/models/auth_state.dart' as app_auth;
import '../../../core/providers/competition_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/competition_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/atoms/app_text.dart';
import '../widgets/competition_card.dart';
import '../widgets/competition_search_bar.dart';

/// Página principal de competições (Home do módulo)
class CompetitionsPage extends ConsumerStatefulWidget {
  const CompetitionsPage({super.key});

  @override
  ConsumerState<CompetitionsPage> createState() => _CompetitionsPageState();
}

class _CompetitionsPageState extends ConsumerState<CompetitionsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState is app_auth.AuthAuthenticated ? authState.user : null;
    final profile = authState is app_auth.AuthAuthenticated ? authState.profile : null;

    // Carregar competições
    final competitionsAsync = ref.watch(
      competitionsProvider(
        CompetitionListParams(),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, user, profile),
      body: Column(
        children: [
          // Barra de busca e filtro
          CompetitionSearchBar(
            searchController: _searchController,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query.toLowerCase();
              });
            },
            onFilterTap: () {
              // TODO: Implementar filtros
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filtros em breve')),
              );
            },
          ),
          // Lista de competições
          Expanded(
            child: competitionsAsync.when(
              data: (competitions) {
                // Filtrar por busca
                final filtered = _searchQuery.isEmpty
                    ? competitions
                    : competitions.where((c) {
                        return c.title.toLowerCase().contains(_searchQuery) ||
                            (c.locationName?.toLowerCase().contains(_searchQuery) ?? false) ||
                            (c.subtitle?.toLowerCase().contains(_searchQuery) ?? false);
                      }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppText(
                          _searchQuery.isEmpty
                              ? 'Nenhuma competição encontrada'
                              : 'Nenhuma competição encontrada para "$_searchQuery"',
                          variant: AppTextVariant.body,
                          color: AppTextColor.secondary,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(competitionsProvider(CompetitionListParams()));
                  },
                  color: AppColors.lime500,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final competition = filtered[index];
                      // Carregar patrocinadores, distâncias e lote mais barato para cada competição
                      return _CompetitionCardWithData(
                        competition: competition,
                        competitionService: ref.read(competitionServiceProvider),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.lime500,
                ),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppText(
                      'Erro ao carregar competições',
                      variant: AppTextVariant.titleMedium,
                      color: AppTextColor.error,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppText(
                      error.toString(),
                      variant: AppTextVariant.bodySmall,
                      color: AppTextColor.secondary,
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(competitionsProvider(CompetitionListParams()));
                      },
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.all(14),
        decoration: ShapeDecoration(
          color: AppColors.lime500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1398.60),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x26CCF725),
              blurRadius: 12,
              offset: Offset(6, 6),
              spreadRadius: 0,
            ),
          ],
        ),
        child: IconButton(
          onPressed: () {
            // TODO: Implementar criação de competição (apenas admin)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Criar competição em breve')),
            );
          },
          icon: const Icon(
            Icons.add,
            color: AppColors.background,
            size: 28,
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    dynamic user,
    Map<String, dynamic>? profile,
  ) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 60,
      title: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Espaço vazio à esquerda (para centralizar o título)
            const SizedBox(width: 82.50),
            // Título centralizado
            const Expanded(
              child: Text(
                'Competições',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.neutral100,
                  fontSize: 14,
                  fontFamily: AppTypography.fontFamily,
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                ),
              ),
            ),
            // Ações à direita
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Ícone de notificação
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      padding: const EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        color: AppColors.neutral750,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: AppColors.neutral200,
                          size: 20,
                        ),
                        onPressed: () {
                          // TODO: Implementar notificações
                        },
                      ),
                    ),
                    // Badge de notificação (ponto verde)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.lime500,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                // Avatar do usuário
                GestureDetector(
                  onTap: () {
                    context.push('/account');
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1250),
                      ),
                    ),
                    child: profile?['avatar_url'] != null
                        ? Image.network(
                            profile!['avatar_url'] as String,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.neutral750,
                                child: const Icon(
                                  Icons.person,
                                  color: AppColors.neutral500,
                                  size: 20,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: AppColors.neutral750,
                            child: const Icon(
                              Icons.person,
                              color: AppColors.neutral500,
                              size: 20,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 42),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: AppColors.background,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: AppColors.neutral750,
          ),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 5,
            offset: Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              icon: Icons.flag,
              label: 'Competições',
              isSelected: true,
              onTap: () {},
            ),
            _buildNavItem(
              context,
              icon: Icons.history,
              label: 'Histórico',
              onTap: () {
                context.push('/history');
              },
            ),
            _buildNavItem(
              context,
              icon: Icons.emoji_events,
              label: 'Ranking',
              onTap: () {
                context.push('/ranking');
              },
            ),
            _buildNavItem(
              context,
              icon: Icons.person,
              label: 'Conta',
              onTap: () {
                context.push('/account');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.lime500 : AppColors.neutral500,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? AppColors.lime500 : AppColors.neutral500,
                fontSize: 12,
                fontFamily: AppTypography.fontFamily,
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ],
        ),
      ),
    );
  }

}

/// Widget auxiliar para carregar dados adicionais da competição
class _CompetitionCardWithData extends StatelessWidget {
  final Competition competition;
  final CompetitionService competitionService;

  const _CompetitionCardWithData({
    required this.competition,
    required this.competitionService,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadCompetitionData(),
      builder: (context, snapshot) {
        final sponsors = snapshot.data?['sponsors'] as List<CompetitionSponsor>?;
        final cheapestLot = snapshot.data?['cheapestLot'] as CompetitionLot?;
        final distances = snapshot.data?['distances'] as List<CompetitionDistance>?;
        
        return CompetitionCard(
          competition: competition,
          sponsors: sponsors,
          cheapestLot: cheapestLot,
          distances: distances,
        );
      },
    );
  }

  Future<Map<String, dynamic>> _loadCompetitionData() async {
    try {
      final sponsors = await competitionService.getCompetitionSponsors(competition.id);
      final lots = await competitionService.getCompetitionLots(competition.id, onlyActive: true);
      final distances = await competitionService.getCompetitionDistances(competition.id);
      
      CompetitionLot? cheapestLot;
      if (lots.isNotEmpty) {
        lots.sort((a, b) => a.priceCents.compareTo(b.priceCents));
        cheapestLot = lots.first;
      }
      
      return {
        'sponsors': sponsors,
        'cheapestLot': cheapestLot,
        'distances': distances,
      };
    } catch (e) {
      return {
        'sponsors': <CompetitionSponsor>[],
        'cheapestLot': null,
        'distances': <CompetitionDistance>[],
      };
    }
  }
}
