import 'package:danapaniexpress/core/common_imports.dart';

class ReturnsRefundsScreen extends StatelessWidget {
  const ReturnsRefundsScreen({super.key});

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
  return ReturnsRefundsMobile();

}

Widget buildTabletUI() {
  return Container();
}

Widget buildDesktopUI() {
  return Container();
}

