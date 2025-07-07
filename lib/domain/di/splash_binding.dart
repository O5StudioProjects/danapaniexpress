import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/controllers/account_controller/account_controller.dart';
import 'package:danapaniexpress/domain/controllers/categories_controller/categories_controller.dart';
import 'package:danapaniexpress/domain/controllers/product_controller/other_products_controller.dart';

class SplashBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(NavigationController(), permanent: true);
    Get.put(ThemeController(), permanent: true);
    //Get.lazyPut(()=> ThemeController(), fenix: true);
  }

}