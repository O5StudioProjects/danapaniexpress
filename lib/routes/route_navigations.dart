
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


}