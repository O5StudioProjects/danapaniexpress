import 'dart:convert';

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/data/repositories/categories_repository/categories_datasource.dart';

class CategoriesRepository extends CategoriesDatasource{

  /// GET CATEGORIES DATA - API
  Future<List<CategoryModel>> getCategories() async {
    return await getCategoriesDataApi();
  }


  /// SINGLE CATEGORY
  Future<CategoryModel?> getSingleCategory({
    required String categoryId,
  }) async {
    return await getCategoryByIDApi(categoryId);
  }
}