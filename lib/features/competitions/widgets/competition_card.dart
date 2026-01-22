import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/models/competition.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Card de competição para a listagem - Design refinado conforme Figma
class CompetitionCard extends StatelessWidget {
  final Competition competition;
  final List<CompetitionSponsor>? sponsors;
  final CompetitionLot? cheapestLot;
  final List<CompetitionDistance>? distances;

  const CompetitionCard({
    super.key,
    required this.competition,
    this.sponsors,
    this.cheapestLot,
    this.distances,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 24),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: ShapeDecoration(
        color: AppColors.neutral750,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: AppColors.neutral700,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seção da imagem
          _buildImageSection(),
          // Conteúdo do card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Tags
                _buildTags(),
                const SizedBox(height: 12),
                // Data/hora e título
                _buildDateTimeAndTitle(),
                const SizedBox(height: 24),
                // Detalhes (Inscrições, Valor, Patrocinadores)
                _buildDetails(),
                const SizedBox(height: 24),
                // Botão Ver detalhes
                _buildViewDetailsButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      height: 238.67,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(),
      child: Stack(
        children: [
          // Imagem de fundo
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Container(
              height: 239,
              decoration: ShapeDecoration(
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
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: AppColors.neutral700,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              ),
              child: competition.coverImageUrl == null
                  ? const Center(
                      child: Icon(
                        Icons.directions_run,
                        color: AppColors.neutral500,
                        size: 48,
                      ),
                    )
                  : null,
            ),
          ),
          // Gradiente na parte inferior da imagem
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
          // Badges de status
          Positioned(
            left: 24,
            right: 24,
            bottom: 20,
            child: _buildImageBadges(),
          ),
        ],
      ),
    );
  }

  Widget _buildImageBadges() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Badge esquerdo (Últimos dias ou vazio)
        if (_shouldShowLastDaysBadge())
          _buildBadge(
            'Últimos dias',
            backgroundColor: AppColors.red500,
            textColor: AppColors.neutral100,
          )
        else
          const SizedBox.shrink(),
        // Badge direito (Status ou Inscrições abertas)
        _buildStatusOrRegistrationBadge(),
      ],
    );
  }

  bool _shouldShowLastDaysBadge() {
    if (competition.status != CompetitionStatus.open) return false;
    if (competition.registrationEndsAt == null) return false;
    
    final now = DateTime.now();
    final endsAt = competition.registrationEndsAt!;
    final daysUntilEnd = endsAt.difference(now).inDays;
    
    return daysUntilEnd <= 7 && daysUntilEnd > 0;
  }

  Widget _buildStatusOrRegistrationBadge() {
    switch (competition.status) {
      case CompetitionStatus.finished:
        return _buildBadge(
          'Finalizada',
          borderColor: AppColors.neutral400,
          textColor: AppColors.neutral200,
          textAlign: TextAlign.right,
        );
      case CompetitionStatus.inProgress:
        return _buildBadge(
          'Em andamento',
          borderColor: AppColors.yellow500,
          textColor: AppColors.yellow500,
        );
      case CompetitionStatus.open:
        return _buildBadge(
          'Inscrições abertas',
          borderColor: AppColors.lime500,
          textColor: AppColors.lime500,
          textAlign: TextAlign.right,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBadge(
    String label, {
    Color? backgroundColor,
    Color? borderColor,
    Color? textColor,
    TextAlign? textAlign,
  }) {
    return Container(
      height: 21,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          side: borderColor != null
              ? BorderSide(
                  width: 0.50,
                  color: borderColor,
                )
              : BorderSide.none,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: textAlign,
          style: TextStyle(
            color: textColor ?? AppColors.neutral200,
            fontSize: 12,
            fontFamily: AppTypography.fontFamily,
            fontWeight: AppTypography.medium,
            height: 0.92,
          ),
        ),
      ),
    );
  }

  Widget _buildTags() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTag(
          competition.status == CompetitionStatus.open ? 'Aberta' : 'Fechada',
        ),
        const SizedBox(width: 8),
        _buildTag(
          competition.mode == CompetitionMode.outdoor ? 'Outdoor' : 'Indoor',
        ),
      ],
    );
  }

  Widget _buildTag(String label) {
    final isOutdoorOrIndoor = label == 'Outdoor' || label == 'Indoor';
    return Container(
      height: 21,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 0.50,
            color: AppColors.neutral500,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: isOutdoorOrIndoor ? TextAlign.center : null,
          style: const TextStyle(
            color: AppColors.neutral200,
            fontSize: 12,
            fontFamily: AppTypography.fontFamily,
            fontWeight: AppTypography.medium,
            height: 0.92,
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeAndTitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Data/hora
        Text(
          _formatDateTime(),
          style: const TextStyle(
            color: AppColors.lime500,
            fontSize: 12,
            fontFamily: AppTypography.fontFamily,
            fontWeight: FontWeight.w500,
            height: 1.50,
            letterSpacing: 0.48,
          ),
        ),
        const SizedBox(height: 4),
        // Título
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                _getTitleWithDistance(),
                style: const TextStyle(
                  color: AppColors.neutral200,
                  fontSize: 24,
                  fontFamily: AppTypography.fontFamily,
                  fontWeight: FontWeight.w500,
                ),
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
      ],
    );
  }

  String _formatDateTime() {
    final dateFormat = DateFormat('EEE, d MMM');
    final timeFormat = DateFormat('HH:mm');
    
    String dateStr;
    try {
      dateStr = dateFormat.format(competition.startsAt).toUpperCase();
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
      dateStr = '${competition.startsAt.day}/${competition.startsAt.month}';
    }
    
    final timeStr = timeFormat.format(competition.startsAt);
    return '$dateStr • ${timeStr}H';
  }

  String _getTitleWithDistance() {
    String titleText = competition.title;
    
    if (!titleText.contains('•') && distances != null && distances!.isNotEmpty) {
      final firstDistance = distances!.first;
      titleText = '${competition.title} • ${firstDistance.label}';
    }
    
    return titleText.toUpperCase();
  }

  Widget _buildDetails() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Inscrições
        if (competition.registrationEndsAt != null)
          _buildDetailRow(
            'Inscrições',
            'Até ${_formatDate(competition.registrationEndsAt!)}',
          ),
        // Valor
        if (!competition.isFree || cheapestLot != null) ...[
          const SizedBox(height: 8),
          _buildDetailRow(
            'Valor',
            _getPriceText(),
            isValue: true,
          ),
        ],
        // Patrocinadores
        if (sponsors != null && sponsors!.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildDetailRow(
            'Patrocinadores',
            sponsors!.map((s) => s.name).join(' • '),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isValue = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.neutral400,
              fontSize: 16,
              fontFamily: AppTypography.fontFamily,
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isValue ? AppColors.lime500 : AppColors.neutral300,
              fontSize: 16,
              fontFamily: AppTypography.fontFamily,
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
        ),
      ],
    );
  }

  String _getPriceText() {
    if (competition.isFree) {
      return 'Grátis';
    }
    if (cheapestLot != null) {
      return cheapestLot!.formattedPrice;
    }
    return 'Consulte valores';
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Widget _buildViewDetailsButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/competitions/${competition.id}');
      },
      child: Container(
        width: double.infinity,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white.withOpacity(0.02),
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: AppColors.lime500,
            ),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: Center(
          child: Text(
            'Ver detalhes',
            style: const TextStyle(
              color: AppColors.lime500,
              fontSize: 16,
              fontFamily: AppTypography.fontFamily,
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
        ),
      ),
    );
  }
}
