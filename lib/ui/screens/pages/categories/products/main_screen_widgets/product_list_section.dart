import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class ProductListSection extends StatelessWidget {
  const ProductListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI(){
    var productController = Get.find<ProductScrollController>();
    var navigation = Get.find<NavigationController>();
    var product = Get.find<ProductsController>();
    return Obx((){
      return
        product.productsStatus.value == ProductsByCatStatus.LOADING
            ? Expanded(child: loadingIndicator())
            : product.productsStatus.value == ProductsByCatStatus.FAILURE
            ? Expanded(child: ErrorScreen())
            : product.productsList.isEmpty
            ? Expanded(
          child: EmptyScreen(
            icon: AppAnims.animEmptyBoxSkin(isDark),
            text: AppLanguage.noProductsStr(appLanguage).toString(),
          ),
        )
            : Expanded(
          child: SingleChildScrollView(
            controller: productController.scrollController,
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: MAIN_HORIZONTAL_PADDING,
                vertical: MAIN_VERTICAL_PADDING,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height),
                child: StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: MAIN_HORIZONTAL_PADDING,
                  crossAxisSpacing: MAIN_HORIZONTAL_PADDING,
                  children: List.generate(
                    product.productsList.length,
                        (index) {
                      var data = product.productsList[index];
                      return GestureDetector(
                        onTap: () => navigation
                            .gotoProductDetailScreen(data: data),
                        child: ProductItem(data: data),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
    });
  }
}
