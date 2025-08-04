import 'package:danapaniexpress/core/common_imports.dart';
import '../navigation_controller/navigation_controller.dart';

class TermsConditionsController extends GetxController{

  RxBool acceptTerms = false.obs;
  Rx<Status> acceptTermsStatus = Status.IDLE.obs;
  var navigation = Get.find<NavigationController>();

  getTermsValue() async {
    acceptTerms.value = await SharedPrefs.getTermsConditionsScreenPrefs();
  }

  @override
  void onInit() {
    getTermsValue();
    super.onInit();
  }


  void onTapContinue() async {

    acceptTermsStatus.value = Status.LOADING;
    SharedPrefs.setTermsConditionsScreenPrefs(acceptTerms.value);
    navigation.gotoServiceAreasScreen(isStart: true);

  }

}