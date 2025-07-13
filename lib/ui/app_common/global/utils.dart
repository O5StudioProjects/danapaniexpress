
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
