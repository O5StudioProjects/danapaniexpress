import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class SettingsMobile extends StatelessWidget {
  const SettingsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Get.find<ThemeController>();
    var nav = Get.find<NavigationController>();
    var dashboard = Get.find<DashBoardController>();
    var serviceArea = Get.find<ServiceAreaController>();
    return Obx((){
      var arrow = isRightLang ? icArrowLeftSmall : icArrowRightSmall;
      return _buildUI(arrow, theme, nav, dashboard, serviceArea);
    });
  }

  Widget _buildUI(arrow, theme, nav, dashboard, serviceArea){
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
                  _floatingButtonSection(dashboard),
                  _changeThemeSection(theme),
                  _changeLanguage(arrow, nav),
                  _changeCity(arrow, serviceArea, nav),
                ],
              ))
        ],
      ),
    );
  }

  Widget _floatingButtonSection(dashboard){
    return Padding(
      padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING),
      child: listItemSwitchButton(
        iconType: IconType.ICON,
        leadingIcon: dashboard.floatingIcon.value ? Icons.insert_emoticon_sharp : Icons.insert_emoticon_rounded,
        itemTitle: dashboard.floatingIcon.value ? AppLanguage.hideFloatingIconsStr(appLanguage) : AppLanguage.showFloatingIconsStr(appLanguage),
        switchValue: dashboard.floatingIcon.value,
        onItemClick: () {
          dashboard.floatingIcon.value = !dashboard.floatingIcon.value;
          SharedPrefs.setFloatingIcon(dashboard.floatingIcon.value);
        },
      ),
    );
  }

  Widget _changeThemeSection(theme){
    return Padding(
      padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
      child: listItemSwitchButton(
        iconType: IconType.ICON,
        leadingIcon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
        itemTitle: isDark ? AppLanguage.darkThemeStr(appLanguage) : AppLanguage.lightThemeStr(appLanguage),
        switchValue: theme.isDark.value,
        onItemClick: ()=> theme.changeTheme(),
      ),
    );
  }

  Widget _changeLanguage(arrow, nav){
    return Padding(
      padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
      child: listItemInfoIcon(
        iconType: IconType.ICON,
        leadingIcon:Icons.language_rounded,
        itemTitle: AppLanguage.languageStr(appLanguage),
        trailingIcon: arrow,
        trailingText: appLanguage,
        // switchValue: theme.isDark.value,
        onItemClick: ()=> nav.gotoLanguageScreen(isNavigation: true, isStart: false),
      ),
    );
  }

  Widget _changeCity(arrow, serviceArea, nav){
    return Padding(
      padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
      child: listItemInfoIcon(
        iconType: IconType.ICON,
        leadingIcon:Icons.location_on_rounded,
        itemTitle: AppLanguage.cityStr(appLanguage),
        trailingIcon: arrow,
        trailingText: serviceArea.serviceArea.value,
        // switchValue: theme.isDark.value,
        onItemClick: ()=> nav.gotoServiceAreasScreen(isStart: false),
      ),
    );
  }

}
