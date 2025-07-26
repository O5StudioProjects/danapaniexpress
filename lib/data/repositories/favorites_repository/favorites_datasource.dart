
import 'dart:convert';

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:http/http.dart' as http;
class FavoritesDatasource extends BaseRepository {

  /// GET FAVORITES BY USER ID - Returns only List<ProductModel>
  ///
  Future<List<ProductModel>> getFavoritesApi(String userId) async {
    final uri = Uri.parse('${APiEndpoints.getFavorites}?user_id=$userId');

    final response = await http.get(uri, headers: apiHeaders);
    final data = handleApiResponseAsMap(response);

    final favoritesList = data['favorites'] as List<dynamic>;

    if (favoritesList.isEmpty) return [];

    final products = favoritesList[0]['products'] as List<dynamic>;

    return products
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }


  /// TOGGLE FAVORITE (Add/Remove)
  Future<Map<String, dynamic>> toggleFavoriteApi({
    required String userId,
    required String productId,
  }) async {
    final uri = Uri.parse(APiEndpoints.toggleFavorite);

    final response = await http.post(
      uri,
      headers: apiHeaders,
      body: jsonEncode({
        "user_id": userId,
        "product_id": productId,
      }),
    );

    return handleApiResponseAsMap(response);
  }

}