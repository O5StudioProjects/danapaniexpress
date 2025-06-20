import '../../core/common_imports.dart';

abstract class EnvImages {
  static late String imgMainLogo;
  static late String imgCoverTop;
  static late String imgCoverCircleDp;
  static late String imgAppCircleLogo;

  static late Flavor _environment;
  static Flavor get environment => _environment;

  static setUpAppImages(Flavor environment) {
    _environment = environment;
    switch (environment) {
      case Flavor.dev:
        imgMainLogo = AppImagesPath.imgMainLogo_Dev;


        break;

      case Flavor.prod:
        imgMainLogo = AppImagesPath.imgMainLogo_Prod;


        break;

      case Flavor.rider:
        imgMainLogo = AppImagesPath.imgMainLogo_Rider;

        break;


    }
  }
}
