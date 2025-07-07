import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';


class DashboardBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(CategoriesController(), permanent: true);
    Get.put(DashBoardController(), permanent: true);
    Get.lazyPut(()=> HomeScreenController(), fenix: true);
    Get.lazyPut(()=> FavoritesController(), fenix: true);
    Get.lazyPut(()=> CartController(), fenix: true);
    Get.lazyPut(()=> SplashController(), fenix: true);
    Get.lazyPut(()=> AccountController(), fenix: true);
  }

}