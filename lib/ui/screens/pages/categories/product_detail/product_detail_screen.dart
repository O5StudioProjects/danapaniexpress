import 'package:danapaniexpress/core/common_imports.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
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
  return ProductDetailScreenMobile();

}

Widget buildTabletUI() {
  return Container();
}

Widget buildDesktopUI() {
  return Container();
}

