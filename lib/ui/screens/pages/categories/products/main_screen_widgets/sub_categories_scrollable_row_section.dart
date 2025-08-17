import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class SubCategoriesScrollableRowSection extends StatelessWidget {
  final CategoryModel? categoriesData;
  const SubCategoriesScrollableRowSection({super.key, this.categoriesData});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI(){
    var product = Get.find<ProductsController>();
    return Obx((){
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
    });
  }

}
