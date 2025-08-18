import 'dart:convert';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:http/http.dart' as http;

class ProductDetailDatasource extends BaseRepository {

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