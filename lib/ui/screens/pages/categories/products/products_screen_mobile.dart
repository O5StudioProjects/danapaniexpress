import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class ProductsScreenMobile extends StatelessWidget {
  const ProductsScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var productController = Get.find<ProductScrollController>();
    var navigation = Get.find<NavigationController>();
    var product = Get.find<ProductsController>();

    return Obx(() {
      final categoriesData = productController.categoryDataInitial.value;
      final List<SubCategoriesModel> subCategoriesList = [
      SubCategoriesModel(
      // Dummy "All" item
      subCategoryId: ALL_ID,
      subCategoryNameEnglish: AppLanguage.allStr(appLanguage),
      subCategoryNameUrdu: AppLanguage.allStr(appLanguage),
      subCategoryNameArabic: AppLanguage.allStr(appLanguage),
      ),
      ...?categoriesData?.subCategories, // Spread real items
      ];


      if (categoriesData == null) {
        return Center(child: loadingIndicator()); // or any fallback
      }
      return _buildUI(categoriesData, productController, navigation, product, subCategoriesList);

    });
  }

  Widget _buildUI(categoriesData, productController, navigation, product, subCategoriesList){
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          /// Top Banner
          _topBannerProductsSection(categoriesData, productController, navigation),

          /// SUBCATEGORIES SCROLLABLE ROW
          _subCategoriesScrollableRowSection(categoriesData, navigation, product, subCategoriesList),

          ///PRODUCTS LIST SECTION
          _productListSection(product, productController, navigation),

          // ✅ Bottom Message Section
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

  Widget _topBannerProductsSection(categoriesData, productController, navigation){
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: productController.showTopHeader.value
          ? TopImageHeader(
        title: topBannerProductsMultiLangText(categoriesData),
        coverImage: categoriesData?.categoryCoverImage ?? "",
      )
          : appBarCommon(
        title: topBannerProductsMultiLangText(categoriesData),
        isBackNavigation: true,
        isTrailing: true,
        trailingIcon: icSearch,
        trailingIconType: IconType.SVG,
        trailingOnTap: () => navigation.gotoSearchScreen(),
      ),
    );
  }

  Widget _subCategoriesScrollableRowSection(categoriesData, navigation, product, subCategoriesList){
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
                      categoriesData!.categoryId!,
                    );
                  } else {
                    product
                        .fetchInitialProductsByCategoryAndSubCategory(
                      category: categoriesData!.categoryId!,
                      subCategory: subCategory.subCategoryId!,
                    );
                  }
                },

                child: TabItems(
                  text: subCategoriesRowMultiLangText(subCategory),
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
  }

  Widget _productListSection(product, productController, navigation){
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
  }

}







