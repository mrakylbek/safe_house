import 'dart:convert';

import 'package:safe_house/models/state.dart';

class HouseModel {
  final int? id;
  final String? lat;
  final String? let;
  final String? address;
  final StateModel states;
  HouseModel({
    this.id,
    this.lat,
    this.let,
    this.address,
    required this.states,
  });

  HouseModel copyWith({
    int? id,
    String? lat,
    String? let,
    String? address,
    StateModel? states,
  }) {
    return HouseModel(
      id: id ?? this.id,
      lat: lat ?? this.lat,
      let: let ?? this.let,
      address: address ?? this.address,
      states: states ?? this.states,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lat': lat,
      'let': let,
      'address': address,
      'states': states.toMap(),
    };
  }

  factory HouseModel.fromMap(Map<String, dynamic> map) {
    return HouseModel(
      id: map['id']?.toInt(),
      lat: map['lat'],
      let: map['let'],
      address: map['address'],
      states: StateModel.fromMap(map['states']),
    );
  }

  String toJson() => json.encode(toMap());

  factory HouseModel.fromJson(String source) =>
      HouseModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HouseModel(id: $id, lat: $lat, let: $let, address: $address, states: $states)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HouseModel &&
        other.id == id &&
        other.lat == lat &&
        other.let == let &&
        other.address == address &&
        other.states == states;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        lat.hashCode ^
        let.hashCode ^
        address.hashCode ^
        states.hashCode;
  }
}
