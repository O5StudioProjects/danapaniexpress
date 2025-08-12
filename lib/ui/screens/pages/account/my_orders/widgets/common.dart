import 'package:danapaniexpress/core/common_imports.dart';

/// COMMON UI

Widget orderDetailItemsUI({
  titleText,
  titleTextStyle,
  detailText,
  detailTextStyle,
  isDate = false
}) {
  return isRightLang
      ? Text.rich(
    TextSpan(
      children: [
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: appText(text: detailText, textDirection: isDate ? TextDirection.ltr :  setTextDirection(appLanguage), textAlign: setTextAlignment(appLanguage),textStyle: detailTextStyle),
        ),

        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: appText(text: titleText, textDirection: setTextDirection(appLanguage),  textStyle: titleTextStyle),
        ),
      ],
    ),
  )
      : Text.rich(
    TextSpan(
      children: [
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: appText(text: titleText, textStyle: titleTextStyle),
        ),
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: appText(text: detailText, textStyle: detailTextStyle),
        ),
      ],
    ),
  );
}

Widget orderDetailItemsFixedUI({
  titleText,
  titleColor,
  detailText,
  detailColor,
  detailBgColor,
  isDate = false
}) {
  return isRightLang
      ? Row(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
        decoration: BoxDecoration(
          color: detailBgColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: appText(
          text: detailText,
          textStyle: bodyTextStyle().copyWith(
            fontSize: NORMAL_TEXT_FONT_SIZE,
            color: detailColor ?? AppColors.primaryTextColorSkin(isDark),
          ),
        ),
      ),
      Expanded(
        child: appText(
          text: titleText,
          textDirection: isDate ? TextDirection.ltr : setTextDirection(appLanguage),
          textAlign: isDate ? TextAlign.end : TextAlign.start,
          textStyle: itemTextStyle().copyWith(fontWeight: FontWeight.w800,
            color: titleColor ??  AppColors.primaryTextColorSkin(isDark),
          ),
        ),
      ),

    ],
  )
      : Row(
    children: [
      Expanded(
        child: appText(
          text: titleText,
          textStyle: itemTextStyle().copyWith(fontWeight: FontWeight.w800,
            color: titleColor ??  AppColors.primaryTextColorSkin(isDark),
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
        decoration: BoxDecoration(
          color: detailBgColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: appText(
          text: detailText,
          textStyle: bodyTextStyle().copyWith(
            fontSize: NORMAL_TEXT_FONT_SIZE - 2,
            color: detailColor ?? AppColors.primaryTextColorSkin(isDark),
          ),
        ),
      ),
    ],
  );
}