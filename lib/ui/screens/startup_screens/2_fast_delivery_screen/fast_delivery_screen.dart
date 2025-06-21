import 'package:danapaniexpress/core/common_imports.dart';

class FastDeliveryScreen extends StatelessWidget {
  const FastDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
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
  return StartupScreenLayoutMobile(
    image: EnvImages.imgFastDeliveryStartup,
    headingText: AppLanguage.startupFastDeliveryHeadingStr(appLanguage).toString(),
    subText: AppLanguage.startupFastDeliverySubtextStr(appLanguage).toString(),
    buttonText: AppLanguage.nextStr(appLanguage).toString(),
    onTap: ()=> JumpTo.gotoFreshProductsStartupScreen(),
  );
}

Widget buildTabletUI() {
  return Container();
}

Widget buildDesktopUI() {
  return Container();
}
