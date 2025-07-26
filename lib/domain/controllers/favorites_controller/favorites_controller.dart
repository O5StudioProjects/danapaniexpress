import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/data/repositories/favorites_repository/favorites_repository.dart';

class FavoritesController  extends GetxController{

  final favRepo = FavoritesRepository();
  final productRepo = ProductsRepository();
  final auth = Get.find<AuthController>();

  /// FAVORITES
  Rx<Status> favoritesStatus = Status.IDLE.obs;
  RxList<ProductModel> favoritesList = <ProductModel>[].obs;
  Rx<Status> toggleFavoriteStatus = Status.IDLE.obs;

  @override
  void onInit() {
    print('Favorites Controller Started');
    super.onInit();
  }



  Future<void> fetchFavorites() async {
    if(auth.currentUser.value == null){
      return;
    }
    try {
      favoritesStatus.value = Status.LOADING;
      final items = await favRepo.getFavorites(auth.currentUser.value!.userId!);
      favoritesList.assignAll(items);
      print('FAVORITE Products Fetched...');

      favoritesStatus.value = Status.SUCCESS;
    } catch (e) {
      favoritesStatus.value = Status.FAILURE;
      showSnackbar(isError: true, title: 'Error', message: 'Failed to fetch favorites');
    }
  }

  /// TOGGLE FAVORITE - CONTROLLER
  Future<void> toggleFavorite(String productId) async {
    try {
      toggleFavoriteStatus.value = Status.LOADING;

      final response = await favRepo.toggleFavorite(
        userId: auth.userId.value!,
        productId: productId,
      );
      await fetchFavorites();
      // Optional: handle success/failure message
      if (response['status'] == 'added') {
        showSnackbar(
          isError: false,
          title: "Favorite Added",
          message: response['message'] ?? '',
        );
      } else if (response['status'] == 'removed') {
        showSnackbar(
          isError: false,
          title: "Favorite Removed",
          message: response['message'] ?? '',
        );
      }


      toggleFavoriteStatus.value = Status.SUCCESS;
    } catch (e) {
      toggleFavoriteStatus.value = Status.FAILURE;
      showSnackbar(
        isError: true,
        title: "Error",
        message: e.toString(),
      );
    }
  }

  @override
  void onClose() {
    print('Favorites Controller Stopped');
    super.onClose();
  }

}