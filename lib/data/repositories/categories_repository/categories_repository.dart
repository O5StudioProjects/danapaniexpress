import 'dart:convert';

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class CategoriesRepository {
  /// FETCH CATEGORIES
  Future<void> fetchCategoriesListEvent(
      Rx<CategoriesStatus> status,
      RxList<CategoryModel> categoriesList,
      ) async {
    try {
      status.value = CategoriesStatus.LOADING;
      String jsonString = await rootBundle.loadString(jsonCategories);

      List<dynamic> jsonData = json.decode(jsonString);
      List<CategoryModel> value = jsonData
          .map((item) => CategoryModel.fromJson(item))
          .toList();

      categoriesList.assignAll(value);
      status.value = CategoriesStatus.SUCCESS;
      if (kDebugMode) {
        print("Categories Fetched");
      }
    } catch (e) {
      status.value = CategoriesStatus.FAILURE;
      if (kDebugMode) {
        print("Error loading categories: $e");
      }
    }
  }

  /// SINGLE CATEGORY
  Future<void> fetchSingleCategoryEvent({
    required String categoryId,
    required Rx<CategoryModel?> categoryData,
    required Rx<CategoriesStatus> status,
  }) async {
    try {
      status.value = CategoriesStatus.LOADING;

      String jsonString = await rootBundle.loadString(jsonCategories);
      List<dynamic> jsonData = json.decode(jsonString);

      // Safely find category by ID
      final category = jsonData
          .map((item) => CategoryModel.fromJson(item))
          .firstWhere(
            (item) => item.categoryId == categoryId,
        orElse: () => CategoryModel(), // or a default empty model
      );

      // Check if match was found (optional, based on your model)
      if (category.categoryId == null || category.categoryId!.isEmpty) {
        categoryData.value = null;
      } else {
        categoryData.value = category;
      }

      status.value = CategoriesStatus.SUCCESS;

      if (kDebugMode) {
        print("Fetched Category: ${category.categoryId}");
      }
    } catch (e) {
      categoryData.value = null;
      status.value = CategoriesStatus.FAILURE;
      if (kDebugMode) {
        print("Error loading category: $e");
      }
    }
  }
}