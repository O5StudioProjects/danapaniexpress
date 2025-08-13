import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class FavoritesScreenMobile extends StatelessWidget {
  const FavoritesScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = Get.find<AuthController>();
    var favorites = Get.find<FavoritesController>();

    return Obx(() {
      return _buildUI(favorites, auth);
    });
  }

  Widget _buildUI(favorites, auth){
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
                : _favoriteListSection(favorites),
          ],
        )
    );
  }

  Widget _favoriteListSection(favorites){
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: MAIN_HORIZONTAL_PADDING,
              right: MAIN_HORIZONTAL_PADDING,
              left: MAIN_HORIZONTAL_PADDING,
              bottom: MAIN_HORIZONTAL_PADDING,
            ),
            child: AppTextFormField(
              textEditingController: favorites.searchFavoriteTextController.value,
              prefixIcon: Icons.search,
              hintText: AppLanguage.searchFavoriteProductsStr(appLanguage),
              onChanged: (text) {
                favorites.applySearchFilter(text);
              },
            ),
          ),

          Expanded(
            child: Obx(() {
              final searchText = favorites.searchQuery.value.trim();
              final displayList = searchText.isNotEmpty
                  ? favorites.filteredFavoritesList
                  : favorites.favoritesList;

              if (searchText.isNotEmpty && favorites.filteredFavoritesList.isEmpty) {
                // 🔍 No match found
                return Center(
                  child: Text(
                    AppLanguage.noSearchedProductStr(appLanguage).toString(), // Define this in your localization
                    style: bodyTextStyle().copyWith(
                        color: AppColors.materialButtonSkin(isDark),
                        fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE
                    ),
                  ),
                );
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  final product = displayList[index];
                  return FavoriteProductItem(product: product);
                },
              );
            }),
          ),
        ],
      ),
    );
  }



}
