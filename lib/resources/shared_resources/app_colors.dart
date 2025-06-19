

import 'dart:ui';

import '../../config/res_config/colors_config.dart';

class AppColors {

  static Color backgroundColorSkin(isDark) {
    if (isDark) {
      return EnvColors.backgroundColorDark;
    } else {
      return EnvColors.backgroundColorLight;
    }
  }

  static Color cardColorSkin(isDark) {
    if (isDark) {
      return EnvColors.cardColorDark;
    } else {
      return EnvColors.cardColorLight;
    }
  }

  static Color primaryTextColorSkin(isDark) {
    if (isDark) {
      return EnvColors.primaryTextColorDark;
    } else {
      return EnvColors.primaryTextColorLight;
    }
  }

  static Color dividerColorSkin(isDark) {
    if (isDark) {
      return EnvColors.dividerColorDark;
    } else {
      return EnvColors.dividerColorLight;
    }
  }


}