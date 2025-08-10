
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/data/models/products_model.dart';
import 'package:http/http.dart' as http;

class SearchDatasource extends BaseRepository{

  /// SEARCH PRODUCTS API (Only products list)
  Future<List<ProductModel>> searchProductsApi({
    required String search,
    int page = 1,
    int limit = 10,
  }) async {
    final uri = Uri.parse(
      '${APiEndpoints.searchProducts}?search=${Uri.encodeQueryComponent(search)}&page=$page&limit=$limit',
    );

    final response = await http.get(uri, headers: apiHeaders);
    final data = handleApiResponseAsMap(response);

    final List<dynamic> productsList = data['products'] ?? [];

    return productsList
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

}