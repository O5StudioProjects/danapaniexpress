import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class CategoriesScreenMobile extends StatelessWidget {
  const CategoriesScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var controller  = Get.find<DashBoardController>();
    return Obx((){

      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(title: AppLanguage.productsByCategoriesStr(appLanguage), isBackNavigation: false),
            Expanded(
              child: Row(
                children: [
                  ///CATEGORIES Section
                  Container(
                    width: size.width * 0.25,
                    height: size.height,
                    color: AppColors.cardColorSkin(isDark),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(controller.categoriesList.length, (index){
                          return GestureDetector(
                            onTap: (){
                              controller.onTapCategories(index);
                            },
                            child: Container(
                              color: controller.categoryIndex.value == index ? AppColors.secondaryTextColorSkin(isDark).withValues(alpha: 0.4) : Colors.transparent,
                              child: Padding(
                                  padding: EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
                                  child: CategoryItem(data: controller.categoriesList[index]),),
                            ),
                          );
                        })
                      ),
                    ),

                  ),

                  ///SUBCATEGORIES Section
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: size.height),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: MAIN_HORIZONTAL_PADDING,
                          vertical: MAIN_HORIZONTAL_PADDING,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: MAIN_HORIZONTAL_PADDING,
                          mainAxisSpacing: MAIN_HORIZONTAL_PADDING,
                          childAspectRatio: 0.7, // tweak this for height vs width
                        ),
                        itemCount: controller.categoriesList[controller.categoryIndex.value].subCategories!.length,
                        itemBuilder: (context, index) {
                          var data = controller.categoriesList[controller.categoryIndex.value].subCategories![index];
                          return SubCategoryItem(
                            data: data,
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
