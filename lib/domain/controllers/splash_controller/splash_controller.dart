import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class SplashController extends GetxController {
  RxString firstTimeLanguageAndThemeScreenStatus = FIRST_TIME_SCREEN_NOT_OPENED
      .obs;
  RxString firstTimeStartupStatus = FIRST_TIME_SCREEN_NOT_OPENED.obs;

  var navigation = Get.find<NavigationController>();

  @override
  Future<void> onInit() async {
    checkLoginStatus();
    super.onInit();
  }

  void checkLoginStatus() async {
    final isLoggedIn = await SharedPrefs.isLoggedIn();
    if (isLoggedIn) {
      final user = await SharedPrefs.getUser();
      Get.put(AuthController()).currentUser.value = user!;
      await Future.delayed(const Duration(seconds: 3), () => navigation.gotoDashboardScreen());

    } else {
      firstTimeLanguageAndThemeScreenStatus.value = await SharedPrefs.getLanguageScreen();
      firstTimeStartupStatus.value = await SharedPrefs.getStartupScreenPrefs();
      if (firstTimeLanguageAndThemeScreenStatus.value == FIRST_TIME_SCREEN_NOT_OPENED) {
        await Future.delayed(const Duration(seconds: 3), () => navigation.gotoLanguageThemeScreen(isNavigation: false, isStart: true));
        //  JumpTo.gotoLanguageThemeScreen(isNavigation: false, isStart: true));
      } else if (firstTimeLanguageAndThemeScreenStatus.value == FIRST_TIME_SCREEN_OPENED && firstTimeStartupStatus.value == FIRST_TIME_SCREEN_NOT_OPENED) {
        await Future.delayed(const Duration(seconds: 3), () => navigation.gotoStartupMainScreen());
      } else if (firstTimeLanguageAndThemeScreenStatus.value ==
          FIRST_TIME_SCREEN_OPENED && firstTimeStartupStatus.value == FIRST_TIME_SCREEN_OPENED){
        await Future.delayed(const Duration(seconds: 3), () => navigation.gotoSignInScreen());
      }
    }
  }


  Future<void> changeScreen() async {
    firstTimeLanguageAndThemeScreenStatus.value = await SharedPrefs.getLanguageScreen();
    firstTimeStartupStatus.value = await SharedPrefs.getStartupScreenPrefs();
    final isUserLoggedIn = await SharedPrefs.isLoggedIn();
    if (isUserLoggedIn) {
      await Future.delayed(const Duration(seconds: 3), () => navigation.gotoDashboardScreen());
    } else {
      if (firstTimeLanguageAndThemeScreenStatus.value == FIRST_TIME_SCREEN_NOT_OPENED) {
        await Future.delayed(const Duration(seconds: 3), () => navigation.gotoLanguageThemeScreen(isNavigation: false, isStart: true));
        //  JumpTo.gotoLanguageThemeScreen(isNavigation: false, isStart: true));
      } else if (firstTimeLanguageAndThemeScreenStatus.value == FIRST_TIME_SCREEN_OPENED && firstTimeStartupStatus.value == FIRST_TIME_SCREEN_NOT_OPENED) {
        await Future.delayed(const Duration(seconds: 3), () => navigation.gotoStartupMainScreen());
      } else if (firstTimeLanguageAndThemeScreenStatus.value ==
          FIRST_TIME_SCREEN_OPENED && firstTimeStartupStatus.value == FIRST_TIME_SCREEN_OPENED){
        await Future.delayed(const Duration(seconds: 3), () => navigation.gotoSignInScreen());
      }
    }
  }


    // else {
    //   await Future.delayed(
    //       const Duration(seconds: 3), () => JumpTo.gotoHomeScreen());
    // }
  }

