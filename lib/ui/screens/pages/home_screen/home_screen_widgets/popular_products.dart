import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboard = Get.find<DashBoardController>();
    final navigation  = Get.find<NavigationController>();

    return Obx(() {
      if (dashboard.popularProducts.isNotEmpty) {
        return Column(
          children: [
            HomeHeadings(
              mainHeadingText: AppLanguage.popularProductsStr(appLanguage).toString(),
              onTapSeeAllText: ()=> navigation.gotoOtherProductsScreen(screenType: ProductsScreenType.POPULAR),
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
                itemCount: dashboard.popularProducts.length > 50 ? 50 : dashboard.popularProducts.length,
                itemBuilder: (context, index) {
                  var data = dashboard.popularProducts[index];
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
