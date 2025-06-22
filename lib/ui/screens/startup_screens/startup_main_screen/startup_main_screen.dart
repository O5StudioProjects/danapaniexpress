import 'dart:io';

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class StartupMainScreen extends StatelessWidget {
  const StartupMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var startupController = Get.put(StartupController());
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (onPop, res) {
        if (startupController.index.value > 0) {
          startupController.onTapBack();
        } else {
          exit(0); // Exit the app
        }
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
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
  return StartupScreenLayoutMobile(
    // image: EnvImages.imgWelcomeStartup,
    // headingText: AppLanguage.startupWelcomeHeadingStr(appLanguage).toString(),
    // subText: AppLanguage.startupWelcomeSubtextStr(appLanguage).toString(),
    // buttonText: AppLanguage.getStartedStr(appLanguage).toString(),
    // onTap: (){
    //   print('onTap working');
    //   JumpTo.gotoFastDeliveryStartupScreen();
    // },
  );
}

Widget buildTabletUI() {
  return StartupScreenLayoutMobile(
  );
}

Widget buildDesktopUI() {
  return StartupScreenLayoutMobile(

  );
}
