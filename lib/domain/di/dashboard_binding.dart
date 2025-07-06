import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/controllers/account_controller/account_controller.dart';
import 'package:danapaniexpress/domain/controllers/categories_controller/categories_controller.dart';
import 'package:danapaniexpress/domain/controllers/product_controller/other_products_controller.dart';

class DashboardBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(ThemeController(), permanent: true);
    Get.put(NavigationController(), permanent: true);
    Get.put(CategoriesController(), permanent: true);
    Get.put(DashBoardController(), permanent: true);
    Get.lazyPut(()=> HomeScreenController(), fenix: true);
    Get.lazyPut(()=> FavoritesController(), fenix: true);
    Get.lazyPut(()=> CartController(), fenix: true);
    Get.lazyPut(()=> SplashController(), fenix: true);
    Get.lazyPut(()=> AccountController(), fenix: true);
  }

}