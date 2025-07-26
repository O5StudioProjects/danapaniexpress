import 'package:danapaniexpress/core/data_model_imports.dart';
import '../../../core/common_imports.dart';

class ProductsRepository extends ProductsDatasource {

  /// GET POPULAR PRODUCTS WITH PAGINATION - REPO
  Future<List<ProductModel>> getPopularProductsPaginated({int page = 1, int limit = 10}) async {
    return await getPopularProductsPaginatedApi(page: page, limit: limit);
  }
  /// GET FEATURED PRODUCTS WITH PAGINATION - REPO
  Future<List<ProductModel>> getFeaturedProductsPaginated({int page = 1, int limit = 10}) async {
    return await getFeaturedProductsPaginatedApi(page: page, limit: limit);
  }
  /// GET FLASH SALE PRODUCTS WITH PAGINATION - REPO
  Future<List<ProductModel>> getFlashsaleProductsPaginated({int page = 1, int limit = 10}) async {
    return await getFlashsaleProductsPaginatedApi(page: page, limit: limit);
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

  /// GET SINGLE PRODUCT BY ID - REPO
  Future<ProductModel> getSingleProduct({required String productId}) async {
    return await getSingleProductApi(productId: productId);
  }



}