

import '../../languages/languages_consts.dart';
import '../../languages/languages_map.dart';

class AppLanguage {

  static String? appNameStr(String appLanguage){
    return allLang[appLanguage]?[APP_NAME];
  }
  static String? navHomeStr(String appLanguage){
    return allLang[appLanguage]?[HOME];
  }
  static String? developedByStr(String appLanguage){
    return allLang[appLanguage]?[DEVELOPED_BY];
  }
  static String? languageStr(String appLanguage){
    return allLang[appLanguage]?[LANGUAGE_ONLY];
  }
  static String? themeLanguageStr(String appLanguage){
    return allLang[appLanguage]?[THEME_LANGUAGE];
  }
  static String? nextStr(String language){
    return allLang[language]?[NEXT];
  }
  static String? chooseLanguageStr(String language){
    return allLang[language]?[CHOOSE_LANGUAGE];
  }
  static String? chooseThemeStr(String language){
    return allLang[language]?[CHOOSE_THEME];
  }
  static String? lightStr(String language){
    return allLang[language]?[LIGHT];
  }
  static String? darkStr(String language){
    return allLang[language]?[DARK];
  }
}