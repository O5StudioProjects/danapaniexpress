import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/ui/screens/pages/cart/order_placed_screen/order_placed_screen_mobile.dart';

import '../../../../../domain/controllers/dashboard_controller/dashboard_controller.dart';

class OrderPlacedScreen extends StatelessWidget {
  const OrderPlacedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (result, onPop){
        Get.find<DashBoardController>().navIndex.value = 0;
        Get.back();
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
  return OrderPlacedScreenMobile();

}

Widget buildTabletUI() {
  return Container();
}

Widget buildDesktopUI() {
  return Container();
}

