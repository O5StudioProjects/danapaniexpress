import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';


class FlashSaleProducts extends StatelessWidget {
  const FlashSaleProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final products = Get.find<ProductsController>();
    return ProductsRowUi(products: products.flashSaleProducts, screenType: ProductsScreenType.FLASHSALE);
  }
}
