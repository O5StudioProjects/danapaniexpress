import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/controllers/search_controller/search_controller.dart';

class FavoritesScreenMobile extends StatelessWidget {
  const FavoritesScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var favorites = Get.find<FavoritesController>();
    var search = Get.find<SearchProductsController>();

    return Obx(() {
      if(favorites.favoritesList.isEmpty){
        return Container(
            color: AppColors.backgroundColorSkin(isDark),
            child: EmptyScreen(icon: AppAnims.animEmptyFavoritesSkin(isDark), text: AppLanguage.noFavoritesStr(appLanguage).toString()));
      }

      return Container(
          width: size.width,
          height: size.height,
          color: AppColors.backgroundColorSkin(isDark),
          child:

          Column(
            children: [
              appBarCommon(title: AppLanguage.favoritesStr(appLanguage), isBackNavigation: false),

              Padding(
                padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING, right: MAIN_HORIZONTAL_PADDING, left: MAIN_HORIZONTAL_PADDING, bottom: MAIN_HORIZONTAL_PADDING),
                child: AppTextFormField(
                  textEditingController: search.searchTextController.value,
                  prefixIcon: Icons.search,
                  hintText: 'Search products...',
                ),
              ),

              favorites.toggleFavoriteStatus.value == Status.LOADING
              ? Padding(
                padding: EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
              child: Column(
                children: [
                  loadingIndicator(),
                  setHeight(MAIN_HORIZONTAL_PADDING),
                  appText(
                    text: 'Please Wait..',
                    textStyle: bodyTextStyle().copyWith(
                      color: AppColors.materialButtonSkin(isDark),
                      fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
                    ),
                  ),
                ],
              ),)
              : SizedBox.shrink(),

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
                    return FavoriteProductItem(product: favoriteData, onTapFavorite: () async {
                      favorites.toggleFavorite(favoriteData.productId!);
                    },);
                  },
                ),
              )

            ],
          )
      );
    });
  }
}
