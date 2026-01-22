import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

/// Página de countdown (3-2-1) antes de iniciar a corrida
class RunCountdownPage extends StatefulWidget {
  final String runId;

  const RunCountdownPage({
    super.key,
    required this.runId,
  });

  @override
  State<RunCountdownPage> createState() => _RunCountdownPageState();
}

class _RunCountdownPageState extends State<RunCountdownPage> {
  int _countdown = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });

      if (_countdown <= 0) {
        timer.cancel();
        // Navega para tela de start
        if (mounted) {
          context.pushReplacement('/runs/${widget.runId}/start');
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          _countdown > 0 ? '$_countdown' : '',
          style: const TextStyle(
            color: Color(0xFFCCF725), // Brand-lime-lime-500-(base)
            fontSize: 120,
            fontFamily: 'FranklinGothic URW',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
