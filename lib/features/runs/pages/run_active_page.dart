import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/run_tracking_provider.dart';
import '../../../core/theme/app_colors.dart';

/// Página de corrida em andamento com timer, GPS, pace e botão pausar
class RunActivePage extends ConsumerStatefulWidget {
  final String runId;

  const RunActivePage({
    super.key,
    required this.runId,
  });

  @override
  ConsumerState<RunActivePage> createState() => _RunActivePageState();
}

class _RunActivePageState extends ConsumerState<RunActivePage> {
  bool _showSwipeHint = true;

  @override
  void initState() {
    super.initState();
  }

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
    return (meters / 1000).toStringAsFixed(2);
  }

  String? _formatPace(int? paceSecondsPerKm) {
    if (paceSecondsPerKm == null) return null;
    final minutes = paceSecondsPerKm ~/ 60;
    final seconds = paceSecondsPerKm % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}km';
  }

  @override
  Widget build(BuildContext context) {
    final trackingState = ref.watch(runTrackingProvider(widget.runId));
    final trackingNotifier = ref.read(runTrackingProvider(widget.runId).notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            
            // Métricas no topo: Km percorridos (esquerda) e Pace (direita)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Km percorridos
                  Column(
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
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'FranklinGothic URW',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  // Pace
                  Column(
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
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'FranklinGothic URW',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Banner de swipe (pode ser fechado)
            if (_showSwipeHint)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: ShapeDecoration(
                    color: AppColors.neutral750,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.swipe_right,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Deslize para direita para ver o mapa e o ranking da competição.',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'FranklinGothic URW',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showSwipeHint = false;
                          });
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const Spacer(),

            // Cronômetro grande no centro
            Column(
              children: [
                Text(
                  _formatTime(trackingState.elapsedSeconds),
                  style: const TextStyle(
                    color: Color(0xFFCCF725), // Brand-lime-lime-500
                    fontSize: 64,
                    fontFamily: 'FranklinGothic URW',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tempo total',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'FranklinGothic URW',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Botão Pausar (verde com ícone de pause)
            GestureDetector(
              onTap: () async {
                await trackingNotifier.pauseRun();
                if (context.mounted) {
                  context.pushReplacement('/runs/${widget.runId}/paused');
                }
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: ShapeDecoration(
                  color: const Color(0xFFCCF725), // Brand-lime-lime-500
                  shape: CircleBorder(
                    side: BorderSide(
                      width: 2,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.pause,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Indicadores de página (pontos)
            Row(
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

            const SizedBox(height: 32),

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
    );
  }
}
