import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class MainDashboardScreen extends StatelessWidget {
  const MainDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var dashboardController = Get.put(DashBoardController(), permanent: true);
    var navigation = Get.put(NavigationController(), permanent: true);
    return Scaffold(
      bottomNavigationBar: Obx(
        ()=> Container(
          width: size.width,
          height: BOTTOM_NAV_BAR_SIZE,
          decoration: BoxDecoration(
            color: AppColors.backgroundColorSkin(isDark),
          ),
          child: appBottomNavBar(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ResponsiveLayout(
          mobileView: buildMobileUI(),
          tabletView: buildTabletUI(),
          desktopView: buildDesktopUI(),
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