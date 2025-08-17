import 'package:danapaniexpress/core/common_imports.dart';

class ProductDetailSection extends StatelessWidget {
  const ProductDetailSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.only(
          left: MAIN_HORIZONTAL_PADDING,
          right: MAIN_HORIZONTAL_PADDING,
          bottom: MAIN_HORIZONTAL_PADDING,
        ),
        child: Obx((){
          return Column(
              crossAxisAlignment: isRightLang
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                ///CATEGORY AND SUBCATEGORY - FAVORITE BUTTON
                CategorySubcategoryFavoriteSection(),
                /// DESCRIPTION
                ProductDescriptionSection(),
              ]
          );
        }),
      ),
    );
  }
}