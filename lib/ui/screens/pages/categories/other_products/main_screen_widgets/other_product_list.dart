import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class OtherProductList extends StatelessWidget {
  final ProductsScreenType screenType;
  const OtherProductList({super.key, required this.screenType});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI(){
    final otherProductsController = Get.put(OtherProductsController());
    final navigation = Get.find<NavigationController>();
    final products = Get.find<ProductsController>();

    return Obx((){

      final loadStatus = screenType == ProductsScreenType.FEATURED
          ? products.featuredStatus.value
          : screenType == ProductsScreenType.FLASHSALE
          ? products.flashSaleStatus.value
          : products.popularStatus.value;

      final productsList = screenType == ProductsScreenType.FEATURED
          ? products.featuredProducts
          : screenType == ProductsScreenType.FLASHSALE
          ? products.flashSaleProducts
          : products.popularProducts;

      return loadStatus == ProductsStatus.LOADING
          ? Expanded(child: loadingIndicator())
          : loadStatus == ProductsStatus.FAILURE
          ? Expanded(child: ErrorScreen())
          : productsList.isEmpty
          ? Expanded(
        child: EmptyScreen(
          icon: AppAnims.animEmptyBoxSkin(isDark),
          text: AppLanguage.noProductsStr(appLanguage).toString(),
        ),
      )
          : Expanded(
        child: SingleChildScrollView(
          controller: otherProductsController.scrollController,
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
                children: List.generate(productsList.length, (index) {
                  final product = productsList[index];
                  return GestureDetector(
                    onTap: () =>
                        navigation.gotoProductDetailScreen(data: product),
                    child: ProductItem(data: product),
                  );
                }),
              ),
            ),
          ),
        ),
      );
    });
  }


}
