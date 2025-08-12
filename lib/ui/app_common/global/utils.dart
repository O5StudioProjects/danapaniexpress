
import 'package:danapaniexpress/core/common_imports.dart';

Widget setIcon({ iconType,iconName, color, isPngColor = false }){
  if(iconType == IconType.ICON){
    return Icon(iconName, size: 24.0, color: color);
  } else if(iconType == IconType.SVG){
    return appSvgIcon(icon: iconName, width: 24.0, color: color);
  } else {
    return Image.asset(iconName, color: isPngColor ? color : null, width: 24.0, fit: BoxFit.fitWidth,);
  }
}

bool isTextUrdu(String text) {
  if (text.isEmpty) return false;

  int urduCount = 0;
  for (int rune in text.runes) {
    if (rune >= 0x0600 && rune <= 0x06FF) {
      urduCount++;
    }
  }

  return urduCount > 0;
}


LanguageScript detectLanguageScript(String text) {
  if (text.isEmpty) return LanguageScript.unknown;

  int urduCount = 0;
  int arabicCount = 0;
  int hindiCount = 0;
  int englishCount = 0;
  int latinCount = 0;

  for (int rune in text.runes) {
    if (rune >= 0x0600 && rune <= 0x06FF) {
      // Urdu script range
      urduCount++;
    } else if (rune >= 0x0750 && rune <= 0x077F) {
      // Arabic Supplement
      arabicCount++;
    } else if (rune >= 0x0900 && rune <= 0x097F) {
      // Hindi (Devanagari)
      hindiCount++;
    } else if ((rune >= 0x0041 && rune <= 0x005A) || (rune >= 0x0061 && rune <= 0x007A)) {
      // A–Z, a–z (English alphabet)
      englishCount++;
      latinCount++;
    } else if ((rune >= 0x0020 && rune <= 0x003A) || // punctuation, space
        (rune >= 0x00C0 && rune <= 0x024F)) { // extended Latin letters
      latinCount++;
    }
  }

  // Decide based on highest count
  if (urduCount > arabicCount && urduCount > hindiCount && urduCount > englishCount && urduCount > latinCount) {
    return LanguageScript.urdu;
  } else if (arabicCount > hindiCount && arabicCount > englishCount && arabicCount > latinCount) {
    return LanguageScript.arabic;
  } else if (hindiCount > englishCount && hindiCount > latinCount) {
    return LanguageScript.hindi;
  } else if (englishCount > latinCount) {
    return LanguageScript.english;
  } else if (latinCount > 0) {
    return LanguageScript.latin;
  }

  return LanguageScript.unknown;
}