
import 'package:danapaniexpress/core/common_imports.dart';

class SplashController extends GetxController {
  RxString firstTimeLanguageAndThemeScreenStatus = FIRST_TIME_SCREEN_NOT_OPENED.obs;
  @override
  Future<void> onInit() async {
    changeScreen();
    super.onInit();
  }

  Future<void> changeScreen() async {
    firstTimeLanguageAndThemeScreenStatus.value = await SharedPrefs.getLanguageScreen();
    if(firstTimeLanguageAndThemeScreenStatus.value == FIRST_TIME_SCREEN_NOT_OPENED){
      await Future.delayed(const Duration(seconds: 3), ()=> JumpTo.gotoLanguageThemeScreen(isNavigation: false, isStart: true));
    } else {
      await Future.delayed(const Duration(seconds: 3), ()=> JumpTo.gotoHomeScreen());
    }

  }


}