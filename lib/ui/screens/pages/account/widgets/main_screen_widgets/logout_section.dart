import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class LoginLogoutSection extends StatelessWidget {
  const LoginLogoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = Get.find<AuthController>();
    var orders = Get.find<OrdersController>();
    var favorites = Get.find<FavoritesController>();
    var cart = Get.find<CartController>();
    var nav = Get.find<NavigationController>();

    return Obx((){
      var icArrow = isRightLang ? icArrowLeftSmall : icArrowRightSmall;
      return _buildUI(context, auth, orders, favorites, cart, nav, icArrow);
    });
  }

  Widget _buildUI(context, auth, orders, favorites, cart, nav, icArrow){
    if(auth.currentUser.value != null){
      return _alreadyLoginButtonSection(auth, icArrow, context, orders, favorites, cart);
    } else {
      return _notLoginButtonSection(icArrow, nav);
    }
  }

  Widget _alreadyLoginButtonSection(auth, icArrow, context, orders, favorites, cart){
    return Padding(
      padding: const EdgeInsets.only(
          top: MAIN_HORIZONTAL_PADDING,
          bottom: MAIN_VERTICAL_PADDING
      ),
      child: auth.authStatus.value == AuthStatus.LOADING
          ? loadingIndicator()
          : listItemIcon(
        iconType: IconType.ICON,
        leadingIcon: Icons.logout_rounded,
        itemTitle: AppLanguage.signOutStr(appLanguage).toString(),
        trailingIcon: icArrow,
        onItemClick: () async {
          showCustomDialog(context, AppBoolDialog(
            title: AppLanguage.signOutStr(appLanguage).toString(),
            detail: AppLanguage.doYouWantToSignOutStr(appLanguage).toString(),
            iconType: IconType.ICON,
            icon: Icons.logout_rounded,
            onTapConfirm: () async {
              Navigator.of(context).pop();
              await auth.logoutUser().then((val) {
                Get.delete<HomeController>(force: true);
                orders.activeOrders.clear();
                orders.confirmedOrders.clear();
                orders.completedOrders.clear();
                orders.cancelledOrders.clear();
                favorites.favoritesList.clear();
                cart.cartProducts.clear();
              });
            },
          ));
        },
      ),
    );
  }

  Widget _notLoginButtonSection(icArrow, nav){
    return Padding(
      padding: const EdgeInsets.only(
          top: MAIN_HORIZONTAL_PADDING,
          bottom: MAIN_VERTICAL_PADDING
      ),
      child: listItemIcon(
        iconType: IconType.ICON,
        leadingIcon: Icons.login_rounded,
        itemTitle: AppLanguage.signInStr(appLanguage).toString(),
        trailingIcon: icArrow,
        onItemClick: (){
          nav.gotoSignInScreen();
        },
      ),
    );
  }

}
