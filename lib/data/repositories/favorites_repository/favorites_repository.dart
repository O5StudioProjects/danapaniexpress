import 'package:danapaniexpress/data/repositories/favorites_repository/favorites_datasource.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class FavoritesRepository extends FavoritesDatasource{

  /// GET FAVORITES BY USER ID - Repository
  Future<List<ProductModel>> getFavorites(String userId) async {
    return await getFavoritesApi(userId);
  }


  /// TOGGLE FAVORITE (Add/Remove) - REPO
  Future<Map<String, dynamic>> toggleFavorite({
    required String userId,
    required String productId,
  }) async {
    return await toggleFavoriteApi(userId: userId, productId: productId);
  }


}