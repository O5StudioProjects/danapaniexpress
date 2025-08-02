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

  @override
  Future<void> onInit() async {
    checkLoginStatus();
    super.onInit();
  }

  void checkLoginStatus() async {

    Future.delayed(Duration(seconds: 3), () async {
      if(terms.acceptTerms.value == false){
        navigation.gotoTermsConditionsScreen(isStart: true);
      }
      else if(internet || kIsWeb){
        firstTimeLanguageAndThemeScreenStatus.value =
            await SharedPrefs.getLanguageScreen();
        firstTimeStartupStatus.value = await SharedPrefs.getStartupScreenPrefs();

        if (firstTimeLanguageAndThemeScreenStatus.value == FIRST_TIME_SCREEN_NOT_OPENED) {
          await Future.delayed(const Duration(seconds: 1));
          navigation.gotoLanguageThemeScreen(isNavigation: false, isStart: true);
          return;
        }

        if (firstTimeStartupStatus.value == FIRST_TIME_SCREEN_NOT_OPENED) {
          await Future.delayed(const Duration(seconds: 1));
          navigation.gotoStartupMainScreen();
          return;
        }

        // ✅ Now check if session exists and navigate accordingly
        await Future.delayed(const Duration(seconds: 1));
        await auth.loadSession();

      } else{
        navigation.gotoNoInternetScreen(isStart: true);
      }
    });

  }



    // else {
    //   await Future.delayed(
    //       const Duration(seconds: 3), () => JumpTo.gotoHomeScreen());
    // }
  }

