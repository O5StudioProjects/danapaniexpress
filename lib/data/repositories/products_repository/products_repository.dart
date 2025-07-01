import 'dart:convert';

import 'package:danapaniexpress/core/data_model_imports.dart';

import '../../../core/common_imports.dart';

class ProductRepository {

  Future<void> fetchProductsByCategoriesEvent(
  RxList<ProductsModel> productsList,
  Rx<ProductsByCatStatus> status,
  {required CategoryModel categoryData, int subCategoryIndex = 0}

) async {
    try {
      status.value = ProductsByCatStatus.LOADING;
      String jsonString = await rootBundle.loadString(jsonProducts);
      // ✅ Get subCategory ID from index
      final subCategoryId = categoryData.subCategories![subCategoryIndex].subCategoryId;

      List<dynamic> jsonData = json.decode(jsonString);

      List<ProductsModel> value = jsonData
          .map((item) => ProductsModel.fromJson(item))
          .where((product) =>
          product.productCategory == categoryData.categoryId &&
          product.productSubCategory == subCategoryId)
          .toList();

      productsList.assignAll(value);
      status.value = ProductsByCatStatus.SUCCESS;
      if (kDebugMode) {
        print("Products Fetched");
      }
    } catch (e) {
      status.value = ProductsByCatStatus.FAILURE;
      if (kDebugMode) {
        print("Error loading Products: $e");
      }
    }
  }
}
