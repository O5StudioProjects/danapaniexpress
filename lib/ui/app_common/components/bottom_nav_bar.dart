import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/ui/screens/pages/account/account_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/cart/cart_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/categories/categories_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/favorites/favorites_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/home_screen/home_screen.dart';



var screenList = [
  HomeScreen(),
  CategoriesScreen(),
  FavoritesScreen(),
  CartScreen(),
  AccountScreen()
];

Widget appBottomNavBar() {
  var dashboardController = Get.find<DashBoardController>();
  return Obx(
    () {
      var navBarItemsList = [
        BottomNavItemsModel(icHome, icHomeFill, AppLanguage.navHomeStr(appLanguage).toString()),
        BottomNavItemsModel(icCategories, icCategoriesFill, AppLanguage.categoriesStr(appLanguage).toString()),
        BottomNavItemsModel(icHeart, icHeartFill, AppLanguage.favoritesStr(appLanguage).toString()),
        BottomNavItemsModel(icCart, icCartFill, AppLanguage.cartStr(appLanguage).toString()),
        BottomNavItemsModel(icAccount, icAccountFill, AppLanguage.accountStr(appLanguage).toString()),
      ];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SizedBox(
          height: 48.0,
          width: size.width,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(navBarItemsList.length, (index) {
                var data = navBarItemsList[index];
                return GestureDetector(
                    onTap: () {
                      // context.read<HomeBloc>().add(BottomNavTapEvent(index));
                      // HomeBlocHelper.instance.bottomNavTapEvent(index);
                      dashboardController.onBottomNavItemTap(index);
                    },
                    child: Container(
                      height: 48.0,
                      width: dashboardController.navIndex.value == index ? null : 48.0,
                      color: Colors.transparent,
                      child: Center(
                        child: navBarItem(dashboardController.navIndex.value == index, data.icon, data.iconFilled,
                            data.label),
                      ),
                    )
                );
              })),
        ),
      );
    }
  );
}




Widget navBarItem(bool isSelected, icon, iconFilled, label) {
  return isSelected
      ? Center(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: AppColors.cardColorSkin(isDark),
          borderRadius: BorderRadius.circular(20.0)),
      child: Row(
        children: [
          appIcon(icon: iconFilled, iconType: IconType.PNG, width: 20.0, color: AppColors.materialButtonSkin(isDark)),
          setWidth(4.0),
          Obx(()=> appText(text: label, textStyle: bottomNavItemTextStyle()))
        ],
      ),
    ),
  )
      : appIcon(icon: icon, iconType: IconType.PNG, width: 20.0, color: AppColors.secondaryTextColorSkin(isDark));
}


class BottomNavItemsModel {
  final String icon;
  final String iconFilled;
  final String label;

  const BottomNavItemsModel(this.icon, this.iconFilled, this.label);
}
