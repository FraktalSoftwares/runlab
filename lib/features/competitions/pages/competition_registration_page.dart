import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/models/competition.dart';
import '../../../core/providers/competition_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/models/auth_state.dart' as app_auth;
import '../../../core/theme/app_colors.dart';

/// Página de inscrição em uma competição
class CompetitionRegistrationPage extends ConsumerStatefulWidget {
  final String competitionId;

  const CompetitionRegistrationPage({
    super.key,
    required this.competitionId,
  });

  @override
  ConsumerState<CompetitionRegistrationPage> createState() =>
      _CompetitionRegistrationPageState();
}

class _CompetitionRegistrationPageState
    extends ConsumerState<CompetitionRegistrationPage> {
  String? selectedDistanceId;
  String? selectedLotId;
  bool acceptedTerms = false;


  @override
  Widget build(BuildContext context) {
    final competitionAsync = ref.watch(competitionProvider(widget.competitionId));
    final detailsAsync = ref.watch(competitionDetailsProvider(widget.competitionId));
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, authState),
      body: competitionAsync.when(
        data: (competition) {
          if (competition == null) {
            return const Center(
              child: Text(
                'Competição não encontrada',
                style: TextStyle(color: AppColors.neutral300),
              ),
            );
          }

          return detailsAsync.when(
            data: (details) => _buildContent(context, ref, competition, details),
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.lime500),
            ),
            error: (error, stack) => Center(
              child: Text(
                'Erro ao carregar detalhes: $error',
                style: const TextStyle(color: AppColors.red500),
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.lime500),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Erro ao carregar competição: $error',
            style: const TextStyle(color: AppColors.red500),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    dynamic authState,
  ) {
    Map<String, dynamic>? profile;

    if (authState is app_auth.AuthAuthenticated) {
      profile = authState.profile;
    }

    return AppBar(
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
        'Inscrição',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white, // Brand-neutral-neutral-100
          fontSize: 14,
          fontFamily: 'FranklinGothic URW',
          fontWeight: FontWeight.w500,
          height: 1.50,
        ),
      ),
      centerTitle: true,
      actions: [
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
            // Badge de notificação
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
            margin: const EdgeInsets.only(right: 16),
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
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    Competition competition,
    Map<String, dynamic>? details,
  ) {
    final distances = details?['distances'] as List<dynamic>? ?? [];
    final lots = details?['lots'] as List<dynamic>? ?? [];

    // Selecionar automaticamente o primeiro lote de assinatura se disponível
    if (selectedLotId == null && lots.isNotEmpty) {
      for (final lot in lots) {
        final isSubscriptionAllowed = lot['is_subscription_allowed'] as bool? ?? false;
        if (isSubscriptionAllowed) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && selectedLotId == null) {
              setState(() {
                selectedLotId = lot['id'] as String?;
              });
            }
          });
          break;
        }
      }
    }

    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resumo da competição
                _buildCompetitionSummary(competition, distances),
                const SizedBox(height: 16),
                // Título e descrição
                _buildHeaderSection(),
                const SizedBox(height: 16),
                // Opções de inscrição
                ...lots.asMap().entries.map((entry) {
                  final index = entry.key;
                  final lot = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(bottom: index < lots.length - 1 ? 0 : 0),
                    child: _buildRegistrationOption(lot),
                  );
                }),
                const SizedBox(height: 16),
                // Checkbox de aceite
                _buildTermsCheckbox(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        // Botão finalizar fixo no bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildFinalizeButton(context, ref, competition),
        ),
      ],
    );
  }

  Widget _buildCompetitionSummary(
    Competition competition,
    List<dynamic> distances,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        color: AppColors.neutral750,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RESUMO DA COMPETIÇÃO',
            style: TextStyle(
              color: Color(0xFFB2B2B2), // Brand-neutral-neutral-400
              fontSize: 12,
              fontFamily: 'FranklinGothic URW',
              fontWeight: FontWeight.w500,
              height: 1.50,
              letterSpacing: 0.48,
            ),
          ),
          const SizedBox(height: 16),
          // Nome da competição
          _buildSummaryRow(
            'Nome da competição:',
            competition.title,
          ),
          // Local
          if (competition.locationName != null)
            _buildSummaryRow(
              'Local:',
              competition.locationName!,
            ),
          // Inscrições
          if (competition.registrationStartsAt != null &&
              competition.registrationEndsAt != null)
            _buildSummaryRow(
              'Inscrições:',
              '${_formatDateShort(competition.registrationStartsAt!)} – ${_formatDateShort(competition.registrationEndsAt!)}',
            ),
          // Dia da competição
          _buildSummaryRow(
            'Dia da Competição',
            _formatCompetitionDate(competition.startsAt),
          ),
          // Kit de participação (vem do lote selecionado ou descrição)
          if (competition.description != null)
            _buildSummaryRow(
              'Kit de participação',
              competition.description!,
            ),
          const SizedBox(height: 16),
          // Seleção de distância
          const Text(
            'Qual distância você irá percorrer?',
            style: TextStyle(
              color: Color(0xFFB2B2B2), // Brand-neutral-neutral-400
              fontSize: 14,
              fontFamily: 'FranklinGothic URW',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: distances.map((distance) {
              final distanceId = distance['id'] as String? ?? '';
              final label = distance['label'] as String? ?? '';
              final isSelected = selectedDistanceId == distanceId;

              return Padding(
                padding: EdgeInsets.only(
                  right: distances.last == distance ? 0 : 12,
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDistanceId = distanceId;
                    });
                  },
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: isSelected ? AppColors.lime500 : AppColors.neutral700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFF121212) // Brand-neutral-neutral-800
                            : const Color(0xFFB2B2B2), // Brand-neutral-neutral-400
                        fontSize: 14,
                        fontFamily: 'FranklinGothic URW',
                        fontWeight: FontWeight.w500,
                        height: 1.50,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Modalidade
          const Text(
            'Modalidade única',
            style: TextStyle(
              color: Color(0xFFB2B2B2), // Brand-neutral-neutral-400
              fontSize: 14,
              fontFamily: 'FranklinGothic URW',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: AppColors.lime500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Text(
                  competition.mode == CompetitionMode.indoor ? 'Indoor' : 'Outdoor',
                  style: const TextStyle(
                    color: Color(0xFF121212), // Brand-neutral-neutral-800
                    fontSize: 14,
                    fontFamily: 'FranklinGothic URW',
                    fontWeight: FontWeight.w500,
                    height: 1.50,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: AppColors.neutral600,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFB2B2B2), // Brand-neutral-neutral-400
              fontSize: 14,
              fontFamily: 'FranklinGothic URW',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFF5F5F5), // Brand-neutral-neutral-200
              fontSize: 20,
              fontFamily: 'FranklinGothic URW',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 48,
            child: Text(
              'Escolha como deseja \nse inscrever',
              style: TextStyle(
                color: Color(0xFFF5F5F5), // Brand-neutral-neutral-200
                fontSize: 24,
                fontFamily: 'FranklinGothic URW',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Você pode comprar esta corrida individualmente ou aproveitar um dos planos RunLab para ter acesso a várias competições durante o ano.',
            style: TextStyle(
              color: Color(0xFFB2B2B2), // Brand-neutral-neutral-400
              fontSize: 14,
              fontFamily: 'FranklinGothic URW',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationOption(Map<String, dynamic> lot) {
    final lotId = lot['id'] as String? ?? '';
    final name = lot['name'] as String? ?? '';
    final priceCents = lot['price_cents'] as int? ?? 0;
    final price = priceCents / 100;
    final formattedPrice = 'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';
    final isSelected = selectedLotId == lotId;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: ShapeDecoration(
        color: AppColors.neutral750,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: isSelected ? AppColors.lime500 : AppColors.neutral700,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedLotId = lotId;
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFFB2B2B2), // Brand-neutral-neutral-400
                        fontSize: 16,
                        fontFamily: 'FranklinGothic URW',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedPrice,
                      style: const TextStyle(
                        color: Color(0xFFCCF725), // Brand-lime-lime-500-(base)
                        fontSize: 24,
                        fontFamily: 'FranklinGothic URW',
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: ShapeDecoration(
                            shape: OvalBorder(
                              side: BorderSide(
                                width: isSelected ? 4 : 2,
                                color: isSelected
                                    ? const Color(0xFFD9FF40)
                                    : AppColors.neutral500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Container(
      width: double.infinity,
      height: 40,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(4),
            child: Stack(
              children: [
                Positioned(
                  left: 2,
                  top: 4,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const ShapeDecoration(
                      color: Colors.transparent,
                      shape: OvalBorder(),
                    ),
                  ),
                ),
                Checkbox(
                  value: acceptedTerms,
                  onChanged: (value) {
                    setState(() {
                      acceptedTerms = value ?? false;
                    });
                  },
                  activeColor: AppColors.lime500,
                  side: const BorderSide(
                    width: 1.50,
                    color: AppColors.neutral600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: Text(
                'Li e aceito o regulamento da competição.',
                style: const TextStyle(
                  color: Color(0xFF808080), // Brand-neutral-neutral-500
                  fontSize: 12,
                  fontFamily: 'FranklinGothic URW',
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalizeButton(
    BuildContext context,
    WidgetRef ref,
    Competition competition,
  ) {
    final canFinalize = selectedDistanceId != null &&
        selectedLotId != null &&
        acceptedTerms;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: canFinalize ? AppColors.lime500 : AppColors.neutral600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: Stack(
              children: [
                if (canFinalize)
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.02),
                      ),
                    ),
                  ),
                Center(
                  child: GestureDetector(
                    onTap: canFinalize
                        ? () async {
                            try {
                              final service = ref.read(competitionServiceProvider);
                              await service.createRegistration(
                                competitionId: competition.id,
                                distanceId: selectedDistanceId!,
                                lotId: selectedLotId!,
                                acceptedTerms: acceptedTerms,
                              );

                              if (context.mounted) {
                                // Atualizar providers
                                ref.invalidate(competitionDetailsProvider(competition.id));
                                ref.invalidate(competitionProvider(competition.id));

                                // Voltar para página de detalhes
                                context.pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Inscrição realizada com sucesso!'),
                                    backgroundColor: AppColors.lime500,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Erro ao realizar inscrição: $e'),
                                    backgroundColor: AppColors.red500,
                                  ),
                                );
                              }
                            }
                          }
                        : null,
                    child: Text(
                      'Finalizar inscrição',
                      style: TextStyle(
                        color: canFinalize
                            ? const Color(0xFF121212) // Brand-neutral-neutral-800
                            : AppColors.neutral400,
                        fontSize: 16,
                        fontFamily: 'FranklinGothic URW',
                        fontWeight: FontWeight.w500,
                        height: 1.50,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 34,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 21,
                  child: Center(
                    child: Container(
                      width: 134,
                      height: 5,
                      decoration: ShapeDecoration(
                        color: AppColors.neutral100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateShort(DateTime date) {
    return DateFormat('dd/MM').format(date);
  }

  String _formatCompetitionDate(DateTime date) {
    final monthNames = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro'
    ];

    final month = monthNames[date.month - 1];
    final hour = date.hour;
    return '${date.day} $month • ${hour}h';
  }
}
