import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';


class MainDashboardScreen extends StatelessWidget {
  const MainDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var dashboardController = Get.find<DashBoardController>();
    // var navigation = Get.put(NavigationController(), permanent: true);
    // var categories = Get.put(CategoriesController(), permanent: true);
    // var favorites = Get.put(FavoritesController(), permanent: true);
    // var cart = Get.put(CartController(), permanent: true);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (res, onPop){
        dashboardController.onDashboardBackPress();
      },
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: ResponsiveLayout(
            mobileView: buildMobileUI(),
            tabletView: buildTabletUI(),
            desktopView: buildDesktopUI(),
          ),
        ),
      ),
    );
  }
}

Widget buildMobileUI() {
  return MainDashboardScreenMobile();

}

Widget buildTabletUI() {
  return Container();
}

Widget buildDesktopUI() {
  return Container();
}