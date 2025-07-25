import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/controllers/account_controller/account_controller.dart';
import 'package:danapaniexpress/domain/controllers/product_controller/products_controller.dart';
import 'package:danapaniexpress/domain/controllers/search_controller/search_controller.dart';


class DashboardBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(HomeController(), permanent: true);
    Get.put(ProductsController(), permanent: true);
    Get.put(DashBoardController(), permanent: true);
    Get.put(SearchProductsController(), permanent: true);
    Get.lazyPut(()=> AccountController(), fenix: true);
    Get.lazyPut(()=> FavoritesController(), fenix: true);
    Get.lazyPut(()=> CartController(), fenix: true);
    Get.lazyPut(()=> SplashController(), fenix: true);
  }

}