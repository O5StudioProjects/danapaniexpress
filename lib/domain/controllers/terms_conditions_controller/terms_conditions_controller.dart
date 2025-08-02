
import 'package:danapaniexpress/core/common_imports.dart';

import '../auth_controller/auth_controller.dart';
import '../navigation_controller/navigation_controller.dart';

class TermsConditionsController extends GetxController{

  RxBool acceptTerms = false.obs;
  RxString firstTimeLanguageAndThemeScreenStatus = FIRST_TIME_SCREEN_NOT_OPENED.obs;
  RxString firstTimeStartupStatus = FIRST_TIME_SCREEN_NOT_OPENED.obs;

  Rx<Status> acceptTermsStatus = Status.IDLE.obs;
  var navigation = Get.find<NavigationController>();
  var auth = Get.find<AuthController>();

  getTermsValue() async {
    acceptTerms.value = await SharedPrefs.getTermsConditionsScreenPrefs();
  }

  @override
  void onInit() {
    getTermsValue();
    super.onInit();
  }


  void onTapContinue() async {

    if(internet || kIsWeb){
      acceptTermsStatus.value = Status.LOADING;
      SharedPrefs.setTermsConditionsScreenPrefs(acceptTerms.value);

      firstTimeLanguageAndThemeScreenStatus.value =
      await SharedPrefs.getLanguageScreen();
      firstTimeStartupStatus.value = await SharedPrefs.getStartupScreenPrefs();

      if (firstTimeLanguageAndThemeScreenStatus.value == FIRST_TIME_SCREEN_NOT_OPENED) {
        await Future.delayed(const Duration(seconds: 1));
        acceptTermsStatus.value = Status.SUCCESS;
        navigation.gotoLanguageThemeScreen(isNavigation: false, isStart: true);
        return;
      }

      if (firstTimeStartupStatus.value == FIRST_TIME_SCREEN_NOT_OPENED) {
        await Future.delayed(const Duration(seconds: 1));
        acceptTermsStatus.value = Status.SUCCESS;
        navigation.gotoStartupMainScreen();
        return;
      }

      // ✅ Now check if session exists and navigate accordingly
      await Future.delayed(const Duration(seconds: 1));
      await auth.loadSession();
      acceptTermsStatus.value = Status.SUCCESS;
    } else{
      acceptTermsStatus.value = Status.SUCCESS;
      navigation.gotoNoInternetScreen(isStart: true);
    }

  }

}