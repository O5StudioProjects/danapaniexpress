
import 'package:danapaniexpress/core/common_imports.dart';

import '../../config/res_config/anims_config.dart';

class AppAnims {

  static String animLoadingSkin(isDark){
    if (isDark) {
      return EnvAnim.animLoadingDark;
    } else {
      return EnvAnim.animLoadingLight;
    }
  }

  static String animNotificationSkin(isDark){
    if (isDark) {
      return EnvAnim.animNotificationDark;
    } else {
      return EnvAnim.animNotificationLight;
    }
  }

  static String animErrorSkin(isDark){
    if (isDark) {
      return animErrorDark;
    } else {
      return animErrorLight;
    }
  }

  static String animEmptyCartSkin(isDark){
    if (isDark) {
      return animEmptyCartDark;
    } else {
      return animEmptyCartLight;
    }
  }
  static String animEmptyBoxSkin(isDark){
    if (isDark) {
      return animEmptyBoxDark;
    } else {
      return animEmptyBoxLight;
    }
  }

  static String animEmptyFavoritesSkin(isDark){
    if (isDark) {
      return animEmptyFavoriteDark;
    } else {
      return animEmptyFavoriteLight;
    }
  }

  static String animLoading1Skin(isDark){
    if (isDark) {
      return animLoadingDark;
    } else {
      return animLoadingLight;
    }
  }

  static String animLoading2Skin(isDark){
    if (isDark) {
      return animLoadingDark2;
    } else {
      return animLoadingLight2;
    }
  }


}