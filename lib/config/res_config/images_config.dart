import '../../core/common_imports.dart';

abstract class EnvImages {
  static late String imgMainLogo;
  static late String imgWaveDark;
  static late String imgWaveLight;
  static late String imgWelcomeStartup;
  static late String imgFastDeliveryStartup;
  static late String imgFreshProductsStartup;
  static late String imgTrustedByFamiliesStartup;

  static late Flavor _environment;
  static Flavor get environment => _environment;

  static setUpAppImages(Flavor environment) {
    _environment = environment;
    switch (environment) {
      case Flavor.dev:
        imgMainLogo = AppImagesPath.imgMainLogo_Dev;
        imgWaveDark = AppImagesPath.imgWaveDark_Dev;
        imgWaveLight = AppImagesPath.imgWaveLight_Dev;
        imgWelcomeStartup = AppImagesPath.imgWelcomeStartup_Dev;
        imgFastDeliveryStartup = AppImagesPath.imgFastDeliveryStartup_Dev;
        imgFreshProductsStartup = AppImagesPath.imgFreshProductsStartup_Dev;
        imgTrustedByFamiliesStartup = AppImagesPath.imgTrustedByFamiliesStartup_Dev;

        break;

      case Flavor.prod:
        imgMainLogo = AppImagesPath.imgMainLogo_Prod;
        imgWaveDark = AppImagesPath.imgWaveDark_Prod;
        imgWaveLight = AppImagesPath.imgWaveLight_Prod;
        imgWelcomeStartup = AppImagesPath.imgWelcomeStartup_Prod;
        imgFastDeliveryStartup = AppImagesPath.imgFastDeliveryStartup_Prod;
        imgFreshProductsStartup = AppImagesPath.imgFreshProductsStartup_Prod;
        imgTrustedByFamiliesStartup = AppImagesPath.imgTrustedByFamiliesStartup_Prod;

        break;

      case Flavor.rider:
        imgMainLogo = AppImagesPath.imgMainLogo_Rider;
        imgWaveDark = AppImagesPath.imgWaveDark_Rider;
        imgWaveLight = AppImagesPath.imgWaveLight_Rider;
        imgWelcomeStartup = AppImagesPath.imgWelcomeStartup_Rider;
        imgFastDeliveryStartup = AppImagesPath.imgFastDeliveryStartup_Rider;
        imgFreshProductsStartup = AppImagesPath.imgFreshProductsStartup_Rider;
        imgTrustedByFamiliesStartup = AppImagesPath.imgTrustedByFamiliesStartup_Rider;


        break;


    }
  }
}
