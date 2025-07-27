
import 'dart:convert';

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:http/http.dart' as http;

class CartDatasource extends BaseRepository {

  Future<Map<String, dynamic>> addToCartApi({
    required String userId,
    required String productId,
  }) async {
    final uri = Uri.parse(APiEndpoints.addToCart);
    final body = {
      'user_id': userId,
      'product_id': productId,
    };

    final response = await http.post(
      uri,
      headers: apiHeaders,
      body: jsonEncode(body),
    );

    return handleApiResponseAsMap(response);
  }

  Future<Map<String, dynamic>> getCartApi(String userId) async {
    final uri = Uri.parse('${APiEndpoints.getCart}?user_id=$userId');

    final response = await http.get(
      uri,
      headers: apiHeaders,
    );

    return handleApiResponseAsMap(response);
  }

  ///ITEM DELETE FROM CART LIST
  Future<Map<String, dynamic>> deleteCartItemApi({
    required String userId,
    required String productId,
  }) async {
    final uri = Uri.parse(APiEndpoints.deleteCartItem);
    final body = {
      'user_id': userId,
      'product_id': productId,
    };

    final response = await http.post(
      uri,
      headers: apiHeaders,
      body: jsonEncode(body),
    );

    return handleApiResponseAsMap(response);
  }


  /// DELETE ALL ITEMS IN CART- EMPTY CART
  Future<Map<String, dynamic>> emptyCartApi(String userId) async {
    final uri = Uri.parse(APiEndpoints.emptyCart);

    final body = {
      'user_id': userId,
    };

    final response = await http.post(
      uri,
      headers: apiHeaders,
      body: jsonEncode(body),
    );

    return handleApiResponseAsMap(response);
  }


}