import 'package:danapaniexpress/core/common_imports.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
    image: EnvImages.imgWelcomeStartup,
    headingText: AppLanguage.startupWelcomeHeadingStr(appLanguage).toString(),
    subText: AppLanguage.startupWelcomeSubtextStr(appLanguage).toString(),
    buttonText: AppLanguage.getStartedStr(appLanguage).toString(),
    onTap: (){
      print('onTap working');
      JumpTo.gotoFastDeliveryStartupScreen();
    },
  );
}

Widget buildTabletUI() {
  return StartupScreenLayoutMobile(
    image: EnvImages.imgWelcomeStartup,
    headingText: AppLanguage.startupWelcomeHeadingStr(appLanguage).toString(),
    subText: AppLanguage.startupWelcomeSubtextStr(appLanguage).toString(),
    buttonText: AppLanguage.getStartedStr(appLanguage).toString(),
    onTap: () => JumpTo.gotoFastDeliveryStartupScreen(),
  );
}

Widget buildDesktopUI() {
  return StartupScreenLayoutMobile(
    image: EnvImages.imgWelcomeStartup,
    headingText: AppLanguage.startupWelcomeHeadingStr(appLanguage).toString(),
    subText: AppLanguage.startupWelcomeSubtextStr(appLanguage).toString(),
    buttonText: AppLanguage.getStartedStr(appLanguage).toString(),
    onTap: () => JumpTo.gotoFastDeliveryStartupScreen(),
  );
}
