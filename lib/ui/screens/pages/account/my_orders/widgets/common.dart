import 'package:danapaniexpress/core/common_imports.dart';

/// COMMON UI

Widget orderDetailItemsUI({
  titleText,
  titleTextStyle,
  detailText,
  detailTextStyle,
  isDateTime = false
}) {
  return Text.rich(
    // textDirection: setTextDirection(appLanguage), textAlign: setTextAlignment(appLanguage),
    isRightLang
    ? TextSpan(
      children: [
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: appText(text: detailText, textDirection: isDateTime ? TextDirection.ltr : setTextDirection(appLanguage), textAlign: setTextAlignment(appLanguage), textStyle: detailTextStyle),
        ),
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: appText(text: titleText,  textDirection:  setTextDirection(appLanguage), textAlign: setTextAlignment(appLanguage), textStyle: titleTextStyle),
        ),
      ],
    )
    : TextSpan(
      children: [
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: appText(text: titleText, textDirection: setTextDirection(appLanguage), textAlign: setTextAlignment(appLanguage), textStyle: titleTextStyle),
        ),
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: appText(text: detailText, textDirection: setTextDirection(appLanguage), textAlign: setTextAlignment(appLanguage), textStyle: detailTextStyle),
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
}) {
  return Row(
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