import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/data/repositories/cart_repository/cart_repository.dart';

import '../../../core/data_model_imports.dart';

class CartController  extends GetxController{

  final cartRepo = CartRepository();
  final auth = Get.find<AuthController>();

  final RxMap<String, Status> addCartStatus = <String, Status>{}.obs;
  final RxMap<String, Status> deleteCartItemStatus = <String, Status>{}.obs;

  RxList<ProductModel> cartProducts = <ProductModel>[].obs;
  Rx<Status> getCartStatus = Status.IDLE.obs;

  // @override
  // void onInit() {
  //   print('Cart Controller Started');
  //   super.onInit();
  // }


  Future<void> addToCart(String productId) async {
    try {
      final userId = auth.userId.value ?? '';
      if (userId.isEmpty) {
        showSnackbar(
          isError: true,
          title: 'Error',
          message: 'User not logged in',
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
          message: response['message'] ?? 'Product added to cart',
        );

        await fetchCartProducts(); // Optional: Refresh cart after adding
        auth.fetchUserProfile();



      } else {
        addCartStatus[productId] = Status.FAILURE;
        showSnackbar(
          isError: true,
          title: 'Error',
          message: response['message'] ?? 'Failed to add to cart',
        );
      }
    } catch (e) {
      addCartStatus[productId] = Status.FAILURE;
      if (kDebugMode) {
        print('Exception: $e');
      }
    }
  }

  Future<void> fetchCartProducts() async {
    try {
      getCartStatus.value = Status.LOADING;
      final products = await cartRepo.getCartProducts(auth.currentUser.value!.userId!);
      cartProducts.assignAll(products);
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
        cartProducts.removeWhere((p) => p.productId == productId);
        deleteCartItemStatus[productId] = Status.SUCCESS;
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
      getCartStatus.value = Status.LOADING;

      final result = await cartRepo.emptyCart(auth.currentUser.value!.userId!);

      if (result['status'] == 'success') {
        // Optionally refresh cart
        cartProducts.clear();
        getCartStatus.value = Status.SUCCESS;
        showSnackbar(
          isError: false,
          title: 'Success',
          message: result['message'] ?? 'Cart deleted',
        );
        auth.fetchUserProfile();
      } else {
        getCartStatus.value = Status.FAILURE;
        showSnackbar(
          isError: true,
          title: 'Error',
          message: result['message'] ?? 'Failed to delete cart',
        );
      }
    } catch (e) {
      getCartStatus.value = Status.FAILURE;
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