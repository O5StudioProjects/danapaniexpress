import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class OtherProductsScreenMobile extends StatelessWidget {
  const OtherProductsScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final otherProductsController = Get.put(OtherProductsController());
    final products = Get.find<ProductsController>();

    return Obx(() {
      final screenType = otherProductsController.productScreenType.value;
      final isLoadingMore = products.isLoadingMore.value;

      final hasMore = screenType == ProductsScreenType.FEATURED
          ? products.hasMoreFeaturedProducts.value
          : screenType == ProductsScreenType.FLASHSALE
          ? products.hasMoreFlashSaleProducts.value
          : products.hasMoreAllProducts.value;

      final reachedEnd = otherProductsController.reachedEndOfScroll.value;

      return _buildUI(isLoadingMore, hasMore, reachedEnd, screenType);
    });
  }

  Widget _buildUI(isLoadingMore, hasMore, reachedEnd, screenType) {
    return Column(
      children: [
        // Top Banner
        OtherProductsTopBannerSection(screenType: screenType),

        // Product List
        OtherProductList(screenType: screenType),

        // ✅ Bottom Message Section
        BottomMessagesSection(
          isLoadingMore: isLoadingMore,
          hasMore: hasMore,
          reachedEnd: reachedEnd,
          message: AppLanguage.noMoreProductsStr(appLanguage).toString(),
        ),
      ],
    );
  }
}
