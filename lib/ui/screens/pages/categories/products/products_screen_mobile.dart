import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class ProductsScreenMobile extends StatelessWidget {

  const ProductsScreenMobile({super.key });

  @override
  Widget build(BuildContext context) {
    var productController = Get.find<ProductController>();
    var data = productController.categoryDataInitial.value!;
    return Obx(
      ()=> Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            SizedBox(
              width: size.width,
              height: size.height * 0.2,
              child: appAsyncImage(data.categoryCoverImage, boxFit: BoxFit.cover),
            ),

            setHeight(MAIN_VERTICAL_PADDING),

            Padding(
              padding: const EdgeInsets.only(left: MAIN_HORIZONTAL_PADDING),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: size.width),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(data.subCategories!.length, (index){
                      var listData = data.subCategories![index];
                      return GestureDetector(
                          onTap: ()=> productController.onTapSubCategories(index, data),
                          child: TabItems(text: listData.subCategoryNameEnglish.toString(), isSelected: productController.subCategoryIndex.value == index ? true : false));
                    }),
                  ),
                ),
              ),
            ),
          //  setHeight(10.0),

            productController.productsStatus.value == ProductsByCatStatus.LOADING
            ? Expanded(child: loadingIndicator())
            : productController.productsStatus.value  == ProductsByCatStatus.FAILURE
            ? Expanded(child: appText(text: 'Error Screen'))
            : productController.productsList.isEmpty
            ? EmptyScreen(icon: icCategories, text: AppLanguage.noProductsStr(appLanguage).toString())
            : Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: MAIN_HORIZONTAL_PADDING,
                    vertical: MAIN_VERTICAL_PADDING,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: MAIN_HORIZONTAL_PADDING,
                    mainAxisSpacing: MAIN_HORIZONTAL_PADDING,
                    childAspectRatio: 0.6, // tweak this for height vs width
                  ),
                  itemCount: productController.productsList.length > 50 ? 50 : productController.productsList.length,
                  itemBuilder: (context, index) {
                    var data = productController.productsList[index];
                    return ProductItem(
                      data: data,
                    );
                  },
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class TabItems extends StatelessWidget {
  final String text;
  final bool isSelected;
  const TabItems({super.key, required this.text, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: MAIN_HORIZONTAL_PADDING / 2),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.selectedTabItemsColorSkin(isDark) : AppColors.tabItemsColorSkin(isDark),
          borderRadius: BorderRadius.circular(5.0)
        ),
        child: appText(text: text, textStyle: tabItemTextStyle(isSelected: isSelected)),
      ),
    );
  }
}
