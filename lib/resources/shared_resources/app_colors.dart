

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

  static Color backgroundColorInverseSkin(isDark) {
    if (isDark) {
      return EnvColors.backgroundColorLight;
    } else {
      return EnvColors.backgroundColorDark;
    }
  }

  static Color materialButtonSkin(isDark) {
    if (isDark) {
      return EnvColors.cardColorLight;
    } else {
      return EnvColors.primaryColorLight;
    }
  }

  static Color primaryHeadingTextSkin(isDark) {
    if (isDark) {
      return EnvColors.primaryTextColorDark;
    } else {
      return EnvColors.primaryColorLight;
    }
  }


  static Color materialButtonTextSkin(isDark) {
    if (isDark) {
      return EnvColors.primaryTextColorLight;
    } else {
      return EnvColors.primaryTextColorDark;
    }
  }

  static Color appBarColorSkin(isDark) {
    if (isDark) {
      return EnvColors.cardColorDark;
    } else {
      return EnvColors.cardColorLight;
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

  static Color secondaryTextColorSkin(isDark) {
    if (isDark) {
      return EnvColors.secondaryTextColorDark;
    } else {
      return EnvColors.secondaryTextColorLight;
    }
  }

  static Color secondaryTextColorInverseSkin(isDark) {
    if (isDark) {
      return EnvColors.secondaryTextColorLight;
    } else {
      return EnvColors.secondaryTextColorDark;
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