import 'dart:convert';

import 'package:danapaniexpress/core/data_model_imports.dart';

import '../../../core/common_imports.dart';

class ProductRepository {

  /// FETCH RELATED PRODUCTS
  Future<List<ProductsModel>> fetchRelatedProducts({
    required String categoryId,
    required String subCategoryId,
    int limit = 10,
  }) async {
    try {
      String jsonString = await rootBundle.loadString(jsonProducts);
      List<dynamic> jsonData = json.decode(jsonString);

      List<ProductsModel> filtered = jsonData
          .map((item) => ProductsModel.fromJson(item))
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


  ///FETCH PRODUCTS BY CATEGORIES
  Future<List<ProductsModel>> fetchProductsByCategoriesEvent({
    required CategoryModel categoryData,
    int subCategoryIndex = 0,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      String jsonString = await rootBundle.loadString(jsonProducts);
      final subCategoryId = categoryData.subCategories![subCategoryIndex].subCategoryId;

      List<dynamic> jsonData = json.decode(jsonString);

      List<ProductsModel> allFiltered = jsonData
          .map((item) => ProductsModel.fromJson(item))
          .where((product) =>
      product.productCategory == categoryData.categoryId &&
          product.productSubCategory == subCategoryId)
          .toList();

      // ✅ Paginate
      final paginated = allFiltered.skip(offset).take(limit).toList();

      return paginated;
    } catch (e) {
      if (kDebugMode) {
        print("Error loading Products: $e");
      }
      return [];
    }
  }

  Future<List<ProductsModel>> fetchProductsListEvent({
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
        filtered = jsonData.where((item) => item[ProductsFields.productIsFeatured] == true);
        break;
      case ProductFilterType.flashSale:
        filtered = jsonData.where((item) => item[ProductsFields.productIsFlashsale] == true);
        break;
      case ProductFilterType.all:
      case ProductFilterType.popular:
        filtered = jsonData;
        break;
    }

    List<ProductsModel> result = filtered
        .map((item) => ProductsModel.fromJson(item))
        .toList();

    // ✅ Apply offset and limit
    final paginated = result.skip(offset).take(limit).toList();

    return paginated;
  }


//   Future<void> fetchProductsByCategoriesEvent(
//   RxList<ProductsModel> productsList,
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
//       List<ProductsModel> value = jsonData
//           .map((item) => ProductsModel.fromJson(item))
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
