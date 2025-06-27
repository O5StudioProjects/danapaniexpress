import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class FeaturedProducts extends StatelessWidget {
  const FeaturedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashBoardController>();

    return Obx(() {
      if (controller.categoriesList.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.only(
            top: 0.0,
            bottom: MAIN_VERTICAL_PADDING,
            left: MAIN_HORIZONTAL_PADDING,
            // right: MAIN_HORIZONTAL_PADDING,
          ),
          child: Column(

            children: [
              HomeHeadings(
                  mainHeadingText: 'Featured Products',
                  onTapSeeAllText: (){},
                  isLeadingIcon: false,),
              //  setHeight(MAIN_HORIZONTAL_PADDING),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  children: List.generate(
                      controller.featuredProducts.length, (index,) {
                    var data = controller.featuredProducts[index];
                    return featuredProductsItem(data: data);
                  }),
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

Widget featuredProductsItem({required ProductsModel data}) {
  return Padding(
    padding: const EdgeInsets.only(
        top: MAIN_HORIZONTAL_PADDING,
        right: MAIN_HORIZONTAL_PADDING,
        bottom: MAIN_VERTICAL_PADDING
    ),
    child: Container(
        width: size.width * 0.4,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.cardColorSkin(isDark),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: FullProductUI(data: data)
    ),
  );
}