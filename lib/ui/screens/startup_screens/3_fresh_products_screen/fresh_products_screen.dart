import 'package:danapaniexpress/core/common_imports.dart';

class FreshProductsScreen extends StatelessWidget {
  const FreshProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
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
    image: EnvImages.imgFreshProductsStartup,
    headingText: AppLanguage.startupFreshProductsHeadingStr(appLanguage).toString(),
    subText: AppLanguage.startupFreshProductsSubtextStr(appLanguage).toString(),
    buttonText: AppLanguage.nextStr(appLanguage).toString(),
    onTap: ()=> JumpTo.gotoTrustedByFamiliesStartupScreen(),
  );
}

Widget buildTabletUI() {
  return Container();
}

Widget buildDesktopUI() {
  return Container();
}
