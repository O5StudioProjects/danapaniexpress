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

String? setFontDynamicDataMarquee({language, MarqueeModel? data, urdu, english}){

  if(language == URDU_LANGUAGE && data!.marqueeTitleUrdu.isNotEmpty && data.marqueeDetailUrdu.isNotEmpty){
    return urdu;
  } else if(language == URDU_LANGUAGE && data!.marqueeTitleEnglish.isNotEmpty && data.marqueeDetailEnglish.isNotEmpty){
    return english;
  } else if(language == ENGLISH_LANGUAGE && data!.marqueeTitleEnglish.isNotEmpty && data.marqueeDetailEnglish.isNotEmpty){
    return english;
  } else if(language == ENGLISH_LANGUAGE && data!.marqueeTitleUrdu.isNotEmpty && data.marqueeDetailUrdu.isNotEmpty){
    return urdu;
  } else{
    return null;
  }
}

int calculateDiscount(double cutPrice, double sellingPrice) {
  if (cutPrice == 0) return 0;
  return ((cutPrice - sellingPrice) / cutPrice * 100).round();
}