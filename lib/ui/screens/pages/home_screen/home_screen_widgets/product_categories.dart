import 'package:danapaniexpress/core/common_imports.dart';

import '../../../../../data/models/sub_categories_model.dart';
import '../../../../../domain/controllers/dashboard_controller/dashboard_controller.dart';

class ProductCategories extends StatelessWidget {
  const ProductCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashBoardController>();

    return Obx(() {
      if (controller.categoriesList.isNotEmpty) {
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
                  onTapSeeAllText: (){}),
              //  setHeight(MAIN_HORIZONTAL_PADDING),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: size.width),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate( controller.categoriesList.length > 10 ? 10 : controller.categoriesList.length, (
                      index,
                    ) {
                      var data = controller.categoriesList[index];
                      return Padding(
                        padding: EdgeInsets.only(left: index == 0 ? MAIN_HORIZONTAL_PADDING : 0.0),
                        child: productCategoriesItem(data: data),
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


Widget productCategoriesItem({required data}) {
  return Padding(
    padding: const EdgeInsets.only(
      top: MAIN_HORIZONTAL_PADDING,
      right: MAIN_HORIZONTAL_PADDING
    ),
    child: SizedBox(
      width: size.width * 0.2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔹 Fixed size image container
          Container(
            width: size.width * 0.2,
            height: size.width * 0.2,
            decoration: BoxDecoration(
              color: AppColors.cardColorSkin(isDark),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(40),
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: appAsyncImage(
                data.categoryImage,
                boxFit: BoxFit.cover,
              ),
            ),
          ),

           setHeight(8.0),
          // 🔹 Responsive Text
          SizedBox(
            height: size.height * 0.04,
            child: appText(
              text:
              appLanguage == URDU_LANGUAGE
                  ? data.categoryNameUrdu
                  : data.categoryNameEnglish,
              maxLines: 2,
              overFlow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              textStyle: bodyTextStyle().copyWith(
                fontSize: appLanguage == URDU_LANGUAGE
                    ? SUB_HEADING_TEXT_BUTTON_FONT_SIZE +2
                    : SUB_HEADING_TEXT_BUTTON_FONT_SIZE
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
