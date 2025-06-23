import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class MainDashboardScreenMobile extends StatelessWidget {
  const MainDashboardScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var dashboardController = Get.find<DashBoardController>();
    return Obx(
      ()=> Stack(
        children: [
          Column(
            children: [
              Expanded(
                  child: screenList.elementAt(dashboardController.navIndex.value)),
            ],
          )
        ],
      ),
    );
  }
}
