import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final products = Get.find<ProductsController>();
    final navigation = Get.find<NavigationController>();

    return Obx(() {
      if (products.popularProducts.isNotEmpty) {
        return Column(
          children: [
            HomeHeadings(
              mainHeadingText: AppLanguage.popularProductsStr(appLanguage).toString(),
              onTapSeeAllText: () => navigation.gotoOtherProductsScreen(screenType: ProductsScreenType.POPULAR),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: MAIN_HORIZONTAL_PADDING,
                vertical: MAIN_VERTICAL_PADDING,
              ),
              child: StaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: MAIN_HORIZONTAL_PADDING,
                crossAxisSpacing: MAIN_HORIZONTAL_PADDING,
                children: List.generate(
                  products.popularProducts.length > 50 ? 50 : products.popularProducts.length,
                      (index) {
                    final data = products.popularProducts[index];
                    return GestureDetector(
                      onTap: () => navigation.gotoProductDetailScreen(data: data),
                      child: ProductItem(data: data),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
