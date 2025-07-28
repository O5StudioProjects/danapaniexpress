import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/data/repositories/cart_repository/cart_datasource.dart';

class CartRepository extends CartDatasource{

  /// ADD PRODUCT TO CART WITH SPECIFIC QUANTITY (OR INCREMENT IF EXISTS)
  Future<Map<String, dynamic>> addToCartWithQuantity({
    required String userId,
    required String productId,
    required int productQty,
  }) async {
    return await addToCartWithQuantityApi(
      userId: userId,
      productId: productId,
      productQty: productQty,
    );
  }

  /// ADD PRODUCT TO CART AND SAME METHOD USED TO MAKE INCREMENT IN CART
  Future<Map<String, dynamic>> addToCart({
    required String userId,
    required String productId,
  }) async {
    return await addToCartApi(
      userId: userId,
      productId: productId,
    );
  }

  /// DECREMENT QUANTITY OF PRODUCT IN CART
  Future<Map<String, dynamic>> removeProductQuantityFromCart({
    required String userId,
    required String productId,
  }) async {
    return await removeProductQuantityFromCartApi(
      userId: userId,
      productId: productId,
    );
  }

  /// GET CART PRODUCTS LIST BY CURRENT USER
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