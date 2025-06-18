
import '../../config/res_config/anims_config.dart';

class AppAnims {

  static String animDownloadingSkin(isDark){
    if (isDark) {
      return EnvAnim.animDownloadingDark;
    } else {
      return EnvAnim.animDownloadingLight;
    }
  }

}