
import 'package:danapaniexpress/core/common_imports.dart';
class JumpTo {

  static gotoHomeScreen(){
    Get.offAndToNamed(RouteNames.HomeScreenRoute);
  }

  static gotoLanguageThemeScreen({required bool isNavigation, required bool isStart}){
    Get.offAndToNamed(RouteNames.LanguageThemeScreenRoute, arguments: {
      IS_NAVIGATION: isNavigation,
      IS_START: isStart
    });
  }

  static gotoWelcomeStartupScreen(){
    Get.offAndToNamed(RouteNames.WelcomeStartupScreenRoute);
  }
  static gotoFastDeliveryStartupScreen(){
    Get.toNamed(RouteNames.FastDeliveryStartupScreenRoute);
  }
  static gotoFreshProductsStartupScreen(){
    Get.toNamed(RouteNames.FreshProductsStartupScreenRoute);
  }
  static gotoTrustedByFamiliesStartupScreen(){
    Get.toNamed(RouteNames.TrustedByFamiliesStartupScreenRoute);
  }

  ///AUTH SCREENS
  static gotoSignInScreen(){
    Get.offAllNamed(RouteNames.SignInScreenRoute);
  }

}