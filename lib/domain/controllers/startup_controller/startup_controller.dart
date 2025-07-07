import 'dart:async';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class StartupController extends GetxController {
  RxInt index = 0.obs;
  late PageController pageController;
  Timer? autoSwipeTimer;
  final theme = Get.find<ThemeController>();
  final navigation = Get.find<NavigationController>();
  @override
  void onInit() {
    super.onInit();
    pageController = PageController();

    // // Optional auto swipe every 5 seconds
    // autoSwipeTimer = Timer.periodic(Duration(seconds: 5), (timer) {
    //   if (index.value < startUpData.length - 1) {
    //     pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    //   } else {
    //     timer.cancel();
    //     //JumpTo.gotoSignInScreen();
    //   }
    // });
  }

  void onPageChanged(int newIndex) {
    index.value = newIndex;
  }

  Future<void> onTapNext() async {
    if (index.value < startUpData.length - 1) {
      pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      await theme.setStartupScreenPrefsEvent(startupScreenStatusValue: FIRST_TIME_SCREEN_OPENED).then((value){
        navigation.gotoSignInScreen();
      });

    }
  }

  void onTapBack() {
    if (index.value > 0) {
      pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Get.back();
    }
  }

  void onSkip() {
    autoSwipeTimer?.cancel();
    navigation.gotoSignInScreen();
  }

  @override
  void onClose() {
    autoSwipeTimer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
