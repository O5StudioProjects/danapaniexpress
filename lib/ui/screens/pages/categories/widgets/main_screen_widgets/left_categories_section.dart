import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class LeftCategoriesSection extends StatelessWidget {
  const LeftCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI(){
    var categories = Get.find<CategoriesController>();
    return Obx((){
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
    });
  }
}
