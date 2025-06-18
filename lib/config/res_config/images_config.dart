import '../../data/enums/enums.dart';

abstract class EnvImages {
  static late String imgSplashLogo;
  static late String imgCoverTop;
  static late String imgCoverCircleDp;
  static late String audioPlayerImage;
  static late String imgPoetIntro;
  static late List<String> subscriptionBgImages;
  static late String imgDeveloper;
  static late String imgDesigner;
  static late String imgAppCircleLogo;
  static late String imgIntisab;

  static late Flavor _environment;
  static Flavor get environment => _environment;

  // static setUpAppImages(Flavor environment) {
  //   _environment = environment;
  //   switch (environment) {
  //     case Flavor.dev:
  //       imgSplashLogo = AppImagesPath.imgSplash_Dev;
  //       imgCoverTop = AppImagesPath.imgCoverTop_Dev;
  //       imgCoverCircleDp = AppImagesPath.imgCoverCircleDp_Dev;
  //       imgPoetIntro = AppImagesPath.imgPoetIntro_Dev;
  //       audioPlayerImage = UrlImages.imgAudioPlayer_Develop;
  //       subscriptionBgImages = UrlImages.subscriptionsImages_Develop;
  //       imgDeveloper = AppImagesPath.imgDeveloper_Dev;
  //       imgDesigner = AppImagesPath.imgDesigner_Dev;
  //       imgAppCircleLogo = AppImagesPath.imgAppCircleLogo_Dev;
  //       imgIntisab = AppImagesPath.imgIntisab_Dev;
  //
  //       break;
  //
  //     case Flavor.prod:
  //       imgSplashLogo = AppImagesPath.imgSplash_ZainShakeel;
  //       imgCoverTop = AppImagesPath.imgCoverTop_ZainShakeel;
  //       imgCoverCircleDp = AppImagesPath.imgCoverCircleDp_ZainShakeel;
  //       imgPoetIntro = AppImagesPath.imgPoetIntro_ZainShakeel;
  //       audioPlayerImage = UrlImages.imgAudioPlayer_ZainShakeel;
  //       subscriptionBgImages = UrlImages.subscriptionsImages_ZainShakeel;
  //       imgDeveloper = AppImagesPath.imgDeveloper_ZainShakeel;
  //       imgDesigner = AppImagesPath.imgDesigner_ZainShakeel;
  //       imgAppCircleLogo = AppImagesPath.imgAppCircleLogo_ZainShakeel;
  //       imgIntisab = AppImagesPath.imgIntisab_ZainShakeel;
  //
  //       break;
  //
  //     case Flavor.rider:
  //       imgSplashLogo = AppImagesPath.imgSplash_ZainShakeel;
  //       imgCoverTop = AppImagesPath.imgCoverTop_ZainShakeel;
  //       imgCoverCircleDp = AppImagesPath.imgCoverCircleDp_ZainShakeel;
  //       imgPoetIntro = AppImagesPath.imgPoetIntro_ZainShakeel;
  //       audioPlayerImage = UrlImages.imgAudioPlayer_ZainShakeel;
  //       subscriptionBgImages = UrlImages.subscriptionsImages_ZainShakeel;
  //       imgDeveloper = AppImagesPath.imgDeveloper_ZainShakeel;
  //       imgDesigner = AppImagesPath.imgDesigner_ZainShakeel;
  //       imgAppCircleLogo = AppImagesPath.imgAppCircleLogo_ZainShakeel;
  //       imgIntisab = AppImagesPath.imgIntisab_ZainShakeel;
  //
  //       break;
  //
  //
  //   }
  // }
}
