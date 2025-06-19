

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
        animArrowUpDark = AppAnimationsPath.animArrowUpDark_Dev;
        animArrowUpLight = AppAnimationsPath.animArrowUpLight_Dev;
        animLoadingDark = AppAnimationsPath.animLoadingDark_Dev;
        animLoadingLight = AppAnimationsPath.animLoadingLight_Dev;
        animDownloadingDark = AppAnimationsPath.animDownloadingDark_Dev;
        animDownloadingLight = AppAnimationsPath.animDownloadingLight_Dev;
        break;

      case Flavor.prod:
        animNotificationDark = AppAnimationsPath.animNotificationDark_ZainShakeel;
        animNotificationLight = AppAnimationsPath.animNotificationLight_ZainShakeel;
        animArrowUpDark = AppAnimationsPath.animArrowUpDark_ZainShakeel;
        animArrowUpLight = AppAnimationsPath.animArrowUpLight_ZainShakeel;
        animLoadingDark = AppAnimationsPath.animLoadingDark_ZainShakeel;
        animLoadingLight = AppAnimationsPath.animLoadingLight_ZainShakeel;
        animDownloadingDark = AppAnimationsPath.animDownloadingDark_ZainShakeel;
        animDownloadingLight = AppAnimationsPath.animDownloadingLight_ZainShakeel;
        break;

      case Flavor.rider:
        animNotificationDark = AppAnimationsPath.animNotificationDark_ZainShakeel;
        animNotificationLight = AppAnimationsPath.animNotificationLight_ZainShakeel;
        animArrowUpDark = AppAnimationsPath.animArrowUpDark_ZainShakeel;
        animArrowUpLight = AppAnimationsPath.animArrowUpLight_ZainShakeel;
        animLoadingDark = AppAnimationsPath.animLoadingDark_ZainShakeel;
        animLoadingLight = AppAnimationsPath.animLoadingLight_ZainShakeel;
        animDownloadingDark = AppAnimationsPath.animDownloadingDark_ZainShakeel;
        animDownloadingLight = AppAnimationsPath.animDownloadingLight_ZainShakeel;
        break;

    }
  }
}
