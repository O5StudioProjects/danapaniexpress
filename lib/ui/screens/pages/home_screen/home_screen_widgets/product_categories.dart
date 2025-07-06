import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/controllers/categories_controller/categories_controller.dart';

class ProductCategories extends StatelessWidget {
  const ProductCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashBoardController>();
    final navigation = Get.find<NavigationController>();
    final categories = Get.find<CategoriesController>();

    return Obx(() {
      if (categories.categoriesList.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: MAIN_VERTICAL_PADDING,
            // top: 0.0,
            // left: MAIN_HORIZONTAL_PADDING,
            // right: MAIN_HORIZONTAL_PADDING,
          ),
          child: Column(

            children: [
              HomeHeadings(
                  mainHeadingText:AppLanguage.productsByCategoriesStr(appLanguage).toString(),
                  onTapSeeAllText: (){
                    controller.navIndex.value = 1;
                  }),
              //  setHeight(MAIN_HORIZONTAL_PADDING),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: size.width),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate( categories.categoriesList.length > 10 ? 10 : categories.categoriesList.length, (
                      index,
                    ) {
                      var data = categories.categoriesList[index];

                      return Padding(
                        padding: EdgeInsets.only(left: index == 0 ? MAIN_HORIZONTAL_PADDING : 0.0, right: MAIN_HORIZONTAL_PADDING, top: MAIN_VERTICAL_PADDING),
                        child: SizedBox(
                            width: size.width * 0.22,
                            child: GestureDetector(
                                onTap: ()=> navigation.gotoProductsScreen(data: data),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: AppColors.cardColorSkin(isDark),
                                        borderRadius: BorderRadius.circular(12.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(30),
                                            blurRadius: 1,
                                            spreadRadius: 0,
                                            offset: const Offset(1, 2),
                                          ),
                                        ],
                                      ),
                                      child: CategoryItem(data: data)),
                                ))),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return SizedBox();
      }
    });
  }
}

