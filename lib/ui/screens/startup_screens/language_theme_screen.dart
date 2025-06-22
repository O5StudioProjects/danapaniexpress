import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class LanguageThemeScreen extends StatelessWidget {
  const LanguageThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var themeController = Get.put(ThemeController());
    var isStart = Get.arguments[IS_START];
    var isNavigation = Get.arguments[IS_NAVIGATION];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        top: false,
        child: ResponsiveLayout(
          mobileView: buildMobileUI(
            themeController: themeController,
            isNavigation: isNavigation,
            isStart: isStart,
          ),
          tabletView: buildTabletUI(),
          desktopView: buildDesktopUI(),
        ),
      ),
    );
  }
}

Widget buildMobileUI({
  required ThemeController themeController,
  isNavigation,
  isStart,
}) {
  return Obx(
    ()=> Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          appBarCommon(
            title: isStart
                ? AppLanguage.themeLanguageStr(appLanguage)
            : AppLanguage.languageStr(appLanguage),
            isBackNavigation: isNavigation,
          ),
          Expanded(
              child: SizedBox(
                width: size.width,
                child: Column(
                  crossAxisAlignment: appLanguage == ENGLISH_LANGUAGE ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    setHeight(24.0),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
                      child: appText(
                          text: AppLanguage.chooseLanguageStr(appLanguage),
                          textStyle: headingTextStyle()),
                    ),
                    setHeight(12.0),
                    showLanguageList(isDark,appLanguage, themeController: themeController),
                    setHeight(24.0),
                    isStart
                        ? Column(
                      crossAxisAlignment: appLanguage == ENGLISH_LANGUAGE ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
                          child: appText(
                              text: AppLanguage.chooseThemeStr(appLanguage),
                              textStyle: headingTextStyle()),
                        ),
                        setHeight(12.0),
                        listItemIcon(
                            iconType: IconType.ICON,
                            leadingIcon: Icons.light_mode_rounded,
                            trailingIcon: isDark ? icRadioButton : icRadioButtonSelected,
                            itemTitle: AppLanguage.lightStr(appLanguage), onItemClick: (){
                          if(isDark){
                            themeController.changeTheme();
                          }
                        }),
                        setHeight(12.0),
                        listItemIcon(
                            iconType: IconType.ICON,
                            leadingIcon: Icons.dark_mode_rounded,
                            trailingIcon: isDark ? icRadioButtonSelected : icRadioButton,
                            itemTitle:  AppLanguage.darkStr(appLanguage), onItemClick: (){
                          if(!isDark){
                            themeController.changeTheme();
                          }
                        }),
                      ],
                    )
                        : const SizedBox(),
                  ],
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: appMaterialButton(text: AppLanguage.confirmStr(appLanguage), onTap: () async {
              // await SharedPrefs.setLanguageScreen(FIRST_TIME_SCREEN_OPENED);
              // var status = await SharedPrefs.getLanguageScreen();
              // themeController.setLanguageScreenEvent(languageScreenStatusValue: FIRST_TIME_SCREEN_OPENED);
              // Navigator.pop(gContext);
              if(isStart){
                JumpTo.gotoStartupMainScreen();
              }
            }),
          ),
          setHeight(60.0)
        ],
      ),
    ),
  );
}

Widget buildTabletUI() {
  return Container();
}

Widget buildDesktopUI() {
  return Container();
}


Widget showLanguageList(isDark, language, {required ThemeController themeController}) {
  return Obx(
    ()=> Column(
      children: List.generate(languageList.length, (index) {
        var data = languageList[index];
        return Padding(padding: const EdgeInsets.only(bottom: 12.0),
          child: listItemIcon(iconType: IconType.ICON ,leadingIcon: Icons.language_rounded,

              trailingIcon: data == language ? icRadioButtonSelected : icRadioButton,

              itemTitle: data, onItemClick: (){
            themeController.changeLanguage(language: data);
              }),
        );
      }),
    ),
  );
}