

import 'dart:convert';

import 'package:danapaniexpress/core/data_model_imports.dart';

import '../../../core/common_imports.dart';

class ProductsRepository extends ProductsDatasource {

  /// GET POPULAR PRODUCTS WITH PAGINATION - REPO
  Future<List<ProductModel>> getPopularProductsPaginated({int page = 1, int limit = 10}) async {
    return await getPopularProductsPaginatedApi(page: page, limit: limit);
  }


  Future<List<ProductModel>> getProductsByCategoryPaginated({
    required String category,
    int page = 1,
    int limit = 10,
  }) async {
    return await getProductsByCategoryPaginatedApi(
      category: category,
      page: page,
      limit: limit,
    );
  }

  Future<List<ProductModel>> getProductsByCategoryAndSubCategoryPaginated({
    required String category,
    required String subCategory,
    int page = 1,
    int limit = 10,
  }) async {
    return await getProductsByCategoryAndSubCategoryPaginatedApi(
      category: category,
      subCategory: subCategory,
      page: page,
      limit: limit,
    );
  }




  /// Fetch Single Product
  Future<ProductModel?> fetchSingleProductById(String id) async {
    try {
      String jsonString = await rootBundle.loadString(jsonProducts);
      List<dynamic> jsonData = json.decode(jsonString);

      final matched = jsonData.firstWhere(
            (item) => item[ProductFields.productId].toString() == id,
      );

      return ProductModel.fromJson(matched);
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching product with id $id: $e");
      }
      return null;
    }
  }
}