/// Model para a tabela competitions
class Competition {
  final String id;
  final String title;
  final String? subtitle;
  final String? locationName;
  final DateTime startsAt;
  final DateTime? registrationStartsAt;
  final DateTime? registrationEndsAt;
  final CompetitionMode mode;
  final CompetitionStatus status;
  final bool isFree;
  final String? coverImageUrl;
  final String? description;
  final String? prizeDescription;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Metadados agregados (opcional, vindo de views)
  final int? registrationCount;
  final int? confirmedRegistrationsCount;
  final bool? userIsRegistered;

  Competition({
    required this.id,
    required this.title,
    this.subtitle,
    this.locationName,
    required this.startsAt,
    this.registrationStartsAt,
    this.registrationEndsAt,
    required this.mode,
    required this.status,
    required this.isFree,
    this.coverImageUrl,
    this.description,
    this.prizeDescription,
    required this.createdAt,
    required this.updatedAt,
    this.registrationCount,
    this.confirmedRegistrationsCount,
    this.userIsRegistered,
  });

  factory Competition.fromJson(Map<String, dynamic> json) {
    return Competition(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      locationName: json['location_name'] as String?,
      startsAt: DateTime.parse(json['starts_at'] as String),
      registrationStartsAt: json['registration_starts_at'] != null
          ? DateTime.parse(json['registration_starts_at'] as String)
          : null,
      registrationEndsAt: json['registration_ends_at'] != null
          ? DateTime.parse(json['registration_ends_at'] as String)
          : null,
      mode: CompetitionMode.fromString(json['mode'] as String),
      status: CompetitionStatus.fromString(json['status'] as String),
      isFree: json['is_free'] as bool? ?? false,
      coverImageUrl: json['cover_image_url'] as String?,
      description: json['description'] as String?,
      prizeDescription: json['prize_description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      registrationCount: json['registration_count'] as int?,
      confirmedRegistrationsCount: json['confirmed_registrations_count'] as int?,
      userIsRegistered: json['user_is_registered'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'location_name': locationName,
      'starts_at': startsAt.toIso8601String(),
      'registration_starts_at': registrationStartsAt?.toIso8601String(),
      'registration_ends_at': registrationEndsAt?.toIso8601String(),
      'mode': mode.value,
      'status': status.value,
      'is_free': isFree,
      'cover_image_url': coverImageUrl,
      'description': description,
      'prize_description': prizeDescription,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Competition copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? locationName,
    DateTime? startsAt,
    DateTime? registrationStartsAt,
    DateTime? registrationEndsAt,
    CompetitionMode? mode,
    CompetitionStatus? status,
    bool? isFree,
    String? coverImageUrl,
    String? description,
    String? prizeDescription,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? registrationCount,
    int? confirmedRegistrationsCount,
    bool? userIsRegistered,
  }) {
    return Competition(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      locationName: locationName ?? this.locationName,
      startsAt: startsAt ?? this.startsAt,
      registrationStartsAt: registrationStartsAt ?? this.registrationStartsAt,
      registrationEndsAt: registrationEndsAt ?? this.registrationEndsAt,
      mode: mode ?? this.mode,
      status: status ?? this.status,
      isFree: isFree ?? this.isFree,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      description: description ?? this.description,
      prizeDescription: prizeDescription ?? this.prizeDescription,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      registrationCount: registrationCount ?? this.registrationCount,
      confirmedRegistrationsCount:
          confirmedRegistrationsCount ?? this.confirmedRegistrationsCount,
      userIsRegistered: userIsRegistered ?? this.userIsRegistered,
    );
  }
}

/// Enum para o modo da competição
enum CompetitionMode {
  indoor('indoor'),
  outdoor('outdoor');

  final String value;

  const CompetitionMode(this.value);

  static CompetitionMode fromString(String value) {
    return CompetitionMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CompetitionMode.outdoor,
    );
  }
}

/// Enum para o status da competição
enum CompetitionStatus {
  draft('draft'),
  open('open'),
  closed('closed'),
  inProgress('in_progress'),
  finished('finished');

  final String value;

  const CompetitionStatus(this.value);

  static CompetitionStatus fromString(String value) {
    return CompetitionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CompetitionStatus.draft,
    );
  }
}

/// Model para competition_distances
class CompetitionDistance {
  final String id;
  final String competitionId;
  final String label;
  final int meters;
  final int sortOrder;

  CompetitionDistance({
    required this.id,
    required this.competitionId,
    required this.label,
    required this.meters,
    required this.sortOrder,
  });

  factory CompetitionDistance.fromJson(Map<String, dynamic> json) {
    return CompetitionDistance(
      id: json['id'] as String,
      competitionId: json['competition_id'] as String,
      label: json['label'] as String,
      meters: json['meters'] as int,
      sortOrder: json['sort_order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'competition_id': competitionId,
      'label': label,
      'meters': meters,
      'sort_order': sortOrder,
    };
  }
}

/// Model para competition_lots
class CompetitionLot {
  final String id;
  final String competitionId;
  final String name;
  final String? description;
  final int priceCents;
  final String currency;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final bool isSubscriptionAllowed;
  final bool isActive;
  final int sortOrder;

  CompetitionLot({
    required this.id,
    required this.competitionId,
    required this.name,
    this.description,
    required this.priceCents,
    this.currency = 'BRL',
    this.startsAt,
    this.endsAt,
    this.isSubscriptionAllowed = false,
    this.isActive = true,
    required this.sortOrder,
  });

  factory CompetitionLot.fromJson(Map<String, dynamic> json) {
    return CompetitionLot(
      id: json['id'] as String,
      competitionId: json['competition_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      priceCents: json['price_cents'] as int,
      currency: json['currency'] as String? ?? 'BRL',
      startsAt: json['starts_at'] != null
          ? DateTime.parse(json['starts_at'] as String)
          : null,
      endsAt: json['ends_at'] != null
          ? DateTime.parse(json['ends_at'] as String)
          : null,
      isSubscriptionAllowed: json['is_subscription_allowed'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: json['sort_order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'competition_id': competitionId,
      'name': name,
      'description': description,
      'price_cents': priceCents,
      'currency': currency,
      'starts_at': startsAt?.toIso8601String(),
      'ends_at': endsAt?.toIso8601String(),
      'is_subscription_allowed': isSubscriptionAllowed,
      'is_active': isActive,
      'sort_order': sortOrder,
    };
  }

  /// Retorna o preço formatado (ex: R$ 120,00)
  String get formattedPrice {
    final value = priceCents / 100;
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Verifica se o lote está disponível no momento
  bool get isAvailable {
    if (!isActive) return false;
    final now = DateTime.now();
    if (startsAt != null && now.isBefore(startsAt!)) return false;
    if (endsAt != null && now.isAfter(endsAt!)) return false;
    return true;
  }
}

/// Model para competition_sponsors
class CompetitionSponsor {
  final String id;
  final String competitionId;
  final String name;
  final String? logoUrl;
  final int sortOrder;

  CompetitionSponsor({
    required this.id,
    required this.competitionId,
    required this.name,
    this.logoUrl,
    required this.sortOrder,
  });

  factory CompetitionSponsor.fromJson(Map<String, dynamic> json) {
    return CompetitionSponsor(
      id: json['id'] as String,
      competitionId: json['competition_id'] as String,
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String?,
      sortOrder: json['sort_order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'competition_id': competitionId,
      'name': name,
      'logo_url': logoUrl,
      'sort_order': sortOrder,
    };
  }
}

/// Model para competition_documents
class CompetitionDocument {
  final String id;
  final String competitionId;
  final String title;
  final String fileUrl;
  final int sortOrder;

  CompetitionDocument({
    required this.id,
    required this.competitionId,
    required this.title,
    required this.fileUrl,
    required this.sortOrder,
  });

  factory CompetitionDocument.fromJson(Map<String, dynamic> json) {
    return CompetitionDocument(
      id: json['id'] as String,
      competitionId: json['competition_id'] as String,
      title: json['title'] as String,
      fileUrl: json['file_url'] as String,
      sortOrder: json['sort_order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'competition_id': competitionId,
      'title': title,
      'file_url': fileUrl,
      'sort_order': sortOrder,
    };
  }
}

/// Model para competition_registrations
class CompetitionRegistration {
  final String id;
  final String competitionId;
  final String userId;
  final String? distanceId;
  final String? lotId;
  final RegistrationStatus status;
  final bool acceptedTerms;
  final DateTime createdAt;

  CompetitionRegistration({
    required this.id,
    required this.competitionId,
    required this.userId,
    this.distanceId,
    this.lotId,
    required this.status,
    required this.acceptedTerms,
    required this.createdAt,
  });

  factory CompetitionRegistration.fromJson(Map<String, dynamic> json) {
    return CompetitionRegistration(
      id: json['id'] as String,
      competitionId: json['competition_id'] as String,
      userId: json['user_id'] as String,
      distanceId: json['distance_id'] as String?,
      lotId: json['lot_id'] as String?,
      status: RegistrationStatus.fromString(json['status'] as String),
      acceptedTerms: json['accepted_terms'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'competition_id': competitionId,
      'user_id': userId,
      'distance_id': distanceId,
      'lot_id': lotId,
      'status': status.value,
      'accepted_terms': acceptedTerms,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Enum para o status da inscrição
enum RegistrationStatus {
  pending('pending'),
  confirmed('confirmed'),
  cancelled('cancelled');

  final String value;

  const RegistrationStatus(this.value);

  static RegistrationStatus fromString(String value) {
    return RegistrationStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RegistrationStatus.pending,
    );
  }
}
