import 'dart:async';
import 'package:geolocator/geolocator.dart';

/// Serviço para gerenciar localização GPS e tracking de corrida
class LocationService {
  StreamSubscription<Position>? _positionStreamSubscription;
  final List<Position> _positions = [];

  /// Solicita permissão de localização
  Future<bool> requestLocationPermission() async {
    // Verifica se o serviço de localização está habilitado
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Serviço de localização desabilitado
      return false;
    }

    // Verifica permissão
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Inicia tracking contínuo de localização
  Stream<Position> startLocationTracking({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 5, // metros
    int intervalDuration = 2000, // milissegundos
  }) {
    final locationSettings = LocationSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilter,
      timeLimit: Duration(milliseconds: intervalDuration),
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  /// Para o tracking de localização
  void stopLocationTracking() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }

  /// Retorna a posição atual
  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  /// Calcula distância total percorrida entre uma lista de posições
  double calculateDistance(List<Position> positions) {
    if (positions.length < 2) {
      return 0.0;
    }

    double totalDistance = 0.0;
    for (int i = 1; i < positions.length; i++) {
      final distance = Geolocator.distanceBetween(
        positions[i - 1].latitude,
        positions[i - 1].longitude,
        positions[i].latitude,
        positions[i].longitude,
      );
      totalDistance += distance;
    }

    return totalDistance;
  }

  /// Calcula pace atual baseado em distância e tempo
  /// Retorna segundos por km, ou null se não for possível calcular
  int? calculatePace({
    required int distanceMeters,
    required int timeSeconds,
  }) {
    if (distanceMeters <= 0 || timeSeconds <= 0) {
      return null;
    }

    // Pace em segundos por km
    final paceSecondsPerKm = (timeSeconds / distanceMeters) * 1000;
    return paceSecondsPerKm.round();
  }

  /// Calcula pace baseado nas últimas posições (últimos 100m ou 30s)
  int? calculateCurrentPace({
    required List<Position> positions,
    required int elapsedSeconds,
    int minDistanceMeters = 100,
    int timeWindowSeconds = 30,
  }) {
    if (positions.length < 2) {
      return null;
    }

    // Pega posições recentes (últimos 30 segundos ou últimas posições)
    final recentPositions = <Position>[];
    final now = DateTime.now();

    for (int i = positions.length - 1; i >= 0; i--) {
      final position = positions[i];
      final age = now.difference(position.timestamp).inSeconds;
      
      if (age <= timeWindowSeconds) {
        recentPositions.insert(0, position);
      } else {
        break;
      }
    }

    if (recentPositions.length < 2) {
      return null;
    }

    final distance = calculateDistance(recentPositions);
    if (distance < minDistanceMeters) {
      return null;
    }

    // Calcula tempo entre primeira e última posição recente
    final timeDiff = recentPositions.last.timestamp
        .difference(recentPositions.first.timestamp)
        .inSeconds;

    if (timeDiff <= 0) {
      return null;
    }

    return calculatePace(
      distanceMeters: distance.round(),
      timeSeconds: timeDiff,
    );
  }

  /// Verifica se uma posição é válida (precisão aceitável)
  bool isValidPosition(Position position) {
    // Considera válida se precisão horizontal for menor que 50 metros
    return position.accuracy <= 50.0;
  }

  /// Limpa histórico de posições
  void clearPositions() {
    _positions.clear();
  }
}
