import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/controllers/product_controller/products_controller.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  @override
  Widget build(BuildContext context) {
    // final dashboard = Get.find<DashBoardController>();
    final products = Get.find<ProductsController>();
    final navigation  = Get.find<NavigationController>();

    return Obx(() {
      if (products.popularProducts.isNotEmpty) {
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
                itemCount: products.popularProducts.length > 50 ? 50 : products.popularProducts.length,
                itemBuilder: (context, index) {
                  var data = products.popularProducts[index];
                  return GestureDetector(
                    onTap: ()=>  navigation.gotoProductDetailScreen(data: data),
                    child: ProductItem(
                      data: data,
                    ),
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
