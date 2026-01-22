import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/run_tracking_provider.dart';

/// Página com botão Play para iniciar a corrida
class RunStartPage extends ConsumerWidget {
  final String runId;

  const RunStartPage({
    super.key,
    required this.runId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackingNotifier = ref.read(runTrackingProvider(runId).notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Spacer(),
            // Botão Play
            GestureDetector(
              onTap: () async {
                await trackingNotifier.startRun();
                if (context.mounted) {
                  context.pushReplacement('/runs/$runId/active');
                }
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: ShapeDecoration(
                  color: const Color(0xFFCCF725), // Brand-lime-lime-500-(base)
                  shape: CircleBorder(
                    side: BorderSide(
                      width: 2,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.black,
                    size: 60,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Texto
            const Text(
              'Inicie a corrida',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'FranklinGothic URW',
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
