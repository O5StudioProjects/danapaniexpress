import 'dart:convert';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:http/http.dart' as http;

class CartDatasource extends BaseRepository {


  /// ADD PRODUCT TO CART AND SAME METHOD USED TO MAKE INCREMENT IN CART
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


  /// ADD PRODUCT TO CART WITH SPECIFIC QUANTITY (ALSO HANDLES INCREMENT IF EXISTS)
  Future<Map<String, dynamic>> addToCartWithQuantityApi({
    required String userId,
    required String productId,
    required int productQty,
  }) async {
    final uri = Uri.parse(APiEndpoints.addToCartWithQuantity);
    final body = {
      'user_id': userId,
      'product_id': productId,
      'product_qty': productQty,
    };

    final response = await http.post(
      uri,
      headers: apiHeaders,
      body: jsonEncode(body),
    );

    return handleApiResponseAsMap(response);
  }

  /// DECREMENT QUANTITY OF PRODUCT IN CART
  Future<Map<String, dynamic>> removeProductQuantityFromCartApi({
    required String userId,
    required String productId,
  }) async {
    final uri = Uri.parse(APiEndpoints.decrementQuantityFromCart);
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

  /// GET CART PRODUCTS LIST BY CURRENT USER
  Future<CartModel?> getCartApi(String userId) async {
    final uri = Uri.parse('${APiEndpoints.getCart}?user_id=$userId');

    final response = await http.get(uri, headers: apiHeaders);
    final decoded = handleApiResponseAsMap(response);

    if (decoded['cart'] != null && decoded['cart'] is List && decoded['cart'].isNotEmpty) {
      return CartModel.fromJson(decoded['cart'][0]);
    }
    return null;
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