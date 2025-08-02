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
  final RxMap<String, Status> favoriteLoadingStatus = <String, Status>{}.obs;


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
      favoriteLoadingStatus[productId] = Status.LOADING;

      final response = await favRepo.toggleFavorite(
        userId: auth.userId.value!,
        productId: productId,
      );
      // Optional: handle success/failure message
      if (response['status'] == 'added') {
        showSnackbar(
          isError: false,
          title: "Favorite Added",
          message: response['message'] ?? '',
        );

      } else if (response['status'] == 'removed') {
        favoritesList.removeWhere((p) => p.productId == productId);
        favoriteLoadingStatus[productId] = Status.SUCCESS;
        showSnackbar(
          isError: false,
          title: "Favorite Removed",
          message: response['message'] ?? '',
        );
      }
      await auth.fetchUserProfile();

    } catch (e) {
      favoriteLoadingStatus[productId] = Status.FAILURE;
      showSnackbar(
        isError: true,
        title: "Error",
        message: e.toString(),
      );
    }
  }

  RxList<ProductModel> filteredFavoritesList = <ProductModel>[].obs;
  final RxString searchQuery = ''.obs;
  var searchFavoriteTextController = TextEditingController().obs;

  void applySearchFilter(String query) {
    searchQuery.value = query.toLowerCase();

    final result = favoritesList.where((product) {
      final titleUrdu = product.productNameUrdu?.toLowerCase() ?? '';
      final titleEnglish = product.productNameEng?.toLowerCase() ?? '';
      final brand = product.productBrand?.toLowerCase() ?? '';
      final matchesText = titleUrdu.contains(searchQuery.value) || titleEnglish.contains(searchQuery.value) || brand.contains(searchQuery.value);

      return matchesText;
    }).toList();

    filteredFavoritesList.assignAll(result);
  }

  @override
  void onInit() {
    ever(favoritesList, (_) {
      applySearchFilter(searchQuery.value); // keep filtered list in sync
    });
    super.onInit();
  }
  @override
  void onClose() {
    print('Favorites Controller Stopped');
    super.onClose();
  }

}