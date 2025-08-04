

import 'package:danapaniexpress/core/common_imports.dart';

import '../auth_controller/auth_controller.dart';
import '../navigation_controller/navigation_controller.dart';

class ServiceAreaController extends GetxController{
  RxString serviceArea = ''.obs;
  RxString firstTimeLanguageAndThemeScreenStatus = FIRST_TIME_SCREEN_NOT_OPENED.obs;
  RxString firstTimeStartupStatus = FIRST_TIME_SCREEN_NOT_OPENED.obs;

  Rx<Status> serviceAreaStatus = Status.IDLE.obs;
  var navigation = Get.find<NavigationController>();
  var auth = Get.find<AuthController>();

  @override
  void onInit() {
    getServiceArea();
    super.onInit();
  }

  Future<void> getServiceArea() async {
    serviceArea.value = await SharedPrefs.getServiceArea();
  }

  void onTapConfirm(data) async {

    if(internet || kIsWeb){
      serviceAreaStatus.value = Status.LOADING;
      serviceArea.value = data;
      SharedPrefs.setServiceArea(serviceArea.value);
      firstTimeLanguageAndThemeScreenStatus.value =
      await SharedPrefs.getLanguageScreen();
      firstTimeStartupStatus.value = await SharedPrefs.getStartupScreenPrefs();

      if (firstTimeLanguageAndThemeScreenStatus.value == FIRST_TIME_SCREEN_NOT_OPENED) {
        await Future.delayed(const Duration(seconds: 1));
        serviceAreaStatus.value = Status.SUCCESS;
        navigation.gotoLanguageThemeScreen(isNavigation: false, isStart: true);
        return;
      }

      if (firstTimeStartupStatus.value == FIRST_TIME_SCREEN_NOT_OPENED) {
        await Future.delayed(const Duration(seconds: 1));
        serviceAreaStatus.value = Status.SUCCESS;
        navigation.gotoStartupMainScreen();
        return;
      }

      // ✅ Now check if session exists and navigate accordingly
      await Future.delayed(const Duration(seconds: 1));
      await auth.loadSession();
      serviceAreaStatus.value = Status.SUCCESS;
    } else{
      serviceAreaStatus.value = Status.SUCCESS;
      navigation.gotoNoInternetScreen(isStart: true);
    }

  }

}