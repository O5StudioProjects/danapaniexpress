import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/ui/screens/pages/favorites/widgets/favorite_product_item.dart';

import '../../../../domain/controllers/favorites_controller/favorites_controller.dart';

class FavoritesScreenMobile extends StatelessWidget {
  const FavoritesScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var favorites = Get.find<FavoritesController>();

    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          appBarCommon(title: AppLanguage.favoritesStr(appLanguage), isBackNavigation: false),

         Padding(
           padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING, right: MAIN_HORIZONTAL_PADDING, left: MAIN_HORIZONTAL_PADDING, bottom: MAIN_HORIZONTAL_PADDING),
           child: AppTextFormField(
             prefixIcon: Icons.search,
             hintText: 'Search products...',
           ),
         ),

         // EmptyScreen(icon: AppAnims.animEmptyFavoritesSkin(isDark), text: AppLanguage.noFavoritesStr(appLanguage).toString()),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: MAIN_HORIZONTAL_PADDING,
               // vertical: MAIN_VERTICAL_PADDING /2,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return FavoriteProductItem();
              },
            ),
          )

        ],
      )
    );
  }
}
