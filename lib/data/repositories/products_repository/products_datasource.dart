import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:http/http.dart' as http;

class ProductsDatasource extends BaseRepository {

  ///GET POPULAR PRODUCTS API
  Future<List<ProductModel>> getPopularProductsPaginatedApi({int page = 1, int limit = 10}) async {
    final uri = Uri.parse('${APiEndpoints.getPopularProducts}?page=$page&limit=$limit');
    final response = await http.get(uri, headers: apiHeaders);
    final data = handleApiResponseAsMap(response); // 🔄 was: handleApiResponseAsList
    final List<dynamic> list = data['data']; // 🔍 Extract the actual product list
    return list
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  ///GET FEATURED PRODUCTS API
  Future<List<ProductModel>> getFeaturedProductsPaginatedApi({int page = 1, int limit = 10}) async {
    final uri = Uri.parse('${APiEndpoints.getFeaturedProducts}?page=$page&limit=$limit');
    final response = await http.get(uri, headers: apiHeaders);
    final data = handleApiResponseAsMap(response);
    final List<dynamic> featuredList = data['featured_products'];
    return featuredList
        .map((item) => ProductModel.fromJson(item['product'] as Map<String, dynamic>))
        .toList();
  }

  ///GET FLASH SALE PRODUCTS API
  Future<List<ProductModel>> getFlashsaleProductsPaginatedApi({int page = 1, int limit = 10}) async {
    final uri = Uri.parse('${APiEndpoints.getFlashSaleProducts}?page=$page&limit=$limit');
    final response = await http.get(uri, headers: apiHeaders);
    final data = handleApiResponseAsMap(response); // Ensures top-level keys like 'flashsale_products'
    final List<dynamic> flashsaleList = data['flashsale_products'];
    return flashsaleList
        .map((item) => ProductModel.fromJson(item['product'] as Map<String, dynamic>))
        .toList();
  }



  /// GET PRODUCTS BY CATEGORY ONLY (Paginated)
  Future<List<ProductModel>> getProductsByCategoryPaginatedApi({
    required String category,
    int page = 1,
    int limit = 10,
  }) async {
    final uri = Uri.parse(
      '${APiEndpoints.getProductsByCategories}?category=$category&page=$page&limit=$limit',
    );
    final response = await http.get(uri, headers: apiHeaders);
    final data = handleApiResponseAsMap(response);
    final List<dynamic> list = data['data']; // Extract product list
    return list
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// GET PRODUCTS BY CATEGORY + SUBCATEGORY (Paginated)
  Future<List<ProductModel>> getProductsByCategoryAndSubCategoryPaginatedApi({
    required String category,
    required String subCategory,
    int page = 1,
    int limit = 10,
  }) async {
    final uri = Uri.parse(
      '${APiEndpoints.getProductsByCategoriesAndSubCategories}?category=$category&sub_category=$subCategory&page=$page&limit=$limit',
    );
    final response = await http.get(uri, headers: apiHeaders);
    final data = handleApiResponseAsMap(response);
    final List<dynamic> list = data['data']; // Extract product list
    return list
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// GET SINGLE PRODUCT BY ID
  Future<ProductModel> getSingleProductApi({required String productId}) async {
    final uri = Uri.parse('${APiEndpoints.getSingleProduct}?product_id=$productId');
    final response = await http.get(uri, headers: apiHeaders);
    final data = handleApiResponseAsMap(response); // handle the top-level JSON
    final Map<String, dynamic> productJson = data['data'];
    return ProductModel.fromJson(productJson);
  }



}