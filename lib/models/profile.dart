import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:safe_house/models/house.dart';

class ProfileModel {
  final int? id;
  final String? name;
  final String? surname;
  final String? patronymic;
  final String? username;
  final String? email;
  final String? notification;
  final List<HouseModel> houses;
  ProfileModel({
    this.id,
    this.name,
    this.surname,
    this.patronymic,
    this.username,
    this.email,
    this.notification,
    required this.houses,
  });
  // final List? houses;

  ProfileModel copyWith({
    int? id,
    String? name,
    String? surname,
    String? patronymic,
    String? username,
    String? email,
    String? notification,
    List<HouseModel>? houses,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      patronymic: patronymic ?? this.patronymic,
      username: username ?? this.username,
      email: email ?? this.email,
      notification: notification ?? this.notification,
      houses: houses ?? this.houses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'patronymic': patronymic,
      'username': username,
      'email': email,
      'notification': notification,
      'houses': houses.map((x) => x.toMap()).toList(),
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      surname: map['surname'] ?? '',
      patronymic: map['patronymic'] ?? '',
      username: map['username'] ?? '-',
      email: map['email'] ?? '-',
      notification: map['notification'],
      houses: List<HouseModel>.from(
          map['houses']?.map((x) => HouseModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProfileModel(id: $id, name: $name, surname: $surname, patronymic: $patronymic, username: $username, email: $email, notification: $notification, houses: $houses)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileModel &&
        other.id == id &&
        other.name == name &&
        other.surname == surname &&
        other.patronymic == patronymic &&
        other.username == username &&
        other.email == email &&
        other.notification == notification &&
        listEquals(other.houses, houses);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        surname.hashCode ^
        patronymic.hashCode ^
        username.hashCode ^
        email.hashCode ^
        notification.hashCode ^
        houses.hashCode;
  }
}
