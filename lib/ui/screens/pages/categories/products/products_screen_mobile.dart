import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/data/models/sub_categories_model.dart';
import 'package:danapaniexpress/domain/controllers/product_controller/products_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductsScreenMobile extends StatelessWidget {
  const ProductsScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var product = Get.find<ProductsController>();
    var productController = Get.find<ProductScrollController>();
    var navigation = Get.find<NavigationController>();
    return Obx(() {
      final categoriesData = productController.categoryDataInitial.value;

      if (categoriesData == null) {
        return Center(child: loadingIndicator()); // or any fallback
      }

      final List<SubCategoriesModel> subCategoriesList = [
        SubCategoriesModel(
          // Dummy "All" item
          subCategoryId: 'All',
          subCategoryNameEnglish: 'All',
          subCategoryNameUrdu: 'تمام',
        ),
        ...?categoriesData.subCategories, // Spread real items
      ];

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
                        trailingIconType: IconType.SVG,
                        trailingOnTap: () {},
                      ),
              );
            }),

            //  setHeight(MAIN_VERTICAL_PADDING),

            /// SUBCATEGORIES SCROLLABLE ROW
            Obx(() {
              return Padding(
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
                      children: List.generate(subCategoriesList.length, (
                        index,
                      ) {
                        var subCategory = subCategoriesList[index];
                        return GestureDetector(
                          onTap: () {
                            product.subCategoryIndex.value = index;
                            if (index == 0) {
                              product.fetchInitialProductsByCategory(
                                categoriesData.categoryId!,
                              );
                            } else {
                              product
                                  .fetchInitialProductsByCategoryAndSubCategory(
                                    category: categoriesData.categoryId!,
                                    subCategory: subCategory.subCategoryId!,
                                  );
                            }
                          },

                          child: TabItems(
                            text: appLanguage == URDU_LANGUAGE
                                ? subCategory.subCategoryNameUrdu.toString()
                                : subCategory.subCategoryNameEnglish.toString(),
                            isSelected: product.subCategoryIndex.value == index
                                ? true
                                : false,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              );
            }),

            //  setHeight(10.0),
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
                        padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING, vertical: MAIN_VERTICAL_PADDING),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: size.height),
                          child: StaggeredGrid.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: MAIN_HORIZONTAL_PADDING,
                            crossAxisSpacing: MAIN_HORIZONTAL_PADDING,
                            children: List.generate(product.productsList.length, (
                              index,
                            ) {
                              var data = product.productsList[index];
                              return GestureDetector(
                                onTap: () =>
                                    navigation.gotoProductDetailScreen(data: data),
                                child: ProductItem(data: data),
                              );
                            }),
                          ),

                        ),
                      ),
                    ),
                  ),

            // ✅ Bottom Message Section
            Obx(() {
              final isLoadingMore = product.isLoadingMore.value;
              final hasMore = product.hasMoreProducts.value;
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
