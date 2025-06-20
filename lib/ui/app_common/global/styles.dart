import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/packages_import.dart';

TextStyle splashHeadingTextStyle(){
  return TextStyle(
      color: whiteColor,
      height: 0.0,
      fontSize: SPLASH_HEADING_TEXT_FONT_SIZE,
      fontFamily:  setFont(appLanguage),
      fontWeight: appLanguage != ENGLISH_LANGUAGE ? FontWeight.bold : null
  );
}

TextStyle splashBodyTextStyle({height = 0.0}){
  return TextStyle(
      color: EnvColors.secondaryTextColorLight,
      height: height,
      fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
      fontFamily:  setFont(appLanguage)
  );
}

TextStyle appBarTextStyle(){
  return TextStyle(
      color: AppColors.primaryTextColorSkin(isDark),
      height: 0.0,
      fontSize: HEADING_FONT_SIZE,
      fontFamily:  setFont(appLanguage, urdu: urduRegular, englishFont: poppinsBold)
  );
}

TextStyle headingTextStyle({height = 0.0}){
  return TextStyle(
      color: AppColors.primaryTextColorSkin(isDark),
      height: height,
      //fontSize: getAppLanguage == URDU_LANGUAGE ? (HEADING_FONT_SIZE + 2.0) : HEADING_FONT_SIZE,
      fontSize:  HEADING_FONT_SIZE,
      fontFamily:  setFont(appLanguage, urdu: urduSemibold, englishFont: oswaldSemibold),
      // fontWeight: getAppLanguage != ROMAN_URDU_ENGLISH_LANGUAGE ? FontWeight.bold : null
  );
}

TextStyle itemTextStyle({height = 0.0}){
  return TextStyle(
      color: AppColors.primaryTextColorSkin(isDark),
      height: height,
      fontSize: NORMAL_TEXT_FONT_SIZE,
      fontFamily:  setFont(appLanguage, urdu: urduRegular, englishFont: robotoRegular)
  );
}

TextStyle buttonTextStyle({color}){
  return TextStyle(
      color: color,
      height:  0.0,
      fontSize: NORMAL_TEXT_FONT_SIZE,
      fontFamily:  setFont(appLanguage, urdu: urduSemibold, englishFont: poppinsBold,)
  );
}




String setFont(language, {englishFont = robotoRegular, urdu = urduRegular}){
  if(language == URDU_LANGUAGE){
    return urdu;
  }
  else{
    return englishFont;
  }
}