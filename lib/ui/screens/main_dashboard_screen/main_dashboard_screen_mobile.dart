import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

import '../pages/account/account_screen.dart';
import '../pages/cart/cart_screen.dart';
import '../pages/categories/categories_screen.dart';
import '../pages/favorites/favorites_screen.dart';
import '../pages/home_screen/home_screen.dart';

class MainDashboardScreenMobile extends StatelessWidget {
  const MainDashboardScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var dashboardController = Get.put(DashBoardController(), permanent: true);
    return Obx(() {
      var screenList = [
        HomeScreen(),
        CategoriesScreen(),
        FavoritesScreen(),
        CartScreen(),
        AccountScreen()
      ];

      return Scaffold(
        backgroundColor: AppColors.backgroundColorSkin(isDark),
        body: SafeArea(
            top: false,
            child: Obx(
              ()=> Column(
                children: [
                  Expanded(child: screenList.elementAt(dashboardController.navIndex.value)),
                  Container(
                    width: size.width,
                    height: BOTTOM_NAV_BAR_SIZE,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColorSkin(isDark),
                    ),
                    child: appBottomNavBar(),
                  ),
                ],
              ),
            )
        ),
      );
    });
  }
}