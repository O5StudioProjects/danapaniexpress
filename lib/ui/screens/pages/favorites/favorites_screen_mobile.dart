import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/ui/app_common/components/empty_screen.dart';

class FavoritesScreenMobile extends StatelessWidget {
  const FavoritesScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          appBarCommon(title: AppLanguage.favoritesStr(appLanguage), isBackNavigation: false),
          EmptyScreen(icon: AppAnims.animEmptyFavoritesSkin(isDark), text: AppLanguage.noFavoritesStr(appLanguage).toString()),
        ],
      )
    );
  }
}
