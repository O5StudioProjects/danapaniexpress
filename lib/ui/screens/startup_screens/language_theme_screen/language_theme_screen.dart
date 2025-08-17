import 'package:danapaniexpress/core/common_imports.dart';

class LanguageThemeScreen extends StatelessWidget {
  const LanguageThemeScreen({super.key});

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
  return LanguageThemeMobile();
}

Widget buildTabletUI() {
  return Container();
}

Widget buildDesktopUI() {
  return Container();
}