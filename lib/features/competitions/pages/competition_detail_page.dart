import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/models/competition.dart';
import '../../../core/providers/competition_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/run_provider.dart';
import '../../../core/models/auth_state.dart' as app_auth;
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Página de detalhes de uma competição
class CompetitionDetailPage extends ConsumerWidget {
  final String competitionId;

  const CompetitionDetailPage({
    super.key,
    required this.competitionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final competitionAsync = ref.watch(competitionProvider(competitionId));
    final detailsAsync = ref.watch(competitionDetailsProvider(competitionId));
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
        'Detalhes da competição',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.neutral100,
          fontSize: 14,
          fontFamily: AppTypography.fontFamily,
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
    final sponsors = details?['sponsors'] as List<dynamic>? ?? [];
    final lots = details?['lots'] as List<dynamic>? ?? [];
    final documents = details?['documents'] as List<dynamic>? ?? [];
    final userIsRegistered = details?['user_is_registered'] as bool? ?? false;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Image
          _buildHeroImage(competition),
          // Informações principais
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Data de inscrição
                if (competition.registrationEndsAt != null)
                  Text(
                    'Inscrições até ${_formatDate(competition.registrationEndsAt!)}',
                    style: const TextStyle(
                      color: AppColors.red500,
                      fontSize: 14,
                      fontFamily: AppTypography.fontFamily,
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                      letterSpacing: 0.56,
                    ),
                  ),
                if (competition.registrationEndsAt != null) const SizedBox(height: 8),
                // Data e hora, título e localização
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDateTime(competition.startsAt),
                      style: const TextStyle(
                        color: AppColors.lime500,
                        fontSize: 14,
                        fontFamily: AppTypography.fontFamily,
                        fontWeight: FontWeight.w500,
                        height: 1.50,
                        letterSpacing: 0.56,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      competition.title.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.neutral200,
                        fontSize: 24,
                        fontFamily: AppTypography.fontFamily,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (competition.locationName != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        competition.locationName!.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.neutral200,
                          fontSize: 12,
                          fontFamily: AppTypography.fontFamily,
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                          letterSpacing: 0.48,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                // Seções
                if (competition.description != null || distances.isNotEmpty)
                  _buildDescriptionSection(competition, distances),
                if (competition.prizeDescription != null) ...[
                  const SizedBox(height: 16),
                  _buildPrizeSection(competition),
                ],
                if (sponsors.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildSponsorsSection(sponsors),
                ],
                if (lots.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildLotsSection(lots),
                ],
                if (documents.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildDocumentsSection(documents),
                ],
              ],
            ),
          ),
          // Botão de inscrição
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: _buildRegisterButton(context, ref, competition, userIsRegistered),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(Competition competition) {
    return Container(
      width: double.infinity,
      height: 280,
      child: Stack(
        children: [
          // Imagem de fundo
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                image: competition.coverImageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(competition.coverImageUrl!),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {},
                      )
                    : null,
                color: competition.coverImageUrl == null
                    ? AppColors.neutral800
                    : null,
              ),
              child: competition.coverImageUrl == null
                  ? const Center(
                      child: Icon(
                        Icons.directions_run,
                        color: AppColors.neutral500,
                        size: 64,
                      ),
                    )
                  : null,
            ),
          ),
          // Gradiente na parte inferior
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 84,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(0.50, 1.00),
                  end: const Alignment(0.50, 0.00),
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(0.50),
                  ],
                ),
              ),
            ),
          ),
          // Badges na parte inferior esquerda
          Positioned(
            left: 24,
            bottom: 20,
            child: Row(
              children: [
                _buildImageBadge(
                  competition.status == CompetitionStatus.open ? 'Aberta' : 'Fechada',
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(width: 8),
                _buildImageBadge(
                  competition.mode == CompetitionMode.indoor ? 'Indoor' : 'Outdoor',
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ),
          // Ícone de compartilhar no canto inferior direito
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: ShapeDecoration(
                color: AppColors.neutral700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                shadows: [
                  BoxShadow(
                    color: AppColors.neutral700.withOpacity(0.4),
                    blurRadius: 4.58,
                    offset: const Offset(0, 0),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: const Icon(
                Icons.share_outlined,
                color: AppColors.neutral100,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageBadge(String text, {Color? backgroundColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: ShapeDecoration(
        color: backgroundColor ?? Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 0.50,
            color: AppColors.neutral500,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.neutral200,
          fontSize: 16,
          fontFamily: AppTypography.fontFamily,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(Competition competition, List<dynamic> distances) {
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
            'Descrição',
            style: TextStyle(
              color: AppColors.neutral200,
              fontSize: 16,
              fontFamily: AppTypography.fontFamily,
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
          if (competition.description != null) ...[
            const SizedBox(height: 8),
            Text(
              competition.description!,
              style: const TextStyle(
                color: AppColors.neutral400,
                fontSize: 14,
                fontFamily: AppTypography.fontFamily,
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ],
          if (distances.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Distâncias:',
                style: TextStyle(
                  color: AppColors.neutral200,
                  fontSize: 16,
                  fontFamily: AppTypography.fontFamily,
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              distances.map((d) => d['label'] as String? ?? '').join(', '),
              style: const TextStyle(
                color: AppColors.neutral100,
                fontSize: 16,
                fontFamily: AppTypography.fontFamily,
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrizeSection(Competition competition) {
    final prizes = competition.prizeDescription!.split('\n').where((p) => p.trim().isNotEmpty).toList();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
            'Premiação',
            style: TextStyle(
              color: AppColors.neutral200,
              fontSize: 16,
              fontFamily: AppTypography.fontFamily,
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
          const SizedBox(height: 8),
          ...prizes.map((prize) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                prize.trim(),
                style: const TextStyle(
                  color: AppColors.neutral400,
                  fontSize: 14,
                  fontFamily: AppTypography.fontFamily,
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSponsorsSection(List<dynamic> sponsors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
            'Patrocinadores',
            style: TextStyle(
              color: AppColors.neutral200,
              fontSize: 16,
              fontFamily: AppTypography.fontFamily,
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 24,
            runSpacing: 16,
            children: sponsors.map((sponsor) {
              final name = sponsor['name'] as String? ?? '';
              final logoUrl = sponsor['logo_url'] as String?;
              
              if (logoUrl != null && logoUrl.isNotEmpty) {
                return Image.network(
                  logoUrl,
                  height: 19,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 79,
                      height: 19,
                      color: AppColors.neutral800,
                      child: const Center(
                        child: SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.neutral500,
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback: exibir nome do patrocinador em texto
                    return Container(
                      constraints: const BoxConstraints(
                        minWidth: 79,
                        maxWidth: 150,
                      ),
                      height: 19,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.neutral400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: AppColors.neutral800,
                            fontSize: 10,
                            fontFamily: AppTypography.fontFamily,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                );
              } else {
                // Sem logo: exibir nome do patrocinador
                return Container(
                  constraints: const BoxConstraints(
                    minWidth: 79,
                    maxWidth: 150,
                  ),
                  height: 19,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.neutral400,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.neutral800,
                        fontSize: 10,
                        fontFamily: AppTypography.fontFamily,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLotsSection(List<dynamic> lots) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
            'Tipos de inscrição',
            style: TextStyle(
              color: AppColors.neutral200,
              fontSize: 16,
              fontFamily: AppTypography.fontFamily,
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
          const SizedBox(height: 8),
          ...lots.asMap().entries.map((entry) {
            final index = entry.key;
            final lot = entry.value;
            final name = lot['name'] as String? ?? '';
            final description = lot['description'] as String?;
            final priceCents = lot['price_cents'] as int? ?? 0;
            final isSubscriptionAllowed = lot['is_subscription_allowed'] as bool? ?? false;
            final price = priceCents / 100;
            final formattedPrice = 'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';

            return Column(
              children: [
                if (index > 0)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: AppColors.neutral600,
                        ),
                      ),
                    ),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.neutral400,
                        fontSize: 14,
                        fontFamily: AppTypography.fontFamily,
                        fontWeight: FontWeight.w500,
                        height: 1.50,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formattedPrice,
                          style: const TextStyle(
                            color: AppColors.lime500,
                            fontSize: 14,
                            fontFamily: AppTypography.fontFamily,
                            fontWeight: FontWeight.w600,
                            height: 1.50,
                          ),
                        ),
                        if (description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: const TextStyle(
                              color: AppColors.neutral400,
                              fontSize: 14,
                              fontFamily: AppTypography.fontFamily,
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                        ],
                        if (isSubscriptionAllowed) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(4),
                                child: Checkbox(
                                  value: false,
                                  onChanged: (value) {
                                    // TODO: Implementar checkbox
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
                              ),
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 11),
                                  child: Text(
                                    'Permitir compra com créditos da assinatura',
                                    style: TextStyle(
                                      color: AppColors.neutral300,
                                      fontSize: 14,
                                      fontFamily: AppTypography.fontFamily,
                                      fontWeight: FontWeight.w500,
                                      height: 1.50,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDocumentsSection(List<dynamic> documents) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
            'Documentos',
            style: TextStyle(
              color: AppColors.neutral200,
              fontSize: 16,
              fontFamily: AppTypography.fontFamily,
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
          const SizedBox(height: 8),
          ...documents.map((doc) {
            final title = doc['title'] as String? ?? '';

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              width: double.infinity,
              height: 40,
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: AppColors.neutral800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.download_outlined,
                    color: AppColors.lime500,
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.lime500,
                        fontSize: 14,
                        fontFamily: AppTypography.fontFamily,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(
    BuildContext context,
    WidgetRef ref,
    Competition competition,
    bool userIsRegistered,
  ) {
    final now = DateTime.now();
    final isRegistrationOpen = competition.registrationEndsAt != null &&
        now.isBefore(competition.registrationEndsAt!);
    final hasRegistrationStarted = competition.registrationStartsAt == null ||
        now.isAfter(competition.registrationStartsAt!);

    String buttonText;
    bool isEnabled = false;
    Color backgroundColor = AppColors.lime500;
    Color textColor = AppColors.neutral800;

    // Se o usuário está inscrito E a competição é grátis, mostrar "Iniciar corrida"
    if (userIsRegistered && competition.isFree) {
      buttonText = 'Iniciar corrida';
      isEnabled = true;
      backgroundColor = AppColors.lime500;
      textColor = AppColors.neutral800;
    } else if (userIsRegistered) {
      buttonText = 'Você já está inscrito';
      isEnabled = false;
      backgroundColor = AppColors.neutral600;
      textColor = AppColors.neutral400;
    } else if (!isRegistrationOpen) {
      buttonText = 'Inscrições encerradas';
      isEnabled = false;
      backgroundColor = AppColors.neutral600;
      textColor = AppColors.neutral400;
    } else if (!hasRegistrationStarted) {
      buttonText = 'Inscrições ainda não iniciadas';
      isEnabled = false;
      backgroundColor = AppColors.neutral600;
      textColor = AppColors.neutral400;
    } else {
      buttonText = 'Inscreva-se na competição';
      isEnabled = true;
      backgroundColor = AppColors.lime500;
      textColor = AppColors.neutral800;
    }

    return GestureDetector(
      onTap: isEnabled
          ? () {
              // Se for competição grátis e usuário inscrito, iniciar corrida
              if (userIsRegistered && competition.isFree) {
                _startRun(context, ref, competition);
              } else {
                // Caso contrário, ir para página de inscrição
                context.push('/competitions/${competition.id}/register');
              }
            }
          : null,
      child: Container(
        width: double.infinity,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: Stack(
          children: [
            if (isEnabled)
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                  ),
                ),
              ),
            Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontFamily: 'FranklinGothic URW',
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startRun(
    BuildContext context,
    WidgetRef ref,
    Competition competition,
  ) async {
    try {
      // Buscar registrationId do usuário
      final service = ref.read(competitionServiceProvider);
      final registration = await service.getUserRegistration(competition.id);

      // Criar corrida
      final runService = ref.read(runServiceProvider);
      final run = await runService.createRun(
        competitionId: competition.id,
        registrationId: registration?.id,
      );

      // Navegar para countdown
      if (context.mounted) {
        context.push('/runs/${run.id}/countdown');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao iniciar corrida: $e'),
            backgroundColor: AppColors.red500,
          ),
        );
      }
    }
  }

  String _formatDateTime(DateTime date) {
    final dateFormat = DateFormat('EEE, d MMM');
    final timeFormat = DateFormat('HH:mm');
    
    String dateStr;
    try {
      dateStr = dateFormat.format(date).toUpperCase();
      dateStr = dateStr
          .replaceAll('Mon', 'SEG')
          .replaceAll('Tue', 'TER')
          .replaceAll('Wed', 'QUA')
          .replaceAll('Thu', 'QUI')
          .replaceAll('Fri', 'SEX')
          .replaceAll('Sat', 'SAB')
          .replaceAll('Sun', 'DOM')
          .replaceAll('Jan', 'JAN')
          .replaceAll('Feb', 'FEV')
          .replaceAll('Mar', 'MAR')
          .replaceAll('Apr', 'ABR')
          .replaceAll('May', 'MAI')
          .replaceAll('Jun', 'JUN')
          .replaceAll('Jul', 'JUL')
          .replaceAll('Aug', 'AGO')
          .replaceAll('Sep', 'SET')
          .replaceAll('Oct', 'OUT')
          .replaceAll('Nov', 'NOV')
          .replaceAll('Dec', 'DEZ');
    } catch (e) {
      dateStr = '${date.day}/${date.month}';
    }
    
    final timeStr = timeFormat.format(date);
    return '$dateStr • ${timeStr}H';
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
