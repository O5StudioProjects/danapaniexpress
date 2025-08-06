import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/ui/screens/pages/account/my_orders/order_detail_screen/order_feedback_complete/order_feedback_complete_mobile.dart';

class OrderFeedbackComplete extends StatelessWidget {
  const OrderFeedbackComplete({super.key});

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
  return OrderFeedbackCompleteMobile();
}

Widget buildTabletUI() {
  return Container();
}

Widget buildDesktopUI() {
  return Container();
}
