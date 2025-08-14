import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class CheckoutSection extends StatelessWidget {
  const CheckoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final nav = Get.find<NavigationController>();
    return Obx((){
      return
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

                  _productsAndQuantity(cart),
                  appDivider(),
                  _amountAndCheckout(cart, nav),
                ],
              )
          ),
        )
            : SizedBox.shrink();
    });
  }

  Widget _productsAndQuantity(cart){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _checkOutItems(
            title: AppLanguage.productsColonStr(appLanguage),
            detail: cart.cartProducts.length.toString()
        ),
        _checkOutItems(
            title: AppLanguage.quantityColonStr(appLanguage),
            detail: cart.totalProductsQuantity.value.toString()
        ),

      ],
    );
  }

  Widget _amountAndCheckout(cart, nav){
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _checkOutItems(
                    title: AppLanguage.savedColonStr(appLanguage),
                    detail: '$appCurrency ${(cart.totalCutPrice.value - cart.totalSellingPrice.value).toStringAsFixed(1)}',
                    isDiscount: true
                ),
                _checkOutItems(
                    title: AppLanguage.totalColonStr(appLanguage),
                    detail: '$appCurrency ${cart.totalSellingPrice.value.toString()}',
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
    );
  }

  Widget _checkOutItems({title, detail, isBilling = false, isDiscount = false}){
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

}