import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/ui/screens/startup_screens/cities_screen/service_areas_screen_mobile.dart';

class ServiceAreasScreen extends StatelessWidget {
  const ServiceAreasScreen({super.key});

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
  return ServiceAreasScreenMobile();

}

Widget buildTabletUI() {
  return Container();
}

Widget buildDesktopUI() {
  return Container();
}
