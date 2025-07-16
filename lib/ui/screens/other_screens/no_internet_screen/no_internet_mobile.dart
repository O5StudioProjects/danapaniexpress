import 'package:danapaniexpress/core/common_imports.dart';

class NoInternetMobile extends StatelessWidget {
  const NoInternetMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: NoInternet(),
    );
  }
}
