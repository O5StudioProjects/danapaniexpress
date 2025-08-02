import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/controllers/terms_conditions_controller/terms_conditions_controller.dart';

import '../../../core/packages_import.dart';

class SplashController extends GetxController {
  RxString firstTimeLanguageAndThemeScreenStatus = FIRST_TIME_SCREEN_NOT_OPENED.obs;
  RxString firstTimeStartupStatus = FIRST_TIME_SCREEN_NOT_OPENED.obs;

  var navigation = Get.find<NavigationController>();
  var auth = Get.find<AuthController>();
  var terms = Get.find<TermsConditionsController>();
  Rx<Status> startupStatus = Status.IDLE.obs;

  @override
  Future<void> onInit() async {
    checkLoginStatus();
    super.onInit();
  }

  void checkLoginStatus() async {
    startupStatus.value = Status.LOADING;

    Future.delayed(Duration(seconds: 3), () async {
      if(terms.acceptTerms.value == false){
        navigation.gotoTermsConditionsScreen(isStart: true);
      }
      else if(internet || kIsWeb){
        startupStatus.value = Status.LOADING;
        firstTimeLanguageAndThemeScreenStatus.value =
            await SharedPrefs.getLanguageScreen();
        firstTimeStartupStatus.value = await SharedPrefs.getStartupScreenPrefs();

        if (firstTimeLanguageAndThemeScreenStatus.value == FIRST_TIME_SCREEN_NOT_OPENED) {
          await Future.delayed(const Duration(seconds: 1));
          startupStatus.value = Status.SUCCESS;
          navigation.gotoLanguageThemeScreen(isNavigation: false, isStart: true);
          return;
        }

        if (firstTimeStartupStatus.value == FIRST_TIME_SCREEN_NOT_OPENED) {
          await Future.delayed(const Duration(seconds: 1));
          startupStatus.value = Status.SUCCESS;
          navigation.gotoStartupMainScreen();
          return;
        }

        // ✅ Now check if session exists and navigate accordingly
        await Future.delayed(const Duration(seconds: 1));
        await auth.loadSession();
        startupStatus.value = Status.SUCCESS;

      } else{
        startupStatus.value = Status.SUCCESS;
        navigation.gotoNoInternetScreen(isStart: true);
      }
    });

  }



    // else {
    //   await Future.delayed(
    //       const Duration(seconds: 3), () => JumpTo.gotoHomeScreen());
    // }
  }

