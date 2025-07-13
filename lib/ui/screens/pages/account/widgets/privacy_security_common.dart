import '../../../../../core/common_imports.dart';

Widget mainTitle(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING, bottom: 8.0),
    child: Text(
      text,
      style: bigBoldHeadingTextStyle(),
      textDirection: appLanguage == URDU_LANGUAGE ? TextDirection.rtl : TextDirection.ltr,
    ),
  );
}

Widget sectionTitle(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 8),
    child: Text(
      text,
      style: bigBoldHeadingTextStyle().copyWith(fontSize: 18.0),
      textDirection: appLanguage == URDU_LANGUAGE ? TextDirection.rtl : TextDirection.ltr,
    ),
  );
}

Widget sectionBody(String text) {
  return Directionality(
    textDirection: appLanguage == URDU_LANGUAGE ? TextDirection.rtl : TextDirection.ltr,
    child: Text(
      text,
      style: bodyTextStyle(),
    ),
  );
}