import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/domain/controllers/product_controller/other_products_controller.dart';
import 'package:danapaniexpress/ui/screens/pages/categories/other_products/other_products_screen_mobile.dart';

class OtherProductsScreen extends StatelessWidget {
  const OtherProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final otherProductsController = Get.put(OtherProductsController());
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
  return OtherProductsScreenMobile();

}

Widget buildTabletUI() {
  return Container();
}

Widget buildDesktopUI() {
  return Container();
}