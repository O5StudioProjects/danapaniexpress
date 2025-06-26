import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/domain/controllers/splash_controller/splash_controller.dart';
import 'package:danapaniexpress/ui/screens/splash_screen/splash_screen_mobile.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var splashController = Get.put(SplashController());
    return Scaffold(
      body: SafeArea(
        top: false,
        child: ResponsiveLayout(
          mobileView: mobileUI(),
          tabletView: tabletUI(),
          desktopView: desktopUI(),
        ),
      ),
    );
  }
}

Widget mobileUI(){
  return SplashScreenMobile();
}
Widget tabletUI(){
  return SplashScreenMobile();
}
Widget desktopUI(){
  return SplashScreenMobile();
}