import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class CategoriesScreenMobile extends StatelessWidget {
  const CategoriesScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var categories = Get.find<CategoriesController>();
    return Obx(() {
      var categoriesData = categories.categoriesList[categories.categoryIndex.value];

      return _buildUI(categories, categoriesData);
    });
  }

  Widget _buildUI(categories, categoriesData){
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
          _mainSection(categories,categoriesData)
        ],
      ),
    );
  }

  Widget _mainSection(categories,categoriesData){
    return
      categories.categoriesList.isNotEmpty
          ? Expanded(
        child: Row(
          children: [
            ///CATEGORIES Section
            LeftCategoriesSection(),

            ///SUBCATEGORIES Section
            SubCategoriesSection(categoriesData: categoriesData)
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


}


