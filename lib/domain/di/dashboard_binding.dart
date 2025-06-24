import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

import '../controllers/splash_controller/splash_controller.dart';

class DashboardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> SplashController());
    Get.lazyPut(()=> ThemeController());
    Get.lazyPut(()=> DashBoardController());
    Get.lazyPut(()=> HomeScreenController());
  }

}