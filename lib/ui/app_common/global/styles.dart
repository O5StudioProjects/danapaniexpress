import 'package:danapaniexpress/core/common_imports.dart';


TextStyle splashHeadingTextStyle(){
  return TextStyle(
      color: whiteColor,
      height: 0.0,
      fontSize: SPLASH_HEADING_TEXT_FONT_SIZE,
      fontFamily:  setFont(appLanguage),
      fontWeight: isRightLang ? FontWeight.bold : null
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
      fontSize: isRightLang ? (HEADING_FONT_SIZE + 2.0) : HEADING_FONT_SIZE,
     // fontSize: HEADING_FONT_SIZE,
      fontFamily:  setFont(appLanguage, urdu: urduRegular, englishFont: poppinsBold)
  );
}

TextStyle headingTextStyle({height = 0.0}){
  return TextStyle(
      color: AppColors.primaryTextColorSkin(isDark),
      height: height,
      fontSize: isRightLang ? (HEADING_FONT_SIZE + 2.0) : HEADING_FONT_SIZE,
      //fontSize:  HEADING_FONT_SIZE,
      fontFamily:  setFont(appLanguage, urdu: urduSemibold, englishFont: oswaldSemibold),
      //fontWeight: appLanguage != ENGLISH_LANGUAGE ? FontWeight.bold : null
  );
}

TextStyle startupHeadingTextStyle({height = 0.0}){
  return TextStyle(
    color: AppColors.primaryHeadingTextSkin(isDark),
    height: height,
    fontSize: isRightLang ? (PRIMARY_HEADING_FONT_SIZE + 2.0) : PRIMARY_HEADING_FONT_SIZE,
    //fontSize:  PRIMARY_HEADING_FONT_SIZE,
    fontFamily:  setFont(appLanguage, urdu: urduSemibold, englishFont: oswaldSemibold),
    // fontWeight: getAppLanguage != ROMAN_URDU_ENGLISH_LANGUAGE ? FontWeight.bold : null
  );
}

TextStyle bigBoldHeadingTextStyle({height = 0.0}){
  return TextStyle(
    color: AppColors.primaryHeadingTextSkin(isDark),
    height: height,
    fontSize: isRightLang ? (PRIMARY_HEADING_FONT_SIZE + 2.0) : PRIMARY_HEADING_FONT_SIZE,
    //fontSize:  PRIMARY_HEADING_FONT_SIZE,
    fontFamily:  setFont(appLanguage, urdu: urduSemibold, englishFont: poppinsBold),
    // fontWeight: getAppLanguage != ROMAN_URDU_ENGLISH_LANGUAGE ? FontWeight.bold : null
  );
}

TextStyle secondaryTextStyle({height = 0.0}){
  return TextStyle(
    color: AppColors.secondaryTextColorSkin(isDark),
    height: height,
    fontSize: isRightLang ? (SUB_HEADING_TEXT_BUTTON_FONT_SIZE + 2.0) : SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
    //fontSize:  PRIMARY_HEADING_FONT_SIZE,
    fontFamily:  setFont(appLanguage, urdu: urduSemibold, englishFont: robotoRegular),
    // fontWeight: getAppLanguage != ROMAN_URDU_ENGLISH_LANGUAGE ? FontWeight.bold : null
  );
}

TextStyle accountSecondaryTextStyle({height = 0.0}){
  return TextStyle(
    color: AppColors.secondaryTextColorSkin(isDark),
    height: height,
    fontSize: isRightLang ? (SUB_HEADING_TEXT_BUTTON_FONT_SIZE + 2.0) : SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
    //fontSize:  PRIMARY_HEADING_FONT_SIZE,
    fontFamily:  setFont(appLanguage, urdu: urduSemibold, englishFont: nunitoMedium),
    // fontWeight: getAppLanguage != ROMAN_URDU_ENGLISH_LANGUAGE ? FontWeight.bold : null
  );
}

TextStyle bodyTextStyle({height = 0.0}){
  return TextStyle(
    color: AppColors.primaryTextColorSkin(isDark),
    height: height,
    fontSize: isRightLang ? (NORMAL_TEXT_FONT_SIZE + 2.0) : NORMAL_TEXT_FONT_SIZE,
   // fontSize:  NORMAL_TEXT_FONT_SIZE,
    fontFamily:  setFont(appLanguage, urdu: urduSemibold, englishFont: robotoRegular),
    // fontWeight: getAppLanguage != ROMAN_URDU_ENGLISH_LANGUAGE ? FontWeight.bold : null
  );
}

TextStyle bodyAutoTextStyle({height = 0.0, text}){
  final bool isUrdu = isTextUrdu(text);
  return TextStyle(
    color: AppColors.primaryTextColorSkin(isDark),
    height: height,
    fontSize: isUrdu ? (NORMAL_TEXT_FONT_SIZE + 2.0) : NORMAL_TEXT_FONT_SIZE,
    // fontSize:  NORMAL_TEXT_FONT_SIZE,
    fontFamily:  setAutoFont(text, urdu: urduSemibold, englishFont: robotoRegular),
    // fontWeight: getAppLanguage != ROMAN_URDU_ENGLISH_LANGUAGE ? FontWeight.bold : null
  );
}

TextStyle itemTextStyle({height = 0.0}){
  return TextStyle(
      color: AppColors.primaryTextColorSkin(isDark),
      height: height,
      fontSize: isRightLang ? (NORMAL_TEXT_FONT_SIZE) : NORMAL_TEXT_FONT_SIZE -2.0,
      //fontSize: NORMAL_TEXT_FONT_SIZE,
      fontFamily:  setFont(appLanguage, urdu: urduRegular, englishFont: nunitoSemibold),
    fontWeight: FontWeight.w800
  );
}
TextStyle dateItemTextStyle({height = 0.0}){
  return TextStyle(
      color: AppColors.primaryTextColorSkin(isDark),
      height: height,
      fontSize: isRightLang ? (NORMAL_TEXT_FONT_SIZE) : NORMAL_TEXT_FONT_SIZE -2.0,
      //fontSize: NORMAL_TEXT_FONT_SIZE,
      fontFamily:  setFont(appLanguage, urdu: urduRegular, englishFont: nunitoSemibold),
      fontWeight: FontWeight.w800,

  );
}

TextStyle tabItemTextStyle({height = 0.0, required bool isSelected}){
  return TextStyle(
      color: isSelected ? AppColors.selectedTabItemsTextColorSkin(isDark) : AppColors.tabItemsTextColorSkin(isDark),
      height: height,
      fontSize: isRightLang ? (NORMAL_TEXT_FONT_SIZE) : NORMAL_TEXT_FONT_SIZE -2.0,
      //fontSize: NORMAL_TEXT_FONT_SIZE,
      fontFamily:  setFont(appLanguage, urdu: urduRegular, englishFont: nunitoSemibold),
      fontWeight: FontWeight.w800
  );
}


TextStyle cutPriceTextStyle({height = 0.0, isDetail = false}){
  return TextStyle(
      color: isDetail ? AppColors.cutPriceDetailTextColorSkin(isDark) : AppColors.secondaryTextColorSkin(isDark),
      height: height,
      decoration: TextDecoration.lineThrough,
      decorationThickness: 2,
      decorationColor: AppColors.primaryTextColorSkin(isDark),
      fontSize: NORMAL_TEXT_FONT_SIZE -2.0,
      //fontSize: NORMAL_TEXT_FONT_SIZE,
      fontFamily:  setFont(appLanguage, urdu: nunitoSemibold, englishFont: nunitoSemibold)
  );
}


TextStyle sellingPriceTextStyle({height = 0.0}){
  return TextStyle(
      color: AppColors.sellingPriceTextSkin(isDark),
      height: height,
      fontSize: NORMAL_TEXT_FONT_SIZE ,
      //fontSize: NORMAL_TEXT_FONT_SIZE,
      fontFamily:  setFont(appLanguage, urdu: oswaldSemibold, englishFont: oswaldSemibold)
  );
}
TextStyle sellingPriceDetailTextStyle({height = 0.0}){
  return TextStyle(
      color: AppColors.sellingPriceDetailTextSkin(isDark),
      height: height,
      fontSize: INDEX_FONT_SIZE ,
      //fontSize: NORMAL_TEXT_FONT_SIZE,
      fontFamily:  setFont(appLanguage, urdu: oswaldSemibold, englishFont: oswaldSemibold)
  );
}

TextStyle buttonTextStyle({color}){
  return TextStyle(
      color: color,
      height:  0.0,
      fontSize: isRightLang ? (NORMAL_TEXT_FONT_SIZE + 2.0) : NORMAL_TEXT_FONT_SIZE,
      //fontSize: NORMAL_TEXT_FONT_SIZE,
      fontFamily:  setFont(appLanguage, urdu: urduSemibold, englishFont: poppinsBold,)
  );
}

TextStyle bottomNavItemTextStyle(){
  return TextStyle(
      color: AppColors.materialButtonSkin(isDark),
      height:  0.0,
      fontSize: isRightLang ? (SUB_HEADING_TEXT_BUTTON_FONT_SIZE + 2.0) : SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
      //fontSize: NORMAL_TEXT_FONT_SIZE,
      fontFamily:  setFont(appLanguage, urdu: urduSemibold, englishFont: poppinsSemibold,)
  );
}

TextStyle appTextButtonStyle({color, fontSize = SUB_HEADING_TEXT_BUTTON_FONT_SIZE}){
  return TextStyle(
      color: color,
      height: 0.0,
      fontWeight: FontWeight.w800,
      fontSize: isRightLang ? (fontSize + 2.0) : fontSize,
      fontFamily:  setFont(appLanguage, urdu: urduRegular, englishFont: nunitoSemibold),
  );
}

TextStyle textFormHintTextStyle({height = 0.0}){
  return TextStyle(
      color: AppColors.secondaryTextColorSkin(isDark).withValues(alpha: 0.8),
      height: height,
      fontSize: isRightLang ? (NORMAL_TEXT_FONT_SIZE + 2.0) : NORMAL_TEXT_FONT_SIZE,
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
      fontSize: !isRightLang ? SUB_HEADING_TEXT_BUTTON_FONT_SIZE : NORMAL_TEXT_FONT_SIZE,
      height: 0.0,
      fontFamily:  setFont(appLanguage, urdu: urduRegular, englishFont: interRegular)
  );
}

TextStyle marqueeDynamicTextStyle({data}){
  return TextStyle(
      color: AppColors.primaryTextColorSkin(isDark),
      fontSize: isRightLang ? (NORMAL_TEXT_FONT_SIZE + 2.0) : NORMAL_TEXT_FONT_SIZE,
      height: 0.0,
      fontFamily:  setFont(appLanguage,
        urdu: setFontDynamicDataMarquee(language: appLanguage, data: data, urdu: urduRegular,  english: poppinsRegular),
        englishFont: setFontDynamicDataMarquee(language: appLanguage, data: data, urdu: urduRegular, english: poppinsRegular),
      )
  );
}
TextStyle marqueeTextStyle(){
  return TextStyle(
      color: AppColors.primaryTextColorSkin(isDark),
      fontSize: isRightLang ? (NORMAL_TEXT_FONT_SIZE + 2.0) : NORMAL_TEXT_FONT_SIZE,
      height: 0.0,
      fontFamily:  setFont(appLanguage, urdu: urduRegular,  englishFont: poppinsRegular
      )
  );
}

TextStyle accountHeaderNameTextStyle({height = 0.0, text}){
  final bool isUrdu = isTextUrdu(text);

  return TextStyle(
    color: AppColors.primaryHeadingTextSkin(isDark),
    height: height,
    fontSize: isUrdu ? (ACCOUNT_TITLE_FONT_SIZE + 2.0) : ACCOUNT_TITLE_FONT_SIZE,
    fontFamily:  isUrdu ? urduSemibold : poppinsBold

  );
}

TextStyle snackBarTitleTextStyle({text, isError}){
  final bool isUrdu = isTextUrdu(text);

  return TextStyle(
      color: isError ? whiteColor :  AppColors.materialButtonTextSkin(isDark),
      fontSize: isUrdu ? (NORMAL_TEXT_FONT_SIZE + 2.0) : NORMAL_TEXT_FONT_SIZE,
      fontFamily:  isUrdu ? urduSemibold : poppinsBold,
      fontWeight: isUrdu ? FontWeight.w800 : null
  );
}

TextStyle snackBarMessageTextStyle({text, isError}){
  final bool isUrdu = isTextUrdu(text);

  return TextStyle(
      color: isError ? whiteColor :  AppColors.materialButtonTextSkin(isDark),
      fontSize: isUrdu ? (NORMAL_TEXT_FONT_SIZE + 2.0) : NORMAL_TEXT_FONT_SIZE,
      fontFamily:  isUrdu ? urduSemibold : nunitoSemibold
  );
}

TextStyle editingFormTextStyle({height = 0.0, text}){
  final bool isUrdu = isTextUrdu(text);
  return TextStyle(
    color: AppColors.primaryTextColorSkin(isDark),
    height: height,
    fontSize: isUrdu ? (NORMAL_TEXT_FONT_SIZE + 2.0) : NORMAL_TEXT_FONT_SIZE,
    // fontSize:  NORMAL_TEXT_FONT_SIZE,
    fontFamily:  setAutoFont(text, urdu: urduSemibold, englishFont: robotoRegular),
    // fontWeight: getAppLanguage != ROMAN_URDU_ENGLISH_LANGUAGE ? FontWeight.bold : null
  );
}

// SecondaryTextStyle
TextStyle secondaryAutoTextStyle({height = 0.0, text}){
  final bool isUrdu = isTextUrdu(text);
  return TextStyle(
    color: AppColors.secondaryTextColorSkin(isDark),
    height: height,
    fontSize: isUrdu ? (SUB_HEADING_TEXT_BUTTON_FONT_SIZE + 2.0) : SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
    //fontSize:  PRIMARY_HEADING_FONT_SIZE,
    fontFamily:  setAutoFont(text, urdu: urduSemibold, englishFont: robotoRegular),
    // fontWeight: getAppLanguage != ROMAN_URDU_ENGLISH_LANGUAGE ? FontWeight.bold : null
  );
}

TextStyle addressItemTextStyle({height = 0.0,text}){
  final bool isUrdu = isTextUrdu(text);
  return TextStyle(
      color: AppColors.primaryTextColorSkin(isDark),
      height: height,
      fontSize: isUrdu ? (NORMAL_TEXT_FONT_SIZE) : NORMAL_TEXT_FONT_SIZE -2.0,
      //fontSize: NORMAL_TEXT_FONT_SIZE,
      fontFamily:  setAutoFont(appLanguage, urdu: urduRegular, englishFont: nunitoSemibold),
      fontWeight: FontWeight.w800
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

String setAutoFont(text, {englishFont = robotoRegular, urdu = urduRegular}){
  final bool isUrdu = isTextUrdu(text);
  return isUrdu ? urdu : englishFont;
}


TextDirection setTextDirection(appLanguage){
  if(appLanguage == !isRightLang){
    return TextDirection.ltr;
  } else {
    return TextDirection.rtl;
  }

}

TextAlign setTextAlignment(appLanguage){
  if(appLanguage == !isRightLang){
    return TextAlign.left;
  } else {
    return TextAlign.right;
  }

}

TextDirection setAutoTextDirection(text){
  final bool isUrdu = isTextUrdu(text);
  return isUrdu ? TextDirection.rtl : TextDirection.ltr;
}

TextAlign setAutoTextAlignment(text){
  final bool isUrdu = isTextUrdu(text);
  return isUrdu ? TextAlign.right : TextAlign.left;
}