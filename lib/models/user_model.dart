import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:humsaya_app/models/location_model.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  String uid;

  @HiveField(1)
  String name;

  @HiveField(2)
  String phoneNo;

  @HiveField(3)
  String email;

  @HiveField(4)
  String password;

  @HiveField(5)
  LocationModel? location;

  @HiveField(6)
  bool isActive = true;

  @HiveField(7)
  String? profileImage;

  @HiveField(8)
  String? gender;

  @HiveField(9)
  DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.phoneNo,
    required this.email,
    required this.password,
    required this.location,
    required this.isActive,
    required this.profileImage,
    required this.gender,
    required this.createdAt, // Added to constructor
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? phoneNo,
    String? email,
    String? password,
    LocationModel? location,
    bool? isActive,
    String? profileImage,
    String? gender,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      phoneNo: phoneNo ?? this.phoneNo,
      email: email ?? this.email,
      password: password ?? this.password,
      location: location ?? this.location,
      isActive: isActive ?? this.isActive,
      profileImage: profileImage ?? this.profileImage,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phoneNo': phoneNo,
      'email': email,
      'password': password,
      'location': location?.toMap(),
      'isActive': isActive,
      'profileImage': profileImage,
      'gender': gender,
      'createdAt': createdAt.toIso8601String(), // Convert DateTime to String
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      phoneNo: map['phoneNo'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      location:
          map['location'] != null
              ? LocationModel.fromMap(map['location'])
              : null,
      isActive: map['isActive'] ?? false,
      profileImage: map['profileImage'],
      gender: map['gender'],
      createdAt:
          map['createdAt'] != null
              ? DateTime.parse(map['createdAt'])
              : DateTime.now(), // Default to current time if not provided
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String jsonStr) {
    final data = json.decode(jsonStr);
    return UserModel.fromMap(data);
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, phoneNo: $phoneNo, email: $email, password: $password, location: $location, isActive: $isActive, profileImage: $profileImage, gender: $gender, createdAt: $createdAt)';
  }
}
