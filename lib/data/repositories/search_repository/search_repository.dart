
import 'package:danapaniexpress/data/models/products_model.dart';
import 'package:danapaniexpress/data/repositories/search_repository/search_datasource.dart';

class SearchRepository extends SearchDatasource{

  Future<List<ProductModel>> searchProducts({
    required String search,
    int page = 1,
    int limit = 10,
  }) async {
    final result = await searchProductsApi(
      search: search,
      page: page,
      limit: limit,
    );
    return result;
  }

}