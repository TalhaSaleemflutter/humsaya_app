import 'dart:convert';
import 'package:flutter/material.dart';

class CategoryModel {
  final String categoryId;
  final String title;
  final IconData icon;
  final Color color;

  CategoryModel({
    required this.categoryId,
    required this.title,
    required this.icon,
    required this.color, 
  });

  CategoryModel copyWith({
    String? categoryId,
    String? title,
    IconData? icon,
    Color? color,
  }) {
    return CategoryModel(
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'title': title,
      'icon': icon.codePoint, // Storing icon as codePoint
      'color': color.value, // Storing color as integer value
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryId: map['categoryId'] ?? '',
      title: map['title'] ?? '',
      icon: IconData(map['icon'] ?? 0, fontFamily: 'MaterialIcons'),
      color: Color(map['color'] ?? 0xFFFFFFFF), // Default to white if null
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String jsonStr) {
    final data = json.decode(jsonStr);
    return CategoryModel.fromMap(data);
  }
}
