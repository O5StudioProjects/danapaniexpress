import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class SubCategoriesSection extends StatelessWidget {
  final CategoryModel categoriesData;
  const SubCategoriesSection({super.key, required this.categoriesData});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI(){
    var categories = Get.find<CategoriesController>();

    return Obx((){
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
      if(subCategoriesList.isNotEmpty){
        return Expanded(
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
        );
      } else {
        return Expanded(
          child: EmptyScreen(
            icon: AppAnims.animEmptyBoxSkin(isDark),
            text: AppLanguage.noCategoriesStr(appLanguage,).toString(),
          ),
        );
      }
    });
  }
}
