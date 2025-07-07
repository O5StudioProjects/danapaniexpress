

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

  static Color disableMaterialButtonSkin(isDark) {
    if (isDark) {
      return EnvColors.secondaryTextColorLight;
    } else {
      return EnvColors.secondaryTextColorLight;
    }
  }

  static Color sellingPriceTextSkin(isDark) {
    if (isDark) {
      return EnvColors.accentCTAColorDark;
    } else {
      return EnvColors.primaryColorLight;
    }
  }
  static Color sellingPriceDetailTextSkin(isDark) {
    if (isDark) {
      return EnvColors.primaryColorLight;
    } else {
      return EnvColors.accentCTAColorDark;
    }
  }

  static Color cutPriceDetailTextColorSkin(isDark) {
    if (isDark) {
      return EnvColors.accentCTAColorDark;
    } else {
      return EnvColors.secondaryTextColorLight;
    }
  }

  static Color percentageTextSkin(isDark) {
    if (isDark) {
      return EnvColors.primaryColorLight;
    } else {
      return EnvColors.accentCTAColorDark;
    }
  }

  static Color floatingButtonSkin(isDark) {
    if (isDark) {
      return EnvColors.accentCTAColorDark;
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
  static Color selectedTabItemsColorSkin(isDark) {
    if (isDark) {
      return EnvColors.accentCTAColorDark;
    } else {
      return EnvColors.primaryColorDark;
    }
  }
  static Color tabItemsColorSkin(isDark) {
    if (isDark) {
      return EnvColors.cardColorDark;
    } else {
      return EnvColors.cardColorLight;
    }
  }

  static Color selectedTabItemsTextColorSkin(isDark) {
    if (isDark) {
      return EnvColors.backgroundColorDark;
    } else {
      return EnvColors.primaryTextColorDark;
    }
  }
  static Color tabItemsTextColorSkin(isDark) {
    if (isDark) {
      return EnvColors.secondaryTextColorDark;
    } else {
      return EnvColors.secondaryTextColorLight;
    }
  }

}