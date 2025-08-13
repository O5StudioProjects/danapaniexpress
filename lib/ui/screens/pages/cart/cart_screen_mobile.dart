import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class CartScreenMobile extends StatelessWidget {
  const CartScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final auth = Get.find<AuthController>();
    final nav = Get.find<NavigationController>();
    return Obx(() {
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(
              title: AppLanguage.cartStr(appLanguage),
              isBackNavigation: false,
              isTrailing: cart.cartProducts.isEmpty ? false : true,
              trailingIcon: icDeleteCart,
              trailingIconType: IconType.PNG,
              trailingOnTap: () async {
                showCustomDialog(
                  context,
                  AppBoolDialog(
                    title: AppLanguage.makeEmptyCartStr(appLanguage).toString(),
                    detail: AppLanguage.emptyCartConfirmStr(appLanguage).toString(),
                    iconType: IconType.PNG,
                    icon: icDeleteCart,
                    onTapConfirm: () async {
                      Navigator.of(context).pop();
                      await cart.emptyCart();
                    },
                  ),
                );
              },
            ),

                cart.emptyCartStatus.value == Status.LOADING
                ? Expanded(child: loadingIndicator())
                : cart.getCartStatus.value == Status.LOADING && cart.cartProducts.isEmpty
                ? Expanded(child: loadingIndicator())
                : auth.currentUser.value == null
                ? Expanded(child: appSignInTip())
                : cart.cartProducts.isEmpty
                ? Expanded(
                    child: EmptyScreen(
                      icon: AppAnims.animEmptyCartSkin(isDark),
                      text: AppLanguage.emptyCartStr(appLanguage).toString(),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: MAIN_HORIZONTAL_PADDING,
                        vertical: MAIN_VERTICAL_PADDING,
                      ),
                      itemCount: cart.cartProducts.length,
                      itemBuilder: (context, index) {
                        var cartData = cart.cartProducts[index];
                        return CartProductItem(product: cartData);
                      },
                    ),
                  ),




            cart.cartProducts.isNotEmpty
            ? Container(
              width: size.width,
              //height: 100.0,
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              decoration: BoxDecoration(
                color: AppColors.cardColorSkin(isDark)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        checkOutItems(
                            title: AppLanguage.productsColonStr(appLanguage),
                            detail: cart.cartProducts.length.toString()
                        ),
                        checkOutItems(
                            title: AppLanguage.quantityColonStr(appLanguage),
                            detail: cart.totalProductsQuantity.value.toString()
                        ),

                      ],
                    ),
                    appDivider(),
                    setHeight(6.0),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              checkOutItems(
                                  title: AppLanguage.savedColonStr(appLanguage),
                                  detail: 'Rs. ${(cart.totalCutPrice.value - cart.totalSellingPrice.value).toStringAsFixed(1)}',
                                  isDiscount: true
                              ),
                              checkOutItems(
                                  title: AppLanguage.totalColonStr(appLanguage),
                                  detail: 'Rs. ${cart.totalSellingPrice.value.toString()}',
                                  isBilling: true
                              ),

                            ],
                          ),
                        ),
                        setWidth(MAIN_HORIZONTAL_PADDING),

                        appMaterialButton(
                            text: AppLanguage.checkoutStr(appLanguage),
                            onTap: ()=> nav.gotoCheckoutScreen()
                        )

                      ],
                    ),
                  ],
                )
              ),
            )
                : SizedBox.shrink()
          ],
        ),
      );
    });
  }
}

Widget checkOutItems({title, detail, isBilling = false, isDiscount = false}){
  return isRightLang
  ? Row(
    children: [
      appText(text: detail, textStyle: itemTextStyle().copyWith(
          color: isBilling ? AppColors.sellingPriceDetailTextSkin(isDark)
              : isDiscount ? AppColors.sellingPriceTextSkin(isDark)
              : AppColors.primaryTextColorSkin(isDark),
          fontSize: isBilling ? HEADING_FONT_SIZE : NORMAL_TEXT_FONT_SIZE
      )),
      setWidth(4.0),
      appText(text: title, textStyle: secondaryTextStyle(),
        textDirection: setTextDirection(appLanguage),
        textAlign: setTextAlignment(appLanguage),),

    ],
  )
  : Row(
    children: [
      appText(text: title, textStyle: secondaryTextStyle(),
        textDirection: setTextDirection(appLanguage),
        textAlign: setTextAlignment(appLanguage),),
      setWidth(4.0),
      appText(text: detail, textStyle: itemTextStyle().copyWith(
          color: isBilling ? AppColors.sellingPriceDetailTextSkin(isDark)
              : isDiscount ? AppColors.sellingPriceTextSkin(isDark)
              : AppColors.primaryTextColorSkin(isDark),
          fontSize: isBilling ? HEADING_FONT_SIZE : NORMAL_TEXT_FONT_SIZE
      )),
    ],
  );
}