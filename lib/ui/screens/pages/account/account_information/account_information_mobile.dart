import 'package:danapaniexpress/core/common_imports.dart';

class AccountInformationMobile extends StatelessWidget {
  const AccountInformationMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          appBarCommon(
            title: 'Account Information',
            isBackNavigation: true
          )
        ],
      ),
    );
  }
}

