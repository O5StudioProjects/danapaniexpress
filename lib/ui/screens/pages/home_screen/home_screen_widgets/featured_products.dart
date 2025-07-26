import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/ui/screens/pages/categories/widgets/products_row_ui.dart';

class FeaturedProducts extends StatelessWidget {
  const FeaturedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final products = Get.find<ProductsController>();
    return ProductsRowUi(products: products.featuredProducts, screenType: ProductsScreenType.FEATURED);
  }
}
