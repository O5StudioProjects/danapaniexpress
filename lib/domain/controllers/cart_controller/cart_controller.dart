import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/data/repositories/cart_repository/cart_repository.dart';

import '../../../core/data_model_imports.dart';

class CartController  extends GetxController{

  final cartRepo = CartRepository();
  final auth = Get.find<AuthController>();

  final Rx<Status> addToCartWithQtyStatus = Status.IDLE.obs;
  final RxMap<String, Status> addCartStatus = <String, Status>{}.obs;
  final RxMap<String, Status> addQuantityCartStatus = <String, Status>{}.obs;
  final RxMap<String, Status> removeQuantityCartStatus = <String, Status>{}.obs;
  final RxMap<String, Status> deleteCartItemStatus = <String, Status>{}.obs;

  RxList<ProductModel> cartProducts = <ProductModel>[].obs;
  Rx<Status> getCartStatus = Status.IDLE.obs;
  Rx<Status> emptyCartStatus = Status.IDLE.obs;


  /// CHECK OUT SECTION
  Rx<double> totalSellingPrice = 0.0.obs;
  Rx<double> totalCutPrice = 0.0.obs;
  Rx<int> totalProductsQuantity = 0.obs;

  // @override
  // void onInit() {
  //   print('Cart Controller Started');
  //   super.onInit();
  // }

  /// ADD PRODUCT TO CART WITH SPECIFIC QUANTITY (OR INCREMENT IF EXISTS)
  Future<void> addToCartWithQuantity({
    required String userId,
    required String productId,
    required int productQty,
  }) async {
    final userId = auth.userId.value ?? '';
    if (userId.isEmpty) {
      showSnackbar(
        isError: true,
        title: 'Error',
        message: AppLanguage.userNotLoggedInStr(appLanguage).toString(),
      );
      return;
    }

    try {
      addToCartWithQtyStatus.value = Status.LOADING;
      final result = await cartRepo.addToCartWithQuantity(
        userId: userId,
        productId: productId,
        productQty: productQty,
      );

      if (result['status'] == 'success') {
        await fetchCartProducts();
        addToCartWithQtyStatus.value = Status.SUCCESS;
        showSnackbar(
          isError: false,
          title: 'Success',
          message: result['message'] ?? 'Product added to cart',
        );
      } else {
        addToCartWithQtyStatus.value = Status.FAILURE;
        showSnackbar(
          isError: true,
          title: 'Error',
          message: result['message'] ?? 'Failed to add to cart',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception: $e');
      }
    }
  }


  /// ADD TO CART WITH OUT QUANTITY
  Future<void> addToCart(String productId) async {
    try {
      final userId = auth.userId.value ?? '';
      if (userId.isEmpty) {
        showSnackbar(
          isError: true,
          title: 'Error',
          message: AppLanguage.userNotLoggedInStr(appLanguage).toString(),
        );
        return;
      }
      addCartStatus[productId] = Status.LOADING;
      final response = await cartRepo.addToCart(
        userId: userId,
        productId: productId,
      );

      if (response['status'] == 'success') {
        addCartStatus[productId] = Status.SUCCESS;
        showSnackbar(
          isError: false,
          title: 'Success',
          message: response['message'] ?? AppLanguage.productAddedToCartStr(appLanguage),
        );

        await fetchCartProducts(); // Optional: Refresh cart after adding
        auth.fetchUserProfile();

      } else {
        addCartStatus[productId] = Status.FAILURE;
        showSnackbar(
          isError: true,
          title: 'Error',
          message: response['message'] ?? AppLanguage.failedToAddToCartStr(appLanguage),
        );
      }
    } catch (e) {
      addCartStatus[productId] = Status.FAILURE;
      if (kDebugMode) {
        print('Exception: $e');
      }
    }
  }

  /// ADD QUANTITY OF PRODUCTS IN CART LIST
  Future<void> addQuantityToCart(String productId) async {
    try {
      final userId = auth.userId.value ?? '';
      if (userId.isEmpty) {
        showSnackbar(
          isError: true,
          title: 'Error',
          message: AppLanguage.userNotLoggedInStr(appLanguage).toString(),
        );
        return;
      }
      addQuantityCartStatus[productId] = Status.LOADING;
      final response = await cartRepo.addToCart(
        userId: userId,
        productId: productId,
      );

      if (response['status'] == 'success') {
        await fetchCartProducts(); // Optional: Refresh cart after adding
        addQuantityCartStatus[productId] = Status.SUCCESS;

      } else {
        addQuantityCartStatus[productId] = Status.FAILURE;
        if (kDebugMode) {
          print('Error : ${response['message']}');
        }

      }
    } catch (e) {
      addQuantityCartStatus[productId] = Status.FAILURE;
      if (kDebugMode) {
        print('Exception: $e');
      }
    }
  }

  /// REMOVE QUANTITY OF PRODUCTS IN CART LIST
  Future<void> removeQuantityFromCart(String productId) async {
    try {
      removeQuantityCartStatus[productId] = Status.LOADING;

      final response = await cartRepo.removeProductQuantityFromCart(
        userId: auth.currentUser.value!.userId!,
        productId: productId,
      );

      final status = response['status'];
      final message = response['message'];

      if (status == 'success') {
        await fetchCartProducts(); // Optional: Refresh cart after adding
        removeQuantityCartStatus[productId] = Status.SUCCESS;
        // Optionally update cart or trigger a refresh here
      } else if (status == 'info') {
        removeQuantityCartStatus[productId] = Status.SUCCESS;
        showSnackbar(
          isError: false,
          title: 'Note',
          message: message ?? 'Product quantity is already 1.',
        );
      } else {
        removeQuantityCartStatus[productId] = Status.FAILURE;
        showSnackbar(
          isError: true,
          title: 'Error',
          message: message ?? 'Failed to remove item from cart.',
        );
      }
    } catch (e) {
      removeQuantityCartStatus[productId] = Status.FAILURE;
      showSnackbar(
        isError: true,
        title: 'Error',
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> fetchCartProducts() async {
    if(auth.currentUser.value == null){
      return;
    }
    try {
      getCartStatus.value = Status.LOADING;
      final products = await cartRepo.getCartProducts(auth.currentUser.value!.userId!);
      cartProducts.assignAll(products);

      // Reset totals before calculation
      totalSellingPrice.value = 0.0;
      totalCutPrice.value = 0.0;
      totalProductsQuantity.value = 0;

      for (final product in products) {
        final quantity = product.productQuantity ?? 1;
        final sellingPrice = product.productSellingPrice ?? 0.0;
        final cutPrice = product.productCutPrice ?? 0.0;

        totalSellingPrice.value += sellingPrice * quantity;
        totalCutPrice.value += cutPrice * quantity;
        totalProductsQuantity.value += quantity;
      }

      getCartStatus.value = Status.SUCCESS;
    } catch (e) {
      getCartStatus.value = Status.FAILURE;
      showSnackbar(isError: true, title: 'Error', message: e.toString());
    }
  }

  /// DELETE ITEM FROM CART
  Future<void> deleteCartItem(String productId) async {
    if (auth.userId.value == null) return;

    deleteCartItemStatus[productId] = Status.LOADING;

    try {
      final result = await cartRepo.deleteCartItem(
        userId: auth.userId.value!,
        productId: productId,
      );

      if (result['status'] == 'success') {
        // Optionally remove the product locally if using local list
        await fetchCartProducts();
        deleteCartItemStatus[productId] = Status.SUCCESS;
        cartProducts.removeWhere((p) => p.productId == productId);
        auth.fetchUserProfile();
        showSnackbar(isError: false, title: 'Success', message: result['message']);
      } else {
        deleteCartItemStatus[productId] = Status.FAILURE;
        showSnackbar(isError: true, title: 'Failed', message: result['message']);
      }
    } catch (e) {
      deleteCartItemStatus[productId] = Status.FAILURE;
      showSnackbar(isError: true, title: 'Error', message: 'Something went wrong');
    }
  }

  /// EMPTY CART COMPLETELY
  Future<void> emptyCart() async {
    try {
      emptyCartStatus.value = Status.LOADING;

      final result = await cartRepo.emptyCart(auth.currentUser.value!.userId!);

      if (result['status'] == 'success') {
        // Optionally refresh cart
        await fetchCartProducts();
        cartProducts.clear();
        emptyCartStatus.value = Status.SUCCESS;
        showSnackbar(
          isError: false,
          title: 'Success',
          message: result['message'] ?? AppLanguage.cartIsEmptyNowStr(appLanguage),
        );
        auth.fetchUserProfile();
      } else {
        emptyCartStatus.value = Status.FAILURE;
        showSnackbar(
          isError: true,
          title: 'Error',
          message: result['message'] ?? AppLanguage.failedToEmptyCartStr(appLanguage),
        );
      }
    } catch (e) {
      emptyCartStatus.value = Status.FAILURE;
      showSnackbar(
        isError: true,
        title: 'Exception',
        message: e.toString(),
      );
    }
  }

  @override
  void onClose() {
    print('Cart Controller Stopped');
    super.onClose();
  }


  void startController(){
    print('Cart Controller Started');
  }

}