import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class OtherProductsScreenMobile extends StatelessWidget {
  const OtherProductsScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final otherProductsController = Get.put(OtherProductsController());
    final navigation = Get.find<NavigationController>();
    final home = Get.find<HomeController>();
    final products = Get.find<ProductsController>();

    return Obx(() {
      final screenType = otherProductsController.productScreenType.value;

      final coverImage = screenType == ProductsScreenType.FEATURED
          ? home.coverImages.value!.featured
          : screenType == ProductsScreenType.FLASHSALE
          ? home.coverImages.value!.flashSale
          : screenType == ProductsScreenType.POPULAR
          ? home.coverImages.value!.popular
          : null;

      final screenName = screenType == ProductsScreenType.FEATURED
          ? AppLanguage.featuredProductStr(appLanguage)
          : screenType == ProductsScreenType.FLASHSALE
          ? AppLanguage.flashSaleStr(appLanguage)
          : screenType == ProductsScreenType.POPULAR
          ? AppLanguage.popularProductsStr(appLanguage)
          : null;
      final productsList = screenType == ProductsScreenType.FEATURED
          ? products.featuredProducts
          : screenType == ProductsScreenType.FLASHSALE
          ? products.flashSaleProducts
          : products.popularProducts;
      final loadStatus = screenType == ProductsScreenType.FEATURED
          ? products.featuredStatus.value
          : screenType == ProductsScreenType.FLASHSALE
          ? products.flashSaleStatus.value
          : products.popularStatus.value;

      final isLoadingMore = products.isLoadingMore.value;
      final hasMore = screenType == ProductsScreenType.FEATURED
          ? products.hasMoreFeaturedProducts.value
          : screenType == ProductsScreenType.FLASHSALE
          ? products.hasMoreFlashSaleProducts.value
          : products.hasMoreAllProducts.value;

      final reachedEnd = otherProductsController.reachedEndOfScroll.value;

      return _buildUI(
        otherProductsController,
        navigation,
        home,
        coverImage,
        screenName,
        loadStatus,
        productsList,
        isLoadingMore,
        hasMore,
        reachedEnd,
      );
    });
  }

  Widget _buildUI(
    otherProductsController,
    navigation,
    home,
    coverImage,
    screenName,
    loadStatus,
    productsList,
    isLoadingMore,
    hasMore,
    reachedEnd,
  ) {
    return Column(
      children: [
        // Top Banner
        _topBannerSection(
          otherProductsController,
          screenName,
          coverImage,
          navigation,
        ),

        // Product List
        _productsList(
          loadStatus,
          productsList,
          otherProductsController,
          navigation,
        ),

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

  Widget _topBannerSection(
    otherProductsController,
    screenName,
    coverImage,
    navigation,
  ) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: otherProductsController.showTopHeader.value
          ? TopImageHeader(title: screenName!, coverImage: coverImage ?? "")
          : appBarCommon(
              title: screenName!,
              isBackNavigation: true,
              isTrailing: true,
              trailingIcon: icSearch,
              trailingIconType: IconType.SVG,
              trailingOnTap: () => navigation.gotoSearchScreen(),
            ),
    );
  }

  Widget _productsList(
    loadStatus,
    productsList,
    otherProductsController,
    navigation,
  ) {
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
  }
}
