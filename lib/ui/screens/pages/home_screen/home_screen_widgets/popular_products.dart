import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashBoardController>();

    return Obx(() {
      if (controller.popularProducts.isNotEmpty) {
        return Column(
          children: [
            HomeHeadings(
              mainHeadingText: AppLanguage.popularProductsStr(appLanguage).toString(),
              onTapSeeAllText: (){},
            ),
            //  setHeight(MAIN_HORIZONTAL_PADDING),
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: size.height),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: MAIN_HORIZONTAL_PADDING,
                  vertical: MAIN_VERTICAL_PADDING,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: MAIN_HORIZONTAL_PADDING,
                  mainAxisSpacing: MAIN_HORIZONTAL_PADDING,
                  childAspectRatio: 0.6, // tweak this for height vs width
                ),
                itemCount: controller.popularProducts.length > 50 ? 50 : controller.popularProducts.length,
                itemBuilder: (context, index) {
                  var data = controller.popularProducts[index];
                  return ProductItem(
                    data: data,
                  );
                },
              ),
            ),
          ],
        );
      } else {
        return SizedBox();
      }
    });  }
}
