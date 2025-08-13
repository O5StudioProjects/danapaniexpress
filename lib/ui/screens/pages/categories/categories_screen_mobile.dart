import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';


class CategoriesScreenMobile extends StatelessWidget {
  const CategoriesScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var categories = Get.find<CategoriesController>();
    return Obx(() {
      var categoriesData = categories.categoriesList[categories.categoryIndex.value];
      final List<SubCategoriesModel> subCategoriesList = [
        SubCategoriesModel( // Dummy "All" item
            categoryId: categoriesData.categoryId,
            subCategoryId: ALL_ID,
            subCategoryNameEnglish: AppLanguage.allStr(appLanguage),
            subCategoryNameUrdu:  AppLanguage.allStr(appLanguage),
            subCategoryNameArabic: AppLanguage.allStr(appLanguage),
            subCategoryImage: categoriesData.categoryImage
        ),
        ...?categoriesData.subCategories, // Spread real items
      ];
      return _buildUI(categories, categoriesData, subCategoriesList);
    });
  }

  Widget _buildUI(categories, categoriesData, subCategoriesList){
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          appBarCommon(
            title: isRightLang ? categoriesData.categoryNameUrdu : categoriesData.categoryNameEnglish,
            isBackNavigation: false,
          ),
          _mainSection(categories,subCategoriesList,categoriesData)
        ],
      ),
    );
  }

  Widget _mainSection(categories,subCategoriesList,categoriesData){
    return
      categories.categoriesList.isNotEmpty
          ? Expanded(
        child: Row(
          children: [
            ///CATEGORIES Section
            _leftCategoriesSection(categories),

            ///SUBCATEGORIES Section
            _subCategoriesSection(subCategoriesList, categories, categoriesData)
          ],
        ),
      )
          : Expanded(
        child: EmptyScreen(
          icon: AppAnims.animEmptyBoxSkin(isDark),
          text: AppLanguage.noCategoriesStr(appLanguage).toString(),
        ),
      );
  }

  Widget _leftCategoriesSection(categories){
    return Container(
      width: size.width * 0.25,
      height: size.height,
      color: AppColors.cardColorSkin(isDark),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            categories.categoriesList.length,
                (index) {
              return GestureDetector(
                onTap: () {
                  categories.onTapCategories(index);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color:
                      categories.categoryIndex.value == index
                          ? AppColors.secondaryTextColorSkin(isDark).withValues(alpha: 0.4)
                          : Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
                        child: CategoryItem(
                          data: categories.categoriesList[index],
                        ),
                      ),
                    ),
                    if(index != categories.categoriesList.length -1)
                      appDivider(height: 0.0)
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _subCategoriesSection(subCategoriesList, categories, categoriesData){
    return
      subCategoriesList.isNotEmpty
          ? Expanded(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: size.height,
          ),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: MAIN_HORIZONTAL_PADDING,
                  vertical: MAIN_HORIZONTAL_PADDING,
                ),
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: MAIN_HORIZONTAL_PADDING,
                  mainAxisSpacing:
                  MAIN_HORIZONTAL_PADDING,
                  childAspectRatio: 0.7, // tweak this for height vs width
                ),
                itemCount: subCategoriesList.length,
                itemBuilder: (context, index) {
                  var listData = subCategoriesList[index];
                  return GestureDetector(
                      onTap: ()=> categories.onTapSubCategories(index, categoriesData),
                      child: SubCategoryItem(data: listData));
                },
              )
          ),
        ),
      )
          : Expanded(
        child: EmptyScreen(
          icon: AppAnims.animEmptyBoxSkin(isDark),
          text: AppLanguage.noCategoriesStr(appLanguage,).toString(),
        ),
      );
  }


}


