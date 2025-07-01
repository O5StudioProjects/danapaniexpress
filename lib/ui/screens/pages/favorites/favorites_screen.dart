import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/ui/screens/pages/favorites/favorites_screen_mobile.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

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
  return FavoritesScreenMobile();

}

Widget buildTabletUI() {
  return Container();
}

Widget buildDesktopUI() {
  return Container();
}

