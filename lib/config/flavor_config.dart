

import '../data/enums/enums.dart';

class AppConfig {
  static late Flavor flavorName;
  static late Flavor _flavor;
  static late String baseUrl;
  static late AdsStatus adsStatus;
  static Flavor get flavor => _flavor;

  static setUpEnv(Flavor flavor) {
    _flavor = flavor;

    switch (flavor) {
      case Flavor.dev:
        baseUrl = "API BASE URL";
        flavorName = Flavor.dev;
        adsStatus = AdsStatus.ADS_DISABLED;
        break;

      case Flavor.prod:
        baseUrl = "API BASE URL";
        flavorName = Flavor.prod;
        adsStatus = AdsStatus.ADS_DISABLED;
        break;

      case Flavor.rider:
        baseUrl = "API BASE URL";
        flavorName = Flavor.rider;
        adsStatus = AdsStatus.ADS_DISABLED;
        break;

      default:
        baseUrl = "";
        flavorName = Flavor.dev;
        adsStatus = AdsStatus.ADS_DISABLED;
        break;
    }
  }
}