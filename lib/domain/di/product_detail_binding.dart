
import '../../core/common_imports.dart';
import '../../core/controllers_import.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductDetailController());
  }
}
