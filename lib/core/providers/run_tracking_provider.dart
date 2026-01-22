import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../models/run.dart';
import '../services/location_service.dart';
import '../services/run_service.dart';
import 'run_provider.dart';

/// Estado do tracking de corrida
class RunTrackingState {
  final RunState state;
  final int elapsedSeconds;
  final int distanceMeters;
  final int? currentPaceSecondsPerKm;
  final List<Position> positions;
  final DateTime? startedAt;
  final int pausedSeconds;
  final DateTime? lastPauseAt;

  RunTrackingState({
    required this.state,
    this.elapsedSeconds = 0,
    this.distanceMeters = 0,
    this.currentPaceSecondsPerKm,
    this.positions = const [],
    this.startedAt,
    this.pausedSeconds = 0,
    this.lastPauseAt,
  });

  RunTrackingState copyWith({
    RunState? state,
    int? elapsedSeconds,
    int? distanceMeters,
    int? currentPaceSecondsPerKm,
    List<Position>? positions,
    DateTime? startedAt,
    int? pausedSeconds,
    DateTime? lastPauseAt,
    bool clearPositions = false,
  }) {
    return RunTrackingState(
      state: state ?? this.state,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      currentPaceSecondsPerKm: currentPaceSecondsPerKm ?? this.currentPaceSecondsPerKm,
      positions: clearPositions ? [] : (positions ?? this.positions),
      startedAt: startedAt ?? this.startedAt,
      pausedSeconds: pausedSeconds ?? this.pausedSeconds,
      lastPauseAt: lastPauseAt ?? this.lastPauseAt,
    );
  }
}

/// Provider do LocationService
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

/// Provider do RunTrackingNotifier
final runTrackingProvider =
    StateNotifierProvider.family<RunTrackingNotifier, RunTrackingState, String>(
  (ref, runId) {
    return RunTrackingNotifier(
      ref,
      runId,
      ref.read(locationServiceProvider),
      ref.read(runServiceProvider),
    );
  },
);

/// Notifier para gerenciar estado da corrida em tempo real
class RunTrackingNotifier extends StateNotifier<RunTrackingState> {
  final String _runId;
  final LocationService _locationService;
  final RunService _runService;

  Timer? _timer;
  StreamSubscription<Position>? _positionSubscription;
  DateTime? _lastUpdateTime;

  RunTrackingNotifier(
    Ref ref,
    this._runId,
    this._locationService,
    this._runService,
  ) : super(RunTrackingState(state: RunState.ready)) {
    // Carregar estado inicial de forma assíncrona
    Future.microtask(() => _loadRunState());
  }

  /// Carrega estado inicial da corrida do banco
  Future<void> _loadRunState() async {
    try {
      final run = await _runService.getRunById(_runId);
      if (run != null) {
        state = RunTrackingState(
          state: run.state,
          elapsedSeconds: run.totalTimeSeconds,
          distanceMeters: run.distanceMeters,
          currentPaceSecondsPerKm: run.avgPaceSecondsPerKm,
          startedAt: run.startedAt,
        );

        // Se estiver running, retomar tracking
        if (run.state == RunState.running) {
          await _startTracking();
        }
      }
    } catch (e) {
      // Erro ao carregar, mantém estado inicial
    }
  }

  /// Inicia a corrida
  Future<void> startRun() async {
    if (state.state != RunState.ready) {
      return;
    }

    try {
      await _runService.startRun(_runId);
      
      final now = DateTime.now();
      state = state.copyWith(
        state: RunState.running,
        startedAt: now,
        elapsedSeconds: 0,
      );

      await _startTracking();
    } catch (e) {
      // Tratar erro
    }
  }

  /// Pausa a corrida
  Future<void> pauseRun() async {
    if (state.state != RunState.running) {
      return;
    }

    try {
      await _runService.pauseRun(_runId);
      
      _stopTracking();
      
      state = state.copyWith(
        state: RunState.paused,
        lastPauseAt: DateTime.now(),
      );
    } catch (e) {
      // Tratar erro
    }
  }

  /// Retoma a corrida
  Future<void> resumeRun() async {
    if (state.state != RunState.paused) {
      return;
    }

    try {
      await _runService.resumeRun(_runId);
      
      // Calcula tempo de pausa acumulado
      final pauseDuration = state.lastPauseAt != null
          ? DateTime.now().difference(state.lastPauseAt!).inSeconds
          : 0;
      
      state = state.copyWith(
        state: RunState.running,
        pausedSeconds: state.pausedSeconds + pauseDuration,
        lastPauseAt: null,
      );

      await _startTracking();
    } catch (e) {
      // Tratar erro
    }
  }

  /// Finaliza a corrida
  Future<void> finishRun() async {
    if (state.state != RunState.running && state.state != RunState.paused) {
      return;
    }

    try {
      _stopTracking();

      await _runService.finishRun(
        _runId,
        totalTimeSeconds: state.elapsedSeconds,
        distanceMeters: state.distanceMeters,
        avgPaceSecondsPerKm: state.currentPaceSecondsPerKm,
      );

      state = state.copyWith(state: RunState.finished);
    } catch (e) {
      // Tratar erro
    }
  }

  /// Inicia tracking (timer + GPS)
  Future<void> _startTracking() async {
    // Solicitar permissão antes de iniciar
    await _locationService.requestLocationPermission();

    // Inicia timer
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.state == RunState.running) {
        final now = DateTime.now();
        final elapsed = state.startedAt != null
            ? now.difference(state.startedAt!).inSeconds - state.pausedSeconds
            : 0;

        state = state.copyWith(elapsedSeconds: elapsed > 0 ? elapsed : 0);
      }
    });

    // Inicia GPS tracking
    _positionSubscription?.cancel();
    _positionSubscription = _locationService.startLocationTracking().listen(
      (position) {
        if (state.state == RunState.running && _locationService.isValidPosition(position)) {
          _updatePosition(position);
        }
      },
      onError: (error) {
        // Tratar erro de GPS
      },
    );
  }

  /// Para tracking
  void _stopTracking() {
    _timer?.cancel();
    _timer = null;
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  /// Atualiza posição GPS e recalcula métricas
  void _updatePosition(Position position) {
    final updatedPositions = [...state.positions, position];
    final distance = _locationService.calculateDistance(updatedPositions);
    final pace = _locationService.calculateCurrentPace(
      positions: updatedPositions,
      elapsedSeconds: state.elapsedSeconds,
    );

    state = state.copyWith(
      positions: updatedPositions,
      distanceMeters: distance.round(),
      currentPaceSecondsPerKm: pace,
    );

    // Atualiza banco periodicamente (a cada 10 segundos)
    final now = DateTime.now();
    if (_lastUpdateTime == null ||
        now.difference(_lastUpdateTime!).inSeconds >= 10) {
      _updateRunInDatabase();
      _lastUpdateTime = now;
    }
  }

  /// Atualiza corrida no banco de dados
  Future<void> _updateRunInDatabase() async {
    try {
      await _runService.addMetric(
        _runId,
        metricData: {
          'distance_meters': state.distanceMeters,
          'elapsed_seconds': state.elapsedSeconds,
          'pace_seconds_per_km': state.currentPaceSecondsPerKm,
        },
      );
    } catch (e) {
      // Erro ao atualizar, não crítico
    }
  }

  @override
  void dispose() {
    _stopTracking();
    super.dispose();
  }
}
