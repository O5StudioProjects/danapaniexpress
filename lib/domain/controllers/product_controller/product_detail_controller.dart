import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class ProductDetailController extends GetxController {

  final productDetailRepo = ProductDetailRepository();
  final  productRepo = ProductsRepository();
  final auth = Get.find<AuthController>();
  final favorites = Get.find<FavoritesController>();

  RxInt quantity = 1.obs;
  Rx<ProductsStatus> relatedProductStatus = ProductsStatus.IDLE.obs;
  Rx<Status> toggleFavoriteStatus = Status.IDLE.obs;
  Rx<ProductModel?> productData = Rx<ProductModel?>(null);
  RxList<ProductModel> relatedProductsList = <ProductModel>[].obs;

  RxBool isFavorite = false.obs;

  @override
  Future<void> onInit() async {
    // productData.value = Get.arguments[DATA_PRODUCT] as ProductModel;
    var product = Get.arguments[DATA_PRODUCT] as ProductModel;
    productData.value = await productRepo.getSingleProduct(productId: product.productId!);
    isFavorite.value = productData.value!.isFavoriteBy(auth.userId.value ?? '');
    /// Check initial favorite state
    // isFavorite.value = productData.value!.productFavoriteList?.contains(auth.userId.value) ?? false;
    isFavorite.value = productData.value!.isFavoriteBy(auth.userId.value ?? '');


    fetchRelatedProducts(productData.value!);

    super.onInit();
  }

  Future<void> getSingleProduct({required String productId}) async {
   // toggleFavoriteStatus.value = Status.LOADING;
    await productRepo.getSingleProduct(productId: productData.value!.productId!).then((value){
   //   toggleFavoriteStatus.value = Status.SUCCESS;
      productData.value = value;
    }).catchError((error){
   //   toggleFavoriteStatus.value = Status.FAILURE;
    });

  }

  /// TOGGLE FAVORITE - CONTROLLER
  Future<void> toggleFavorite(String productId) async {
    try {
      toggleFavoriteStatus.value = Status.LOADING;

      final response = await productDetailRepo.toggleFavorite(
        userId: auth.userId.value!,
        productId: productId,
      );
      productData.value = await productRepo.getSingleProduct(productId: productId);
      await favorites.fetchFavorites();
      await auth.fetchUserProfile();
      isFavorite.value = productData.value!.isFavoriteBy(auth.userId.value ?? '');
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



  onTapMinus(){
    if(quantity.value > 1){
      quantity.value -=1;
    } else {
      print('Zero is not allowed');
    }
  }

  onTapPlus({int productLimit = 5}){ //LIMIT TO 5 ITEMS AS QUANTITY
    if(quantity.value < productLimit){
      quantity.value +=1;
    } else {
      print('Limit Exceeded');
    }
  }

  Future<void> fetchRelatedProducts(ProductModel currentProduct) async {
    relatedProductStatus.value = ProductsStatus.LOADING;

    try {
      final result = await productDetailRepo.fetchRelatedProducts(
        categoryId: currentProduct.productCategory!,
        subCategoryId: currentProduct.productSubCategory!,
      );

      // Remove current product from related list
      result.removeWhere((p) => p.productId == currentProduct.productId);

      relatedProductsList.assignAll(result);
      relatedProductStatus.value = ProductsStatus.SUCCESS;
      if (kDebugMode) {
        print("Related Products Fetched");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching related products: $e");
      }
      relatedProductsList.clear();
      relatedProductStatus.value = ProductsStatus.FAILURE;
    }
  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

}