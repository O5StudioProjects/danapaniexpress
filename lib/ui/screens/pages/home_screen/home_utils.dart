import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';


String setMultiLanguageText({language, urdu, english}){
  if(language == URDU_LANGUAGE){
    return urdu.toString().isNotEmpty ? urdu : english.toString().isNotEmpty ? english : urdu;
  }  else if(language == ENGLISH_LANGUAGE) {
    return english.toString().isNotEmpty ? english : urdu.toString().isNotEmpty ? urdu : english;
  } else {
    return '';
  }
}

String? setFontDynamicDataTopNotifications({language, NotificationModel? data, urdu, english}){

  if(language == URDU_LANGUAGE && data!.notificationTitleUrdu.isNotEmpty && data.notificationDetailUrdu.isNotEmpty){
    return urdu;
  } else if(language == URDU_LANGUAGE && data!.notificationTitleEnglish.isNotEmpty && data.notificationDetailEnglish.isNotEmpty){
    return english;
  } else if(language == ENGLISH_LANGUAGE && data!.notificationTitleEnglish.isNotEmpty && data.notificationDetailEnglish.isNotEmpty){
    return english;
  } else if(language == ENGLISH_LANGUAGE && data!.notificationTitleUrdu.isNotEmpty && data.notificationDetailUrdu.isNotEmpty){
    return urdu;
  } else{
    return null;
  }
}