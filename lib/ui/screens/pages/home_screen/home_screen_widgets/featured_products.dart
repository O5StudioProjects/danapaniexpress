import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class FeaturedProducts extends StatelessWidget {
  const FeaturedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashBoardController>();

    return Obx(() {
      if (controller.featuredProducts.isNotEmpty) {
        return Column(
          children: [
            HomeHeadings(
                mainHeadingText: AppLanguage.featuredProductStr(appLanguage).toString(),
                onTapSeeAllText: (){},
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: size.width),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                      controller.featuredProducts.length > 10 ? 10 : controller.featuredProducts.length, (index,) {
                    var data = controller.featuredProducts[index];
                    return Padding(
                        padding: EdgeInsets.only(left: index == 0 ? MAIN_HORIZONTAL_PADDING : 0.0,
                        top: MAIN_VERTICAL_PADDING,
                          bottom: MAIN_VERTICAL_PADDING, right: MAIN_HORIZONTAL_PADDING
                        ),
                        child: SizedBox(
                            width: size.width * 0.4 ,
                            child: ProductItem(data: data)));
                  }),
                ),
              ),
            ),
          ],
        );
      } else {
        return SizedBox();
      }
    });
  }
}
