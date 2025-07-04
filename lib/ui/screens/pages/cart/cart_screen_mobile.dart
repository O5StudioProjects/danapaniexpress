import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/ui/app_common/components/empty_screen.dart';

class CartScreenMobile extends StatelessWidget {
  const CartScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          appBarCommon(title: AppLanguage.cartStr(appLanguage), isBackNavigation: false),
          EmptyScreen(icon: AppAnims.animEmptyCartSkin(isDark), text: AppLanguage.emptyCartStr(appLanguage).toString()),
         // EmptyScreen(icon: icCart, text: AppLanguage.emptyCartStr(appLanguage).toString()),
        ],
      )
    );
  }
}
