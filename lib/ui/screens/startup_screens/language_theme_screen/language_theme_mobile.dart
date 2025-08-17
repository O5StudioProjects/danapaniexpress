import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class LanguageThemeMobile extends StatelessWidget {
  const LanguageThemeMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI(){
    var themeController = Get.put(ThemeController());
    var isStart = Get.arguments[IS_START];
    var isNavigation = Get.arguments[IS_NAVIGATION];
    return Obx((){
      var navigation = Get.find<NavigationController>();
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            _appBar(isStart, isNavigation),
            Expanded(
                child: SizedBox(
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: !isRightLang ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      _chooseLanguageHeading(),

                      ShowLanguageList(),
                      setHeight(24.0),
                      _themeSelectionMain(isStart, themeController),
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(left: MAIN_HORIZONTAL_PADDING, right: MAIN_HORIZONTAL_PADDING, bottom: 60.0),
              child: appMaterialButton(text: AppLanguage.confirmStr(appLanguage), onTap: () async {
                await SharedPrefs.setLanguageScreen(FIRST_TIME_SCREEN_OPENED);
                // var status = await SharedPrefs.getLanguageScreen();
                themeController.setLanguageScreenEvent(languageScreenStatusValue: FIRST_TIME_SCREEN_OPENED);

                if(isStart){
                  navigation.gotoStartupMainScreen();
                } else {
                  Get.back();
                }
              }),
            ),
          ],
        ),
      );
    });

  }


  Widget _appBar(isStart, isNavigation){
    return appBarCommon(
      title: isStart
          ? AppLanguage.themeLanguageStr(appLanguage)
          : AppLanguage.languageStr(appLanguage),
      isBackNavigation: isNavigation,
    );
  }

  Widget _chooseLanguageHeading(){
    return Padding(
      padding: const EdgeInsets.only(left: MAIN_HORIZONTAL_PADDING, right: MAIN_HORIZONTAL_PADDING, top: 24.0, bottom: 12.0),
      child: appText(
          text: AppLanguage.chooseLanguageStr(appLanguage),
          textStyle: headingTextStyle()),
    );
  }

  Widget _themeSelectionMain(isStart, themeController){
    return
      isStart
          ? Column(
        crossAxisAlignment: !isRightLang ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          _chooseThemeHeading(),

          _lightTheme(themeController),

          _darkTheme(themeController),
        ],
      )
          : const SizedBox();
  }

  Widget _chooseThemeHeading(){
    return Padding(
      padding: const EdgeInsets.only(left: MAIN_HORIZONTAL_PADDING, right: MAIN_HORIZONTAL_PADDING, bottom: 12.0),
      child: appText(
          text: AppLanguage.chooseThemeStr(appLanguage),
          textStyle: headingTextStyle()),
    );
  }

  Widget _lightTheme(themeController){
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: listItemIcon(
          iconType: IconType.ICON,
          leadingIcon: Icons.light_mode_rounded,
          trailingIcon: isDark ? icRadioButton : icRadioButtonSelected,
          itemTitle: AppLanguage.lightStr(appLanguage), onItemClick: (){
        if(isDark){
          themeController.changeTheme();
        }
      }),
    );
  }

  Widget _darkTheme(themeController){
    return listItemIcon(
        iconType: IconType.ICON,
        leadingIcon: Icons.dark_mode_rounded,
        trailingIcon: isDark ? icRadioButtonSelected : icRadioButton,
        itemTitle:  AppLanguage.darkStr(appLanguage), onItemClick: (){
      if(!isDark){
        themeController.changeTheme();
      }
    });
  }

}
