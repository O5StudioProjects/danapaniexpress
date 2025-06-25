
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

}