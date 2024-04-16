import 'dart:convert';

import 'package:safe_house/models/house.dart';

class NotificationModel {
  final int id;
  final String? message;
  final HouseModel? house;
  final String? created_at;
  NotificationModel({
    required this.id,
    this.message,
    this.house,
    this.created_at,
  });

  NotificationModel copyWith({
    int? id,
    String? message,
    HouseModel? house,
    String? created_at,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      message: message ?? this.message,
      house: house ?? this.house,
      created_at: created_at ?? this.created_at,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'house': house?.toMap(),
      'created_at': created_at,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id']?.toInt() ?? 0,
      message: map['message'],
      house: map['house'] != null ? HouseModel.fromMap(map['house']) : null,
      created_at: map['created_at'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NotificationModel(id: $id, message: $message, house: $house, created_at: $created_at)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationModel &&
        other.id == id &&
        other.message == message &&
        other.house == house &&
        other.created_at == created_at;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        message.hashCode ^
        house.hashCode ^
        created_at.hashCode;
  }
}
