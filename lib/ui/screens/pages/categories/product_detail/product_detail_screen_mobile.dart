import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';


class ProductDetailScreenMobile extends StatelessWidget {
  const ProductDetailScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var productDetail = Get.find<ProductDetailController>();
    return Obx(() {
      final data = productDetail.productData.value;
      /// LOADING SECTION
      if (data == null) {
        return ProductsDetailLoading();
      }

      return Scaffold(
        bottomNavigationBar: cartSectionUI(data: data),
        body: Container(
          width: size.width,
          height: size.height,
          color: AppColors.backgroundColorSkin(isDark),
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// IMAGE SECTION
                ProductDetailImageSection(),

                ProductDetailSection(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget cartSectionUI({required ProductModel data}) {
    var productDetail = Get.find<ProductDetailController>();
    var cart = Get.find<CartController>();
    var auth = Get.find<AuthController>();
    var nav = Get.find<NavigationController>();
    return Obx(() {
      final productInCart = cart.cartProducts.firstWhereOrNull(
            (item) => item.productId == data.productId,
      );
      var isAddToCartQtyLoading = cart.addToCartWithQtyStatus.value == Status.LOADING ? true : false;
      var isAddToCartLoading = cart.addToCartWithQtyStatus.value == Status.LOADING ? true : false;
      return Container(
        color: AppColors.backgroundColorSkin(isDark),
        width: size.width,
        height: 90.0,
        child: Padding(
          padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appText(
                    text:
                    '$appCurrency ${calculateTotalAmount(productPrice: data.productSellingPrice!, quantity: productDetail.quantity.value).toStringAsFixed(1)}/-',
                    textStyle: sellingPriceDetailTextStyle(),
                  ),
                  setHeight(4.0),
                  appText(
                    text: AppLanguage.totalAmountStr(appLanguage),
                    textStyle: itemTextStyle(),
                  ),
                ],
              ),
              isAddToCartLoading || isAddToCartQtyLoading
                  ? SizedBox(
                width: 100.0,
                child: loadingIndicator(),
              )
                  : appMaterialButton(
                isDisable: data.productAvailability == false || data.productQuantity == 0,
                text: data.productAvailability == false || data.productQuantity == 0 ? AppLanguage.outOfStockStr(appLanguage) : productInCart != null ? AppLanguage.updateCartStr(appLanguage) : AppLanguage.addToCartStr(appLanguage),
                onTap: () {
                  if(auth.currentUser.value == null){
                    nav.gotoSignInScreen();
                  }
                  else {
                    if(data.productAvailability == true && data.productQuantity! > 0){
                      cart.addToCartWithQuantity(productId: data.productId!, userId: auth.currentUser.value!.userId!, productQty: productDetail.quantity.value);
                    } else {
                      showToast(AppLanguage.outOfStockStr(appLanguage).toString());
                    }
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}