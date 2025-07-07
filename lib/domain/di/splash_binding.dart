import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class SplashBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(NavigationController(), permanent: true);
    Get.put(ThemeController(), permanent: true);
    //Get.lazyPut(()=> ThemeController(), fenix: true);
  }

}