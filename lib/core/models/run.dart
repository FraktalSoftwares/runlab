/// Model para a tabela user_runs
class UserRun {
  final String id;
  final String competitionId;
  final String userId;
  final String? registrationId;
  final RunState state;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final int totalTimeSeconds;
  final int distanceMeters;
  final int? avgPaceSecondsPerKm;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserRun({
    required this.id,
    required this.competitionId,
    required this.userId,
    this.registrationId,
    required this.state,
    this.startedAt,
    this.finishedAt,
    this.totalTimeSeconds = 0,
    this.distanceMeters = 0,
    this.avgPaceSecondsPerKm,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserRun.fromJson(Map<String, dynamic> json) {
    return UserRun(
      id: json['id'] as String,
      competitionId: json['competition_id'] as String,
      userId: json['user_id'] as String,
      registrationId: json['registration_id'] as String?,
      state: RunState.fromString(json['state'] as String),
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : null,
      finishedAt: json['finished_at'] != null
          ? DateTime.parse(json['finished_at'] as String)
          : null,
      totalTimeSeconds: json['total_time_seconds'] as int? ?? 0,
      distanceMeters: json['distance_meters'] as int? ?? 0,
      avgPaceSecondsPerKm: json['avg_pace_seconds_per_km'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'competition_id': competitionId,
      'user_id': userId,
      'registration_id': registrationId,
      'state': state.value,
      'started_at': startedAt?.toIso8601String(),
      'finished_at': finishedAt?.toIso8601String(),
      'total_time_seconds': totalTimeSeconds,
      'distance_meters': distanceMeters,
      'avg_pace_seconds_per_km': avgPaceSecondsPerKm,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserRun copyWith({
    String? id,
    String? competitionId,
    String? userId,
    String? registrationId,
    RunState? state,
    DateTime? startedAt,
    DateTime? finishedAt,
    int? totalTimeSeconds,
    int? distanceMeters,
    int? avgPaceSecondsPerKm,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserRun(
      id: id ?? this.id,
      competitionId: competitionId ?? this.competitionId,
      userId: userId ?? this.userId,
      registrationId: registrationId ?? this.registrationId,
      state: state ?? this.state,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      totalTimeSeconds: totalTimeSeconds ?? this.totalTimeSeconds,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      avgPaceSecondsPerKm: avgPaceSecondsPerKm ?? this.avgPaceSecondsPerKm,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Retorna o tempo total formatado (ex: "1h 23m 45s")
  String get formattedTotalTime {
    final hours = totalTimeSeconds ~/ 3600;
    final minutes = (totalTimeSeconds % 3600) ~/ 60;
    final seconds = totalTimeSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Retorna a distância formatada (ex: "5.2 km")
  String get formattedDistance {
    if (distanceMeters >= 1000) {
      return '${(distanceMeters / 1000).toStringAsFixed(1)} km';
    } else {
      return '$distanceMeters m';
    }
  }

  /// Retorna o pace formatado (ex: "5:30 /km")
  String? get formattedPace {
    if (avgPaceSecondsPerKm == null) return null;
    final minutes = avgPaceSecondsPerKm! ~/ 60;
    final seconds = avgPaceSecondsPerKm! % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')} /km';
  }

  /// Verifica se a corrida está em andamento
  bool get isRunning => state == RunState.running;

  /// Verifica se a corrida está pausada
  bool get isPaused => state == RunState.paused;

  /// Verifica se a corrida foi finalizada
  bool get isFinished => state == RunState.finished;

  /// Verifica se a corrida foi abortada
  bool get isAborted => state == RunState.aborted;
}

/// Enum para o estado da corrida
enum RunState {
  ready('ready'),
  running('running'),
  paused('paused'),
  finished('finished'),
  aborted('aborted');

  final String value;

  const RunState(this.value);

  static RunState fromString(String value) {
    return RunState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RunState.ready,
    );
  }
}

/// Model para user_run_events
class UserRunEvent {
  final String id;
  final String runId;
  final String userId;
  final RunEventType type;
  final DateTime happenedAt;
  final Map<String, dynamic> payload;

  UserRunEvent({
    required this.id,
    required this.runId,
    required this.userId,
    required this.type,
    required this.happenedAt,
    this.payload = const {},
  });

  factory UserRunEvent.fromJson(Map<String, dynamic> json) {
    return UserRunEvent(
      id: json['id'] as String,
      runId: json['run_id'] as String,
      userId: json['user_id'] as String,
      type: RunEventType.fromString(json['type'] as String),
      happenedAt: DateTime.parse(json['happened_at'] as String),
      payload: json['payload'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'run_id': runId,
      'user_id': userId,
      'type': type.value,
      'happened_at': happenedAt.toIso8601String(),
      'payload': payload,
    };
  }
}

/// Enum para o tipo de evento
enum RunEventType {
  start('start'),
  pause('pause'),
  resume('resume'),
  finish('finish'),
  metric('metric');

  final String value;

  const RunEventType(this.value);

  static RunEventType fromString(String value) {
    return RunEventType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RunEventType.metric,
    );
  }
}

/// Model para leaderboard entry (vindo da view)
class LeaderboardEntry {
  final String competitionId;
  final String runId;
  final String userId;
  final int distanceMeters;
  final int totalTimeSeconds;
  final int? avgPaceSecondsPerKm;
  final DateTime? finishedAt;
  final int rank;
  final String? userName;
  final String? userAvatarUrl;

  LeaderboardEntry({
    required this.competitionId,
    required this.runId,
    required this.userId,
    required this.distanceMeters,
    required this.totalTimeSeconds,
    this.avgPaceSecondsPerKm,
    this.finishedAt,
    required this.rank,
    this.userName,
    this.userAvatarUrl,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      competitionId: json['competition_id'] as String,
      runId: json['run_id'] as String,
      userId: json['user_id'] as String,
      distanceMeters: json['distance_meters'] as int,
      totalTimeSeconds: json['total_time_seconds'] as int,
      avgPaceSecondsPerKm: json['avg_pace_seconds_per_km'] as int?,
      finishedAt: json['finished_at'] != null
          ? DateTime.parse(json['finished_at'] as String)
          : null,
      rank: json['rank'] as int,
      userName: json['user_name'] as String?,
      userAvatarUrl: json['user_avatar_url'] as String?,
    );
  }

  /// Retorna o tempo total formatado
  String get formattedTotalTime {
    final hours = totalTimeSeconds ~/ 3600;
    final minutes = (totalTimeSeconds % 3600) ~/ 60;
    final seconds = totalTimeSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Retorna o pace formatado
  String? get formattedPace {
    if (avgPaceSecondsPerKm == null) return null;
    final minutes = avgPaceSecondsPerKm! ~/ 60;
    final seconds = avgPaceSecondsPerKm! % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')} /km';
  }
}
