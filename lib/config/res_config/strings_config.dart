import '../../data/enums/enums.dart';

abstract class EnvStrings {
  static late String contentDatabaseName;
  static late String appDatabaseName;
  static late String lughatDatabaseName;
  static late String privacyPolicy;
  static late String appVersion;
  static late String appIDFree;
  static late String appIDPaid;
  static late String oneSignalAppId;
  static late String facebookPageUrl;
  static late String databaseUrl;


  static late Flavor _environment;
  static Flavor get environment => _environment;

  // static setUpAppStrings(Flavor environment) {
  //   _environment = environment;
  //   switch (environment) {
  //     case Flavor.dev:
  //       appDatabaseName = DatabaseName.AppDatabase;
  //       contentDatabaseName = DatabaseName.Develop;
  //       lughatDatabaseName = DatabaseName.LughatDatabase;
  //       privacyPolicy = PrivacyPolicy.Develop;
  //       appVersion = AppVersions.Develop;
  //       appIDFree = AppIDFree.Develop;
  //       appIDPaid = AppIDPaid.Develop;
  //       oneSignalAppId = OneSignalID.Develop;
  //       facebookPageUrl = FacebookPage.Develop;
  //       databaseUrl = DatabaseLink.Develop;
  //
  //       break;
  //
  //     case Flavor.prod:
  //       appDatabaseName = DatabaseName.AppDatabase;
  //       contentDatabaseName = DatabaseName.ZainShakeel;
  //       lughatDatabaseName = DatabaseName.LughatDatabase;
  //       privacyPolicy = PrivacyPolicy.ZainShakeel;
  //       appVersion = AppVersions.ZainShakeel;
  //       appIDFree = AppIDFree.ZainShakeel;
  //       appIDPaid = AppIDPaid.ZainShakeel;
  //       oneSignalAppId = OneSignalID.ZainShakeel;
  //       facebookPageUrl = FacebookPage.ZainShakeel;
  //       databaseUrl = DatabaseLink.ZainShakeel;
  //
  //       break;
  //
  //     case Flavor.rider:
  //       appDatabaseName = DatabaseName.AppDatabase;
  //       contentDatabaseName = DatabaseName.ZainShakeel;
  //       lughatDatabaseName = DatabaseName.LughatDatabase;
  //       privacyPolicy = PrivacyPolicy.ZainShakeelPro;
  //       appVersion = AppVersions.ZainShakeelPro;
  //       appIDFree = AppIDFree.ZainShakeel;
  //       appIDPaid = AppIDPaid.ZainShakeel;
  //       oneSignalAppId = OneSignalID.ZainShakeel;
  //       facebookPageUrl = FacebookPage.ZainShakeel;
  //       databaseUrl = DatabaseLink.ZainShakeel;
  //
  //       break;
  //
  //   }
  // }
}
