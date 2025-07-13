import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class SettingsMobile extends StatelessWidget {
  const SettingsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Get.find<ThemeController>();
    var navigation = Get.find<NavigationController>();
    var dashboard = Get.find<DashBoardController>();
    return Obx((){
      var arrow = appLanguage == URDU_LANGUAGE ? icArrowLeftSmall : icArrowRightSmall;
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(title: AppLanguage.settingsStr(appLanguage), isBackNavigation: true),
            Expanded(
                child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING),
                  child: listItemSwitchButton(
                    iconType: IconType.ICON,
                    leadingIcon: dashboard.floatingAvatarIcon.value ? Icons.insert_emoticon_sharp : Icons.insert_emoticon_rounded,
                    itemTitle: dashboard.floatingAvatarIcon.value ? 'Hide Floating Icons' : 'Show Floating Icons',
                    switchValue: dashboard.floatingAvatarIcon.value,
                    onItemClick: () {
                      dashboard.floatingAvatarIcon.value = !dashboard.floatingAvatarIcon.value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
                  child: listItemSwitchButton(
                    iconType: IconType.ICON,
                    leadingIcon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    itemTitle: isDark ? 'Dark Theme' : 'Light Theme',
                    switchValue: theme.isDark.value,
                    onItemClick: ()=> theme.changeTheme(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
                  child: listItemInfoIcon(
                    iconType: IconType.ICON,
                    leadingIcon:Icons.language_rounded,
                    itemTitle: AppLanguage.languageStr(appLanguage),
                    trailingIcon: arrow,
                    trailingText: appLanguage,
                    // switchValue: theme.isDark.value,
                    onItemClick: ()=> navigation.gotoLanguageScreen(isNavigation: true, isStart: false),
                  ),
                ),

              ],
            ))
          ],
        ),
      );
    });
  }
}
