import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class MainDashboardScreenMobile extends StatelessWidget {
  const MainDashboardScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var dashboardController = Get.find<DashBoardController>();
    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.backgroundColorSkin(isDark),
        body: SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(child: screenList.elementAt(dashboardController.navIndex.value)),
                Obx(
                      ()=> Container(
                    width: size.width,
                    height: BOTTOM_NAV_BAR_SIZE,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColorSkin(isDark),
                    ),
                    child: appBottomNavBar(),
                  ),
                ),
              ],
            )
        ),
      );
    });
  }
}



// return Obx(
// ()=> Stack(
// children: [
// Column(
// children: [
// Expanded(
// child: screenList.elementAt(dashboardController.navIndex.value)),
// ],
// )
// ],
// ),
// );
