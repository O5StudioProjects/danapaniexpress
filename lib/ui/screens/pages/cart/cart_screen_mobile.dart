import 'package:danapaniexpress/core/common_imports.dart';

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
         // EmptyScreen(icon: AppAnims.animEmptyCartSkin(isDark), text: AppLanguage.emptyCartStr(appLanguage).toString()),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: MAIN_HORIZONTAL_PADDING,
                vertical: MAIN_VERTICAL_PADDING,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return CartProductItem();
              },
            ),
          )
        ],
      )
    );
  }
}
