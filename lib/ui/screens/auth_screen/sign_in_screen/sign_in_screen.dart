import 'package:danapaniexpress/core/common_imports.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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
  return Container(
    width: size.width,
    height: size.height,
    color: AppColors.backgroundColorSkin(isDark),
    child: Center(
      child: appText(text: 'Welcome To Sign In Screen', textStyle: headingTextStyle()),
    ),
  );

}

Widget buildTabletUI() {
  return Container();
}

Widget buildDesktopUI() {
  return Container();
}