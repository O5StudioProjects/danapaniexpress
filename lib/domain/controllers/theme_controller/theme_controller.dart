
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/packages_import.dart';

class ThemeController extends GetxController {

  @override
  void onInit() async {
    await fetchTheme();
    await fetchLanguage();
    await getLanguageScreenEvent();
    await getStartupScreenPrefsEvent();
    super.onInit();
  }

  RxBool isDark = false.obs;
  RxBool internet = false.obs;
  RxString appLanguage = ENGLISH_LANGUAGE.obs;
  RxString languageScreenStatus = FIRST_TIME_SCREEN_NOT_OPENED.obs;
  RxString StartupScreenStatus = FIRST_TIME_SCREEN_NOT_OPENED.obs;


  Future<void> changeTheme() async {
    if(isDark.value){
      await SharedPrefs.setDarkTheme(false);
      isDark.value = false;
    } else {
      await SharedPrefs.setDarkTheme(true);
      isDark.value = true;
    }
  }

  Future<void> fetchTheme() async {
    isDark.value = await SharedPrefs.getTheme();
  }

  Future<void> changeLanguage({language}) async {
    if(appLanguage == language){
      appLanguage.value = language;
      return;
    } 
    if(language == ENGLISH_LANGUAGE){
      appLanguage.value = ENGLISH_LANGUAGE;
      await SharedPrefs.setLanguage(ENGLISH_LANGUAGE);
    }
    else if(language == URDU_LANGUAGE){
      appLanguage.value = URDU_LANGUAGE;
      await SharedPrefs.setLanguage(URDU_LANGUAGE);

    }
     else {
      appLanguage.value = ENGLISH_LANGUAGE;
      await SharedPrefs.setLanguage(ENGLISH_LANGUAGE);
    }
    print(appLanguage.value);

  }

  Future<void> fetchLanguage() async {
    appLanguage.value = await SharedPrefs.getLanguage();
  }

  Future<void> updateInternetConnection({required List<ConnectivityResult> event}) async {
    if(event.contains(ConnectivityResult.none)){
      internet.value = false;
     // Get.find<NavigationController>().gotoNoInternetScreen();
    } else {
      internet.value = true;
    }
  }


  ///FIRST TIME OPENING FOR LANGUAGE SCREEN

  Future<void> setLanguageScreenEvent(
      {required String languageScreenStatusValue}) async {
    await SharedPrefs.setLanguageScreen(languageScreenStatusValue);
    languageScreenStatus.value = languageScreenStatusValue;
  }

  Future<void> getLanguageScreenEvent() async {
    var data = await SharedPrefs.getLanguageScreen();
    languageScreenStatus.value = data;
  }

  ///FIRST TIME OPENING FOR STARTUP SCREEN

  Future<void> setStartupScreenPrefsEvent(
      {required String startupScreenStatusValue}) async {
    await SharedPrefs.setStartupScreenPrefs(startupScreenStatusValue);
    StartupScreenStatus.value = startupScreenStatusValue;
  }

  Future<void> getStartupScreenPrefsEvent() async {
    var data = await SharedPrefs.getStartupScreenPrefs();
    StartupScreenStatus.value = data;
  }


}