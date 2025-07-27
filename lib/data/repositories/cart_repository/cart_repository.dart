import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/data/repositories/cart_repository/cart_datasource.dart';

class CartRepository extends CartDatasource{

  Future<Map<String, dynamic>> addToCart({
    required String userId,
    required String productId,
  }) async {
    return await addToCartApi(
      userId: userId,
      productId: productId,
    );
  }

  Future<List<ProductModel>> getCartProducts(String userId) async {
    try {
      final response = await getCartApi(userId);

      if (response.containsKey('cart') && response['cart'] is List && response['cart'].isNotEmpty) {
        final productsJson = response['cart'][0]['products'] as List;
        return productsJson.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE CART ITEM
  Future<Map<String, dynamic>> deleteCartItem({
    required String userId,
    required String productId,
  }) async {
    return await deleteCartItemApi(
      userId: userId,
      productId: productId,
    );
  }

  /// EMPTY CART
  Future<Map<String, dynamic>> emptyCart(String userId) async {
    return await emptyCartApi(userId);
  }

}