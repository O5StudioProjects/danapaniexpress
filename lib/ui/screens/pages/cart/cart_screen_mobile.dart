import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/resources/shared_resources/app_images.dart';
import 'package:danapaniexpress/ui/app_common/dialogs/bool_dialog.dart';

class CartScreenMobile extends StatelessWidget {
  const CartScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final auth = Get.find<AuthController>();
    cart.fetchCartProducts();

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
                    title: 'Empty Cart',
                    detail: 'Do you want to make cart empty?',
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
            cart.getCartStatus.value == Status.LOADING
                ? Padding(
                    padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING),
                    child: loadingIndicator(),
                  )
                : SizedBox.shrink(),


            auth.currentUser.value == null
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
          ],
        ),
      );
    });
  }
}
