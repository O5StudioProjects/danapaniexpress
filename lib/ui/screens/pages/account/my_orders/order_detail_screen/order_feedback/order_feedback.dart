import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/ui/screens/pages/account/my_orders/order_detail_screen/order_feedback/order_feedback_mobile.dart';

class OrderFeedback extends StatelessWidget {
  const OrderFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
  return OrderFeedbackMobile();

}

Widget buildTabletUI() {
  return Container();
}

Widget buildDesktopUI() {
  return Container();
}
