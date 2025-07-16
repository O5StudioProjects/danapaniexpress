import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/ui/screens/other_screens/no_internet_screen/no_internet_mobile.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: ResponsiveLayout(
            mobileView: mobileUI(),
            tabletView: tabletUI(),
            desktopView: desktopUI(),
          ),
        ),
      ),
    );
  }
}

Widget mobileUI(){
  return NoInternetMobile();
}
Widget tabletUI(){
  return NoInternetMobile();
}
Widget desktopUI(){
  return NoInternetMobile();
}