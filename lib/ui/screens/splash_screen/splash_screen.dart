import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/ui/screens/splash_screen/splash_screen_mobile.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
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