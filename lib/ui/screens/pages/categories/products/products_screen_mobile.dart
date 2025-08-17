import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class ProductsScreenMobile extends StatelessWidget {
  const ProductsScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var productController = Get.find<ProductScrollController>();
    var product = Get.find<ProductsController>();

    return Obx(() {
      final categoriesData = productController.categoryDataInitial.value;

      if (categoriesData == null) {
        return Center(child: loadingIndicator()); // or any fallback
      }
      return _buildUI(categoriesData, productController, product);

    });
  }

  Widget _buildUI(categoriesData, productController, product){
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          /// Top Banner
          TopBannerProductsSection(categoriesData: categoriesData),

          /// SUBCATEGORIES SCROLLABLE ROW
          SubCategoriesScrollableRowSection(categoriesData: categoriesData),

          ///PRODUCTS LIST SECTION
          ProductListSection(),

          /// Bottom Message Section
          BottomMessagesSection(
              isLoadingMore: product.isLoadingMore.value,
              hasMore: product.hasMoreProducts.value,
              reachedEnd: productController.reachedEndOfScroll.value,
            message: AppLanguage.noMoreProductsStr(appLanguage).toString(),
          )
        ],
      ),
    );
  }

}







