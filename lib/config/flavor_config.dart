

import '../data/enums/enums.dart';

class AppConfig {
  static late Flavor flavorName;
  static late Flavor _flavor;
  static late String baseUrl;
  static late String apiPath;
  static late String uploadPath;
  static late String apiKeyHeader;
  static late String apiKey;
  static late AdsStatus adsStatus;
  static Flavor get flavor => _flavor;

  static setUpEnv(Flavor flavor) {
    _flavor = flavor;

    switch (flavor) {
      case Flavor.dev:
        baseUrl = "https://danapaniexpress.com/develop";
        apiPath = "/rest_api";
        uploadPath = "/uploads";
        apiKeyHeader = "API-KEY";
        apiKey = "123456789ABCDEF";
        flavorName = Flavor.dev;
        adsStatus = AdsStatus.ADS_DISABLED;
        break;

      case Flavor.prod:
        baseUrl = "https://danapaniexpress.com/production";
        apiPath = "/rest_api";
        uploadPath = "/uploads";
        apiKeyHeader = "API-KEY";
        apiKey = "123456789ABCDEF";
        flavorName = Flavor.prod;
        adsStatus = AdsStatus.ADS_DISABLED;
        break;

      case Flavor.rider:
        baseUrl = "https://danapaniexpress.com";
        apiPath = "/rest_api";
        uploadPath = "/uploads";
        apiKeyHeader = "API-KEY";
        apiKey = "123456789ABCDEF";
        flavorName = Flavor.rider;
        adsStatus = AdsStatus.ADS_DISABLED;
        break;

      }
  }
}