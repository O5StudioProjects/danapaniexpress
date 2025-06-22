import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/core/common_imports.dart';

List<StartupModel> startUpData = [
  StartupModel(
    image: EnvImages.imgWelcomeStartup,
    headingText: AppLanguage.startupWelcomeHeadingStr(appLanguage).toString(),
    subText: AppLanguage.startupWelcomeSubtextStr(appLanguage).toString(),
    buttonText: AppLanguage.getStartedStr(appLanguage).toString(),
  ),
  StartupModel(
    image: EnvImages.imgFastDeliveryStartup,
    headingText: AppLanguage.startupFastDeliveryHeadingStr(appLanguage).toString(),
    subText: AppLanguage.startupFastDeliverySubtextStr(appLanguage).toString(),
    buttonText: AppLanguage.nextStr(appLanguage).toString(),
  ),
  StartupModel(
    image: EnvImages.imgFreshProductsStartup,
    headingText: AppLanguage.startupFreshProductsHeadingStr(appLanguage).toString(),
    subText: AppLanguage.startupFreshProductsSubtextStr(appLanguage).toString(),
    buttonText: AppLanguage.nextStr(appLanguage).toString(),
  ),
  StartupModel(
    image: EnvImages.imgTrustedByFamiliesStartup,
    headingText: AppLanguage.startupTrustedFamiliesHeadingStr(appLanguage).toString(),
    subText: AppLanguage.startupTrustedFamiliesSubtextStr(appLanguage).toString(),
    buttonText: AppLanguage.startShoppingStr(appLanguage).toString(),
  ),
];
