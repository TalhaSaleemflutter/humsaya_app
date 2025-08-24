import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'ad_product_model.g.dart';

@HiveType(typeId: 1)
class AdModel {
  @HiveField(0)
  String uid;

  @HiveField(1)
  String addId;

  @HiveField(2)
  String title;

  @HiveField(3)
  String description;

  @HiveField(4)
  double price;

  @HiveField(5)
  String condition;

  @HiveField(6)
  String location;

  @HiveField(7)
  List<String> listOfImages;

  @HiveField(8)
  String brandName;

  @HiveField(9)
  DateTime createdAt;

  @HiveField(10)
  bool isActive;

  @HiveField(11)
  String categoryId;

  @HiveField(12)
  String servicePaymentType;

  @HiveField(13)
  String websiteUrl;

  @HiveField(14)
  double discountPrice;

  @HiveField(15) 
  bool isSold;

  AdModel({
    required this.uid,
    required this.addId,
    required this.title,
    required this.description,
    required this.price,
    required this.condition,
    required this.location,
    required this.listOfImages,
    required this.brandName,
    required this.createdAt,
    required this.isActive,
    required this.categoryId,
    required this.servicePaymentType,
    required this.websiteUrl,
    required this.discountPrice,
    this.isSold = false, 
  });

  AdModel copyWith({
    String? uid,
    String? addId,
    String? title,
    String? description,
    double? price,
    String? condition,
    String? location,
    List<String>? listOfImages,
    String? brandName,
    DateTime? createdAt,
    bool? isActive,
    String? categoryId,
    String? servicePaymentType,
    String? websiteUrl,
    double? discountPrice,
    bool? isSold, 
  }) {
    return AdModel(
      uid: uid ?? this.uid,
      addId: addId ?? this.addId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      condition: condition ?? this.condition,
      location: location ?? this.location,
      listOfImages: listOfImages ?? this.listOfImages,
      brandName: brandName ?? this.brandName,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      categoryId: categoryId ?? this.categoryId,
      servicePaymentType: servicePaymentType ?? this.servicePaymentType,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      discountPrice: discountPrice ?? this.discountPrice,
      isSold: isSold ?? this.isSold, // Added to copyWith
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'addId': addId,
      'title': title,
      'description': description,
      'price': price,
      'condition': condition,
      'location': location,
      'listOfImages': listOfImages,
      'brandName': brandName,
      'createdAt': createdAt,
      'isActive': isActive,
      'categoryId': categoryId,
      'servicePaymentType': servicePaymentType,
      'websiteUrl': websiteUrl,
      'discountPrice': discountPrice,
      'isSold': isSold, 
    };
  }

  factory AdModel.fromMap(Map<String, dynamic> map) {
    return AdModel(
      uid: map['uid'] ?? '',
      addId: map['addId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? 0.0,
      condition: map['condition'] ?? '',
      location: map['location'] ?? '',
      listOfImages: List<String>.from(map['listOfImages'] ?? []),
      brandName: map['brandName'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: map['isActive'] ?? false,
      categoryId: map['categoryId'] ?? '',
      servicePaymentType: map['servicePaymentType'] ?? '',
      websiteUrl: map['websiteUrl'] ?? '',
      discountPrice: map['discountPrice'] ?? 0.0,
      isSold: map['isSold'] ?? false, // Added to fromMap
    );
  }

  factory AdModel.fromJson(String jsonStr) {
    final data = json.decode(jsonStr);
    return AdModel.fromMap(data);
  }
}
