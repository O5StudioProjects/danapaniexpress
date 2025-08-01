import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/controllers/search_controller/search_controller.dart';

class FavoritesScreenMobile extends StatelessWidget {
  const FavoritesScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var favorites = Get.put(FavoritesController());
    var search = Get.find<SearchProductsController>();
    var auth = Get.find<AuthController>();
   // favorites.fetchFavorites();
    return Obx(() {
      return Container(
          width: size.width,
          height: size.height,
          color: AppColors.backgroundColorSkin(isDark),
          child:

          Column(
            children: [
              appBarCommon(title: AppLanguage.favoritesStr(appLanguage), isBackNavigation: false),
              favorites.favoritesStatus.value == Status.LOADING && favorites.favoritesList.isEmpty
              ? Expanded(child: loadingIndicator()) :
              auth.currentUser.value == null
                  ? Expanded(child: appSignInTip())
                  : favorites.favoritesList.isEmpty
              ? Expanded(
                child: Container(
                    color: AppColors.backgroundColorSkin(isDark),
                    child: EmptyScreen(icon: AppAnims.animEmptyFavoritesSkin(isDark), text: AppLanguage.noFavoritesStr(appLanguage).toString())),
              )
              : Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING, right: MAIN_HORIZONTAL_PADDING, left: MAIN_HORIZONTAL_PADDING, bottom: MAIN_HORIZONTAL_PADDING),
                      child: AppTextFormField(
                        textEditingController: search.searchTextController.value,
                        prefixIcon: Icons.search,
                        hintText: AppLanguage.searchFavoriteProductsStr(appLanguage),
                      ),
                    ),

                    Expanded(
                      child:
                      ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: MAIN_HORIZONTAL_PADDING,
                          // vertical: MAIN_VERTICAL_PADDING /2,
                        ),
                        itemCount: favorites.favoritesList.length,
                        itemBuilder: (context, index) {
                          var favoriteData = favorites.favoritesList[index];
                          return FavoriteProductItem(product: favoriteData);
                        },
                      ),
                    )
                  ],
                ),
              )



            ],
          )
      );
    });
  }
}
