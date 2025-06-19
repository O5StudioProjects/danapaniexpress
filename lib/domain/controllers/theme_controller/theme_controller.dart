

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../core/consts.dart';
import '../../../resources/common_resources_strings/common_strings.dart';
import '../../shared_prefs/shared_prefs.dart';

class ThemeController extends GetxController {

  @override
  void onInit() {
    fetchTheme();
    fetchLanguage();
    super.onInit();
  }

  RxBool isDark = false.obs;
  RxBool internet = false.obs;
  RxString appLanguage = ENGLISH_LANGUAGE.obs;
  RxString languageScreenStatus = LANGUAGE_SCREEN_NOT_OPENED.obs;


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
    } else {
      internet.value = true;
    }
  }


  Future<void> setLanguageScreenEvent(
      {required String languageScreenStatusValue}) async {
    SharedPrefs.setLanguageScreen(languageScreenStatusValue);
    languageScreenStatus.value = languageScreenStatusValue;
  }

  Future<void> getLanguageScreenEvent() async {
    var data = await SharedPrefs.getLanguageScreen();
    languageScreenStatus.value = data;
  }

}