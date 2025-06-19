import 'package:danapaniexpress/core/common_imports.dart';

class SplashScreenMobile extends StatelessWidget {
  const SplashScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(color: AppColors.backgroundColorSkin(isDark)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to',
              style: TextStyle(
                fontSize: 28,
                fontFamily: nunitoSemibold,
                color: AppColors.primaryTextColorSkin(isDark),
              ),
            ),
            Text(
              '${AppLanguage.appNameStr(appLanguage)}',
              style: TextStyle(
                fontSize: 40,
                fontFamily: poppinsSemibold,
                color: AppColors.primaryTextColorSkin(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
