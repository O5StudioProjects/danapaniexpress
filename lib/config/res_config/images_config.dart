import '../../core/common_imports.dart';

abstract class EnvImages {
  static late String imgMainLogo;
  static late String imgWave;
  static late String imgWelcomeStartup;
  static late String imgFastDeliveryStartup;
  static late String imgFreshProductsStartup;
  static late String imgTrustedByFamiliesStartup;
  static late String imgLoginScreen;
  static late String imgProductBackground;

  static late Flavor _environment;
  static Flavor get environment => _environment;

  static setUpAppImages(Flavor environment) {
    _environment = environment;
    switch (environment) {
      case Flavor.dev:
        imgMainLogo = AppImagesPath.imgMainLogo_Dev;
        imgWave = AppImagesPath.imgWaveLight_Dev;
        imgWelcomeStartup = AppImagesPath.imgWelcomeStartup_Dev;
        imgFastDeliveryStartup = AppImagesPath.imgFastDeliveryStartup_Dev;
        imgFreshProductsStartup = AppImagesPath.imgFreshProductsStartup_Dev;
        imgTrustedByFamiliesStartup = AppImagesPath.imgTrustedByFamiliesStartup_Dev;
        imgLoginScreen = AppImagesPath.imgLoginScreen_Dev;
        imgProductBackground = AppImagesPath.imgProductBackground_Dev;

        break;

      case Flavor.prod:
        imgMainLogo = AppImagesPath.imgMainLogo_Prod;
        imgWave = AppImagesPath.imgWaveLight_Prod;
        imgWelcomeStartup = AppImagesPath.imgWelcomeStartup_Prod;
        imgFastDeliveryStartup = AppImagesPath.imgFastDeliveryStartup_Prod;
        imgFreshProductsStartup = AppImagesPath.imgFreshProductsStartup_Prod;
        imgTrustedByFamiliesStartup = AppImagesPath.imgTrustedByFamiliesStartup_Prod;
        imgLoginScreen = AppImagesPath.imgLoginScreen_Prod;
        imgProductBackground = AppImagesPath.imgProductBackground_Prod;

        break;

      case Flavor.rider:
        imgMainLogo = AppImagesPath.imgMainLogo_Rider;
        imgWave = AppImagesPath.imgWaveLight_Rider;
        imgWelcomeStartup = AppImagesPath.imgWelcomeStartup_Rider;
        imgFastDeliveryStartup = AppImagesPath.imgFastDeliveryStartup_Rider;
        imgFreshProductsStartup = AppImagesPath.imgFreshProductsStartup_Rider;
        imgTrustedByFamiliesStartup = AppImagesPath.imgTrustedByFamiliesStartup_Rider;
        imgLoginScreen = AppImagesPath.imgLoginScreen_Rider;
        imgProductBackground = AppImagesPath.imgProductBackground_Rider;

        break;


    }
  }
}
