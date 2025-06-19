import '../../core/common_imports.dart';
import '../../data/enums/enums.dart';

abstract class EnvImages {
  static late String imgSplashLogo;
  static late String imgCoverTop;
  static late String imgCoverCircleDp;
  static late String imgAppCircleLogo;

  static late Flavor _environment;
  static Flavor get environment => _environment;

  static setUpAppImages(Flavor environment) {
    _environment = environment;
    switch (environment) {
      case Flavor.dev:
        imgSplashLogo = AppImagesPath.imgSplash_Dev;
        imgCoverTop = AppImagesPath.imgCoverTop_Dev;
        imgCoverCircleDp = AppImagesPath.imgCoverCircleDp_Dev;
        imgAppCircleLogo = AppImagesPath.imgAppCircleLogo_Dev;

        break;

      case Flavor.prod:
        imgSplashLogo = AppImagesPath.imgSplash_ZainShakeel;
        imgCoverTop = AppImagesPath.imgCoverTop_ZainShakeel;
        imgCoverCircleDp = AppImagesPath.imgCoverCircleDp_ZainShakeel;
        imgAppCircleLogo = AppImagesPath.imgAppCircleLogo_ZainShakeel;

        break;

      case Flavor.rider:
        imgSplashLogo = AppImagesPath.imgSplash_ZainShakeel;
        imgCoverTop = AppImagesPath.imgCoverTop_ZainShakeel;
        imgCoverCircleDp = AppImagesPath.imgCoverCircleDp_ZainShakeel;
        imgAppCircleLogo = AppImagesPath.imgAppCircleLogo_ZainShakeel;
        break;


    }
  }
}
