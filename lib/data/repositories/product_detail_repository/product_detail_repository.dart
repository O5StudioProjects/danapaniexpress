import 'dart:convert';

import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/data/repositories/product_detail_repository/product_detail_datasource.dart';

import '../../../core/common_imports.dart';

class ProductDetailRepository extends ProductDetailDatasource{


  /// TOGGLE FAVORITE (Add/Remove) - REPO
  Future<Map<String, dynamic>> toggleFavorite({
    required String userId,
    required String productId,
  }) async {
    return await toggleFavoriteApi(userId: userId, productId: productId);
  }



  /// FETCH RELATED PRODUCTS
  Future<List<ProductModel>> fetchRelatedProducts({
    required String categoryId,
    required String subCategoryId,
    int limit = 10,
  }) async {
    try {
      String jsonString = await rootBundle.loadString(jsonProducts);
      List<dynamic> jsonData = json.decode(jsonString);

      List<ProductModel> filtered = jsonData
          .map((item) => ProductModel.fromJson(item))
          .where((product) =>
      product.productCategory == categoryId &&
          product.productSubCategory == subCategoryId)
          .take(limit) // ✅ Only take 10 related products
          .toList();

      return filtered;
    } catch (e) {
      if (kDebugMode) {
        print("Error loading related products: $e");
      }
      return [];
    }
  }


  Future<List<ProductModel>> fetchProductsListEvent({
    required ProductFilterType filterType,
    required int limit,
    required int offset, // add this
  }) async {
    String jsonString = await rootBundle.loadString(jsonProducts);
    List<dynamic> jsonData = json.decode(jsonString);

    Iterable filtered = jsonData;

    // Apply filter
    switch (filterType) {
      case ProductFilterType.featured:
        filtered = jsonData.where((item) => item[ProductFields.productIsFeatured] == true);
        break;
      case ProductFilterType.flashSale:
        filtered = jsonData.where((item) => item[ProductFields.productIsFlashsale] == true);
        break;
      case ProductFilterType.all:
      case ProductFilterType.popular:
        filtered = jsonData;
        break;
    }

    List<ProductModel> result = filtered
        .map((item) => ProductModel.fromJson(item))
        .toList();

    // ✅ Apply offset and limit
    final paginated = result.skip(offset).take(limit).toList();

    return paginated;
  }


//   Future<void> fetchProductsByCategoriesEvent(
//   RxList<ProductModel> productsList,
//   Rx<ProductsByCatStatus> status,
//   {required CategoryModel categoryData, int subCategoryIndex = 0}
//
// ) async {
//     try {
//       status.value = ProductsByCatStatus.LOADING;
//       String jsonString = await rootBundle.loadString(jsonProducts);
//       // ✅ Get subCategory ID from index
//       final subCategoryId = categoryData.subCategories![subCategoryIndex].subCategoryId;
//
//       List<dynamic> jsonData = json.decode(jsonString);
//
//       List<ProductModel> value = jsonData
//           .map((item) => ProductModel.fromJson(item))
//           .where((product) =>
//           product.productCategory == categoryData.categoryId &&
//           product.productSubCategory == subCategoryId)
//           .toList();
//
//       productsList.assignAll(value);
//       status.value = ProductsByCatStatus.SUCCESS;
//       if (kDebugMode) {
//         print("Products Fetched");
//       }
//     } catch (e) {
//       status.value = ProductsByCatStatus.FAILURE;
//       if (kDebugMode) {
//         print("Error loading Products: $e");
//       }
//     }
//   }
}
