

import '../../core/common_imports.dart';

abstract class EnvAnim {
  static late String animNotificationDark;
  static late String animNotificationLight;
  static late String animArrowUpDark;
  static late String animArrowUpLight;
  static late String animLoadingDark;
  static late String animLoadingLight;
  static late String animDownloadingDark;
  static late String animDownloadingLight;

  static late Flavor _environment;
  static Flavor get environment => _environment;

  static setUpAppAnimations(Flavor environment) {
    _environment = environment;
    switch (environment) {
      case Flavor.dev:
        animNotificationDark = AppAnimationsPath.animNotificationDark_Dev;
        animNotificationLight = AppAnimationsPath.animNotificationLight_Dev;
        animLoadingDark = AppAnimationsPath.animLoadingDark_Dev;
        animLoadingLight = AppAnimationsPath.animLoadingLight_Dev;

        break;

      case Flavor.prod:
        animNotificationDark = AppAnimationsPath.animNotificationDark_Prod;
        animNotificationLight = AppAnimationsPath.animNotificationLight_Prod;
        animLoadingDark = AppAnimationsPath.animLoadingDark_Prod;
        animLoadingLight = AppAnimationsPath.animLoadingLight_Prod;

        break;

      case Flavor.rider:
        animNotificationDark = AppAnimationsPath.animNotificationDark_Rider;
        animNotificationLight = AppAnimationsPath.animNotificationLight_Rider;
        animLoadingDark = AppAnimationsPath.animLoadingDark_Rider;
        animLoadingLight = AppAnimationsPath.animLoadingLight_Rider;

        break;

    }
  }
}
