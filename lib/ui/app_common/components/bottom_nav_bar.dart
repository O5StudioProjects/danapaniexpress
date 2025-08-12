import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

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
                            data.label, isCart: index == 3 ? true : false, isAccount: index == 4 ? true : false),
                      ),
                    )
                );
              })),
        ),
      );
    }
  );
}




Widget navBarItem(bool isSelected, icon, iconFilled, label,
    {bool isCart = false, bool isAccount = false}) {
  final auth = Get.find<AuthController>();
  final pendingFeedback = Get.find<PendingFeedbackController>();
  return Obx((){
    var cartCount = auth.currentUser.value == null ? 0 : auth.currentUser.value?.userCartCount ?? 0;
    return isSelected
        ? Stack(
      children: [
        Center(
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
        ),
        if(cartCount > 0 && isCart)
        Positioned(
          right: 0,
          child: appCartCount(cartCount),
        ),
        if(isAccount && pendingFeedback.completedOrdersWithoutFeedback.isNotEmpty)
          Positioned(
            right: 0,
            top: 4,
            child: appActiveNotification(),
          )
      ],
    )
        : Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          child: appIcon(icon: icon, iconType: IconType.PNG, width: 20.0, color: AppColors.secondaryTextColorSkin(isDark)),
        ),
        if(cartCount > 0 && isCart)
        Positioned(
          right: 0,
          child: appCartCount(cartCount),
        ),
        if(isAccount && pendingFeedback.completedOrdersWithoutFeedback.isNotEmpty)
          Positioned(
            right: 2,
            bottom: 12,
            child: appActiveNotification(),
          )
      ],
    );
  });
}

Widget appCartCount(cartCount){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
    decoration: BoxDecoration(
        color: AppColors.materialButtonSkin(isDark),
        borderRadius: BorderRadius.circular(100.0)
    ),
    child: Center(child: appText(text: cartCount.toString(), textStyle: itemTextStyle().copyWith(
        color: AppColors.materialButtonTextSkin(isDark),
        fontFamily: nunitoSemibold,
        fontSize: TAGS_FONT_SIZE))),
  );
}

Widget appActiveNotification(){
  return Container(
    width: 12.0,
    height: 12.0,
    decoration: BoxDecoration(
        color: AppColors.materialButtonSkin(isDark),
        borderRadius: BorderRadius.circular(100.0),
      border: Border.all(color: AppColors.backgroundColorSkin(isDark))
    ),
  );
}


class BottomNavItemsModel {
  final String icon;
  final String iconFilled;
  final String label;

  const BottomNavItemsModel(this.icon, this.iconFilled, this.label);
}
