import 'package:danapaniexpress/core/common_imports.dart';

class TrustedByFamiliesScreen extends StatelessWidget {
  const TrustedByFamiliesScreen({super.key});

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
    image: EnvImages.imgTrustedByFamiliesStartup,
    headingText: AppLanguage.startupTrustedFamiliesHeadingStr(appLanguage).toString(),
    subText: AppLanguage.startupTrustedFamiliesSubtextStr(appLanguage).toString(),
    buttonText: AppLanguage.startShoppingStr(appLanguage).toString(),
    onTap: ()=> JumpTo.gotoSignInScreen(),
  );
}

Widget buildTabletUI() {
  return Container();
}

Widget buildDesktopUI() {
  return Container();
}
