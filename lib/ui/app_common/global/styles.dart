import 'package:danapaniexpress/core/common_imports.dart';

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
      fontSize: appLanguage == URDU_LANGUAGE ? (HEADING_FONT_SIZE + 2.0) : HEADING_FONT_SIZE,
     // fontSize: HEADING_FONT_SIZE,
      fontFamily:  setFont(appLanguage, urdu: urduRegular, englishFont: poppinsBold)
  );
}

TextStyle headingTextStyle({height = 0.0}){
  return TextStyle(
      color: AppColors.primaryTextColorSkin(isDark),
      height: height,
      fontSize: appLanguage == URDU_LANGUAGE ? (HEADING_FONT_SIZE + 2.0) : HEADING_FONT_SIZE,
      //fontSize:  HEADING_FONT_SIZE,
      fontFamily:  setFont(appLanguage, urdu: urduSemibold, englishFont: oswaldSemibold),
      //fontWeight: appLanguage != ENGLISH_LANGUAGE ? FontWeight.bold : null
  );
}

TextStyle startupHeadingTextStyle({height = 0.0}){
  return TextStyle(
    color: AppColors.primaryHeadingTextSkin(isDark),
    height: height,
    fontSize: appLanguage == URDU_LANGUAGE ? (PRIMARY_HEADING_FONT_SIZE + 2.0) : PRIMARY_HEADING_FONT_SIZE,
    //fontSize:  PRIMARY_HEADING_FONT_SIZE,
    fontFamily:  setFont(appLanguage, urdu: urduSemibold, englishFont: oswaldSemibold),
    // fontWeight: getAppLanguage != ROMAN_URDU_ENGLISH_LANGUAGE ? FontWeight.bold : null
  );
}

TextStyle loginHeadingTextStyle({height = 0.0}){
  return TextStyle(
    color: AppColors.primaryHeadingTextSkin(isDark),
    height: height,
    fontSize: appLanguage == URDU_LANGUAGE ? (PRIMARY_HEADING_FONT_SIZE + 2.0) : PRIMARY_HEADING_FONT_SIZE,
    //fontSize:  PRIMARY_HEADING_FONT_SIZE,
    fontFamily:  setFont(appLanguage, urdu: urduSemibold, englishFont: poppinsBold),
    // fontWeight: getAppLanguage != ROMAN_URDU_ENGLISH_LANGUAGE ? FontWeight.bold : null
  );
}

TextStyle secondaryTextStyle({height = 0.0}){
  return TextStyle(
    color: AppColors.secondaryTextColorSkin(isDark),
    height: height,
    fontSize: appLanguage == URDU_LANGUAGE ? (SUB_HEADING_TEXT_BUTTON_FONT_SIZE + 2.0) : SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
    //fontSize:  PRIMARY_HEADING_FONT_SIZE,
    fontFamily:  setFont(appLanguage, urdu: urduSemibold, englishFont: robotoRegular),
    // fontWeight: getAppLanguage != ROMAN_URDU_ENGLISH_LANGUAGE ? FontWeight.bold : null
  );
}

TextStyle bodyTextStyle({height = 0.0}){
  return TextStyle(
    color: AppColors.primaryTextColorSkin(isDark),
    height: height,
    fontSize: appLanguage == URDU_LANGUAGE ? (NORMAL_TEXT_FONT_SIZE + 2.0) : NORMAL_TEXT_FONT_SIZE,
   // fontSize:  NORMAL_TEXT_FONT_SIZE,
    fontFamily:  setFont(appLanguage, urdu: urduSemibold, englishFont: robotoRegular),
    // fontWeight: getAppLanguage != ROMAN_URDU_ENGLISH_LANGUAGE ? FontWeight.bold : null
  );
}

TextStyle itemTextStyle({height = 0.0}){
  return TextStyle(
      color: AppColors.primaryTextColorSkin(isDark),
      height: height,
      fontSize: appLanguage == URDU_LANGUAGE ? (NORMAL_TEXT_FONT_SIZE + 2.0) : NORMAL_TEXT_FONT_SIZE,
      //fontSize: NORMAL_TEXT_FONT_SIZE,
      fontFamily:  setFont(appLanguage, urdu: urduRegular, englishFont: robotoRegular)
  );
}

TextStyle buttonTextStyle({color}){
  return TextStyle(
      color: color,
      height:  0.0,
      fontSize: appLanguage == URDU_LANGUAGE ? (NORMAL_TEXT_FONT_SIZE + 2.0) : NORMAL_TEXT_FONT_SIZE,
      //fontSize: NORMAL_TEXT_FONT_SIZE,
      fontFamily:  setFont(appLanguage, urdu: urduSemibold, englishFont: poppinsBold,)
  );
}

TextStyle bottomNavItemTextStyle(){
  return TextStyle(
      color: AppColors.materialButtonSkin(isDark),
      height:  0.0,
      fontSize: appLanguage == URDU_LANGUAGE ? (SUB_HEADING_TEXT_BUTTON_FONT_SIZE + 2.0) : SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
      //fontSize: NORMAL_TEXT_FONT_SIZE,
      fontFamily:  setFont(appLanguage, urdu: urduSemibold, englishFont: poppinsSemibold,)
  );
}

TextStyle appTextButtonStyle({color, fontSize = SUB_HEADING_TEXT_BUTTON_FONT_SIZE}){
  return TextStyle(
      color: color,
      height: 0.0,
      fontWeight: FontWeight.w800,
      fontSize: appLanguage == URDU_LANGUAGE ? (fontSize + 2.0) : fontSize,
      fontFamily:  setFont(appLanguage, urdu: urduRegular, englishFont: nunitoSemibold),
  );
}

TextStyle textFormHintTextStyle({height = 0.0}){
  return TextStyle(
      color: AppColors.secondaryTextColorSkin(isDark).withValues(alpha: 0.8),
      height: height,
      fontSize: appLanguage == URDU_LANGUAGE ? (NORMAL_TEXT_FONT_SIZE + 2.0) : NORMAL_TEXT_FONT_SIZE,
      fontFamily:  setFont(appLanguage, urdu: urduRegular, englishFont: interRegular)
  );
}

TextStyle sliverAppHeadingTextStyle(){
  return TextStyle(
      color: whiteColor,
      height: 0.0,
      fontSize: MEDIUM_TEXT_FONT_SIZE,
      fontFamily: setFont(appLanguage, urdu: urduRegular, englishFont: oswaldSemibold),
      fontWeight: appLanguage != ENGLISH_LANGUAGE ? FontWeight.bold : null
  );
}
TextStyle sliverAppSubHeadingTextStyle(){
  return TextStyle(
      color: whiteColor,
      fontSize: NORMAL_TEXT_FONT_SIZE-2,
      height: 0.0,
      fontFamily:  setFont(appLanguage, urdu: urduRegular, englishFont: interRegular)
  );
}

TextStyle sliverAppDescriptionTextStyle(){
  return TextStyle(
      color: whiteColor,
      fontSize: appLanguage!= URDU_LANGUAGE ? SUB_HEADING_TEXT_BUTTON_FONT_SIZE : NORMAL_TEXT_FONT_SIZE,
      height: 0.0,
      fontFamily:  setFont(appLanguage, urdu: urduRegular, englishFont: interRegular)
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

TextDirection setTextDirection(appLanguage){
  if(appLanguage == ENGLISH_LANGUAGE){
    return TextDirection.ltr;
  } else {
    return TextDirection.rtl;
  }
}