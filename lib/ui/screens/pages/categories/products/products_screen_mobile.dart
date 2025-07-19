import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class ProductsScreenMobile extends StatelessWidget {
  const ProductsScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var productController = Get.find<ProductController>();
    var navigation = Get.find<NavigationController>();
    return Obx(() {
      final categoriesData = productController.categoryDataInitial.value;
      if (categoriesData == null) {
        return Center(child: loadingIndicator()); // or any fallback
      }

      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            // Top Banner

            Obx(() {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: productController.showTopHeader.value
                    ? TopImageHeader(
                  title: appLanguage == URDU_LANGUAGE
                      ? categoriesData.categoryNameUrdu.toString()
                      : categoriesData.categoryNameEnglish.toString(),
                  coverImage: categoriesData.categoryCoverImage ?? "",
                )
                    : appBarCommon(
                  title: appLanguage == URDU_LANGUAGE
                      ? categoriesData.categoryNameUrdu.toString()
                      : categoriesData.categoryNameEnglish.toString(),
                  isBackNavigation: true,
                  isTrailing: true,
                  trailingIcon: icSearch,
                  trailingOnTap: () {},
                ),
              );
            }),

            //  setHeight(MAIN_VERTICAL_PADDING),

            /// SUBCATEGORIES SCROLLABLE ROW
            Padding(
              padding: const EdgeInsets.only(
                left: MAIN_HORIZONTAL_PADDING,
                top: MAIN_HORIZONTAL_PADDING,
                bottom: MAIN_HORIZONTAL_PADDING,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: size.width),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                        categoriesData.subCategories?.length ?? 0, (index,) {
                      var subCategory = categoriesData.subCategories![index];
                      return GestureDetector(
                        onTap: () =>
                            productController.onTapSubCategories(index, categoriesData),
                        child: TabItems(
                          text: appLanguage == URDU_LANGUAGE ? subCategory.subCategoryNameUrdu.toString() :subCategory.subCategoryNameEnglish.toString(),
                          isSelected:
                          productController.subCategoryIndex.value == index
                              ? true
                              : false,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),

            //  setHeight(10.0),
            productController.productsStatus.value ==
                ProductsByCatStatus.LOADING
                ? Expanded(child: loadingIndicator())
                : productController.productsStatus.value ==
                ProductsByCatStatus.FAILURE
                ? Expanded(child: ErrorScreen())
                : productController.productsList.isEmpty
                ? EmptyScreen(
              icon: AppAnims.animEmptyBoxSkin(isDark),
              text: AppLanguage.noProductsStr(appLanguage).toString(),
            )
                : Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height),
                child: GridView.builder(
                  controller: productController.scrollController,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: MAIN_HORIZONTAL_PADDING,
                    right: MAIN_HORIZONTAL_PADDING,
                    top: 5.0,
                    bottom: MAIN_VERTICAL_PADDING,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: MAIN_HORIZONTAL_PADDING,
                    mainAxisSpacing: MAIN_HORIZONTAL_PADDING,
                    childAspectRatio:
                    0.6, // tweak this for height vs width
                  ),
                  itemCount: productController.productsList.length,
                  itemBuilder: (context, index) {
                    var data = productController.productsList[index];
                    return GestureDetector(
                        onTap: () =>
                            navigation.gotoProductDetailScreen(data: data),
                        child: ProductItem(data: data));
                  },
                ),
              ),
            ),

            // ✅ Bottom Message Section
            Obx(() {
              final isLoadingMore =
                  productController.isLoadingMoreCategory.value;
              final hasMore = productController.hasMoreCategoryProducts.value;
              final reachedEnd = productController.reachedEndOfScroll.value;

              // ✅ Only show when all products are scrolled & no more left
              if (!hasMore && reachedEnd) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: appText(
                    text: 'No more products',
                    textStyle: itemTextStyle(),
                  ),
                );
              }

              // ✅ Show loading if fetching more
              if (isLoadingMore) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: loadingIndicator(),
                );
              }

              return SizedBox(); // nothing to show
            }),
          ],
        ),
      );
    });
  }
}
