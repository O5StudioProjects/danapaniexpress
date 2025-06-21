

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
  static String? nextStr(String appLanguage){
    return allLang[appLanguage]?[NEXT];
  }
  static String? chooseLanguageStr(String appLanguage){
    return allLang[appLanguage]?[CHOOSE_LANGUAGE];
  }
  static String? chooseThemeStr(String appLanguage){
    return allLang[appLanguage]?[CHOOSE_THEME];
  }
  static String? lightStr(String appLanguage){
    return allLang[appLanguage]?[LIGHT];
  }
  static String? darkStr(String appLanguage){
    return allLang[appLanguage]?[DARK];
  }
  static String? confirmStr(String appLanguage){
    return allLang[appLanguage]?[CONFIRM];
  }

  static String? getStartedStr(String appLanguage){
    return allLang[appLanguage]?[GET_STARTED];
  }
  static String? startupWelcomeHeadingStr(String appLanguage){
    return allLang[appLanguage]?[STARTUP_WELCOME_HEADING_TEXT];
  }
  static String? startupWelcomeSubtextStr(String appLanguage){
    return allLang[appLanguage]?[STARTUP_WELCOME_SUBTEXT];
  }
  static String? startShoppingStr(String appLanguage){
    return allLang[appLanguage]?[START_SHOPPING];
  }

  static String? startupFastDeliveryHeadingStr(String appLanguage){
    return allLang[appLanguage]?[STARTUP_FAST_DELIVERY_HEADING_TEXT];
  }
  static String? startupFastDeliverySubtextStr(String appLanguage){
    return allLang[appLanguage]?[STARTUP_FAST_DELIVERY_SUBTEXT];
  }
  static String? startupFreshProductsHeadingStr(String appLanguage){
    return allLang[appLanguage]?[STARTUP_FRESH_PRODUCTS_HEADING_TEXT];
  }
  static String? startupFreshProductsSubtextStr(String appLanguage){
    return allLang[appLanguage]?[STARTUP_FRESH_PRODUCTS_SUBTEXT];
  }
  static String? startupTrustedFamiliesHeadingStr(String appLanguage){
    return allLang[appLanguage]?[STARTUP_TRUSTED_FAMILIES_HEADING_TEXT];
  }
  static String? startupTrustedFamiliesSubtextStr(String appLanguage){
    return allLang[appLanguage]?[STARTUP_TRUSTED_FAMILIES_SUBTEXT];
  }
  static String? skipStr(String appLanguage){
    return allLang[appLanguage]?[SKIP];
  }

}
