import 'package:danapaniexpress/core/common_imports.dart';

abstract class EnvStrings {
  static late String appNameEng;
  static late String appNameUrdu;
  static late String appSloganEng;
  static late String appSloganUrdu;
  static late String appDatabaseName;
  static late String privacyPolicy;
  static late String appVersion;
  static late String appIDFree;
  static late String appIDPaid;
  static late String oneSignalAppId;


  static late Flavor _environment;
  static Flavor get environment => _environment;

  static setUpAppStrings(Flavor environment) {
    _environment = environment;
    switch (environment) {
      case Flavor.dev:
        appNameEng = AppNameEnv.DevelopEng;
        appNameUrdu = AppNameEnv.DevelopUrdu;
        appSloganEng = AppSloganEnv.DevelopEng;
        appSloganUrdu = AppSloganEnv.DevelopUrdu;
        appDatabaseName = AppDatabaseNameEnv.develop;
        privacyPolicy = PrivacyPolicyEnv.develop;
        appVersion = AppVersionsEnv.develop;
        appIDFree = AppAdsIdPaidEnv.develop;
        appIDPaid = AppAdsIdPaidEnv.develop;
        oneSignalAppId = AppOneSignalIDEnv.develop;

        break;

      case Flavor.prod:
        appNameEng = AppNameEnv.ProdEng;
        appNameUrdu = AppNameEnv.ProdUrdu;
        appSloganEng = AppSloganEnv.ProdEng;
        appSloganUrdu = AppSloganEnv.ProdUrdu;
        appDatabaseName = AppDatabaseNameEnv.prod;
        privacyPolicy = PrivacyPolicyEnv.prod;
        appVersion = AppVersionsEnv.prod;
        appIDFree = AppAdsIdPaidEnv.prod;
        appIDPaid = AppAdsIdPaidEnv.prod;
        oneSignalAppId = AppOneSignalIDEnv.prod;

        break;

      case Flavor.rider:
        appNameEng = AppNameEnv.RiderEng;
        appNameUrdu = AppNameEnv.RiderUrdu;
        appSloganEng = AppSloganEnv.RiderEng;
        appSloganUrdu = AppSloganEnv.RiderUrdu;
        appDatabaseName = AppDatabaseNameEnv.rider;
        privacyPolicy = PrivacyPolicyEnv.rider;
        appVersion = AppVersionsEnv.rider;
        appIDFree = AppAdsIdPaidEnv.rider;
        appIDPaid = AppAdsIdPaidEnv.rider;
        oneSignalAppId = AppOneSignalIDEnv.rider;

        break;

    }
  }
}
