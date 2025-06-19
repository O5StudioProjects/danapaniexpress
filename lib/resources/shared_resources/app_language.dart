

import '../../languages/languages_consts.dart';
import '../../languages/languages_map.dart';

class AppLanguage {

  static String? appNameStr(String language){
    return allLang[language]?[APP_NAME];
  }

  static String? navHomeStr(String language){
    return allLang[language]?[HOME];
  }

}