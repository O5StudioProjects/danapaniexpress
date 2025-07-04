import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/ui/app_common/components/empty_screen.dart';

class AccountScreenMobile extends StatelessWidget {
  const AccountScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          appBarCommon(title: AppLanguage.accountStr(appLanguage), isBackNavigation: false),
          EmptyScreen(icon: AppAnims.animEmptyBoxSkin(isDark), text: 'Account is Empty'),
        ],
      )
    );
  }
}
