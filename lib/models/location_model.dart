import 'dart:convert';
import 'package:hive/hive.dart';
part 'location_model.g.dart';

@HiveType(typeId: 2)
class LocationModel {
  @HiveField(0)
  final String neighborLocation;

  @HiveField(1)
  final String streetNumber;

  @HiveField(2)
  final String houseAddress;

  @HiveField(3)
  final String city;

  @HiveField(4)
  final String state;

  @HiveField(5)
  final String zipCode;

  @HiveField(6)
  final String country;

  LocationModel({
    required this.neighborLocation,
    required this.streetNumber,
    required this.houseAddress,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  // Add the copyWith method here
  LocationModel copyWith({
    String? neighborLocation,
    String? streetNumber,
    String? houseAddress,
    String? city,
    String? state,
    String? zipCode,
    String? country,
  }) {
    return LocationModel(
      neighborLocation: neighborLocation ?? this.neighborLocation,
      streetNumber: streetNumber ?? this.streetNumber,
      houseAddress: houseAddress ?? this.houseAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'neighborLocation': neighborLocation,
      'streetNumber': streetNumber,
      'houseAddress': houseAddress,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      neighborLocation: map['neighborLocation'] ?? '',
      streetNumber: map['streetNumber'] ?? '',
      houseAddress: map['houseAddress'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zipCode: map['zipCode'] ?? '',
      country: map['country'] ?? '',
    );
  }

  factory LocationModel.fromJson(String jsonStr) {
    final data = json.decode(jsonStr);
    return LocationModel.fromMap(data);
  }

  String toJson() {
    return json.encode(toMap());
  }
}
