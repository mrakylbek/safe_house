import 'dart:convert';

class StateModel {
  final SlugModel? gas;
  final SlugModel? water;
  final SlugModel? door;
  final SlugModel? smoke;
  final SlugModel? fire;
  final SlugModel? motion;
  final SlugModel? alarm;

  StateModel({
    this.gas,
    this.water,
    this.door,
    this.smoke,
    this.fire,
    this.motion,
    this.alarm,
  });

  StateModel copyWith({
    SlugModel? gas,
    SlugModel? water,
    SlugModel? door,
    SlugModel? smoke,
    SlugModel? fire,
    SlugModel? motion,
    SlugModel? alarm,
  }) {
    return StateModel(
      gas: gas ?? this.gas,
      water: water ?? this.water,
      door: door ?? this.door,
      smoke: smoke ?? this.smoke,
      fire: fire ?? this.fire,
      motion: motion ?? this.motion,
      alarm: alarm ?? this.alarm,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gas': gas?.toMap(),
      'water': water?.toMap(),
      'door': door?.toMap(),
      'smoke': smoke?.toMap(),
      'fire': fire?.toMap(),
      'motion': motion?.toMap(),
      'alarm': alarm?.toMap(),
    };
  }

  factory StateModel.fromMap(Map<String, dynamic> map) {
    return StateModel(
      gas: map['gas'] != null ? SlugModel.fromMap(map['gas']) : null,
      water: map['water'] != null ? SlugModel.fromMap(map['water']) : null,
      door: map['door'] != null ? SlugModel.fromMap(map['door']) : null,
      smoke: map['smoke'] != null ? SlugModel.fromMap(map['smoke']) : null,
      fire: map['fire'] != null ? SlugModel.fromMap(map['fire']) : null,
      motion: map['motion'] != null ? SlugModel.fromMap(map['motion']) : null,
      alarm: map['alarm'] != null ? SlugModel.fromMap(map['alarm']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StateModel.fromJson(String source) =>
      StateModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StateModel(gas: $gas, water: $water, door: $door, smoke: $smoke, fire: $fire, motion: $motion, alarm: $alarm)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StateModel &&
        other.gas == gas &&
        other.water == water &&
        other.door == door &&
        other.smoke == smoke &&
        other.fire == fire &&
        other.motion == motion &&
        other.alarm == alarm;
  }

  @override
  int get hashCode {
    return gas.hashCode ^
        water.hashCode ^
        door.hashCode ^
        smoke.hashCode ^
        fire.hashCode ^
        motion.hashCode ^
        alarm.hashCode;
  }
}

class SlugModel {
  final String? slug;
  final int? notification_id;
  SlugModel({
    this.slug,
    this.notification_id,
  });

  SlugModel copyWith({
    String? slug,
    int? notification_id,
  }) {
    return SlugModel(
      slug: slug ?? this.slug,
      notification_id: notification_id ?? this.notification_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'slug': slug,
      'notification_id': notification_id,
    };
  }

  factory SlugModel.fromMap(Map<String, dynamic> map) {
    return SlugModel(
      slug: map['slug'],
      notification_id: map['notification_id']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SlugModel.fromJson(String source) =>
      SlugModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'SlugModel(slug: $slug, notification_id: $notification_id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SlugModel &&
        other.slug == slug &&
        other.notification_id == notification_id;
  }

  @override
  int get hashCode => slug.hashCode ^ notification_id.hashCode;
}
