import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:humsaya_app/models/category_model.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';

class CategoryProvider extends ChangeNotifier {
  final List<CategoryModel> _categoriesList = [
    CategoryModel(
      categoryId: '1',
      title: 'Buy',
      icon: Icons.shopping_cart,
      color: blue,
    ),
    CategoryModel(
      categoryId: '2',
      title: 'Services',
      icon: Icons.build,
      color: teal,
    ),
    CategoryModel(
      categoryId: '3',
      title: 'Businesses',
      icon: Icons.local_shipping,
      color: amber,
    ),
    CategoryModel(
      categoryId: '4',
      title: 'Grocery',
      icon: Icons.shopping_basket,
      color: deepPurple,
    ),
  ];
  List<CategoryModel> get categories => _categoriesList;

  CategoryModel? getCategoryById(String categoryId) {
    return _categoriesList.firstWhereOrNull(
      (item) => item.categoryId == categoryId,
    );
  }

  // CategoryModel getCategoryById(String categoryId) {
  //   return _categoriesList.firstWhere((item) => item.categoryId == categoryId);
  // }
}
