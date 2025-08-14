import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/ui/screens/pages/cart/checkout_screen/main_screen_widgets/review_products_item.dart';

class ReviewProducts extends StatelessWidget {
  const ReviewProducts({super.key});

  @override
  Widget build(BuildContext context) {
    var cart = Get.find<CartController>();
    return Obx(() {
      var products = cart.cartProducts;
      return _buildUI(cart, products);
    });
  }

  Widget _buildUI(cart, products){
    return Column(
      children: [
        /// HEADING
        _headingSection(),
        _listSection(products),
      ],
    );
  }

  Widget _headingSection(){
    return Padding(
      padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING, bottom: MAIN_VERTICAL_PADDING),
      child: HomeHeadings(
        mainHeadingText: AppLanguage.orderedProductsStr(
          appLanguage,
        ).toString(),
        isSeeAll: false,
        isTrailingText: false,
      ),
    );
  }

  Widget _listSection(products){
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: MAIN_HORIZONTAL_PADDING,
      ),
      child: Column(
        children: List.generate(products.length, (index) {
          var product = products[index];
          return ReviewProductsItem(product: product, listLength: products.length, index: index);
        }),
      ),
    );
  }

}
