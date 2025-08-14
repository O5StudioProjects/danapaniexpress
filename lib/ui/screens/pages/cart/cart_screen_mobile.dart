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
      return _buildUI(context, cart, auth, nav);
    });
  }

  Widget _buildUI(context, cart, auth, nav){
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
          _productsList(cart, auth),
          CheckoutSection()
        ],
      ),
    );
  }

  Widget _productsList(cart, auth){
    return
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
      );
  }

}




