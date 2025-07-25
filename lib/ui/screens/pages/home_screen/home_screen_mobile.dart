import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';


class HomeScreenMobile extends StatelessWidget {
  const HomeScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx((){
      var products = Get.find<ProductsController>();
      return Container(
        height: size.height,
        width: size.width,
        color: AppColors.backgroundColorSkin(isDark),
        child: RefreshIndicator(
          onRefresh: () async {
            products.fetchInitialFeaturedProducts();
            products.fetchInitialFlashSaleProducts();
          },
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              appSliverAppbarHome(),

              SliverToBoxAdapter(
                child: Column(
                  children: [
                    setHeight(MAIN_VERTICAL_PADDING),
                    NotificationBar(),
                    ProductCategories(),
                    BodyImagePager(),
                    FeaturedProducts(),
                    SingleBanner(homeSingleBanner: HomeSingleBanner.ONE),
                    FlashSaleProducts(),
                    SingleBanner(homeSingleBanner: HomeSingleBanner.TWO),
                    PopularProducts(),

                  ],
                ),
              ),

            ],
          ),
        ),
      );
    });
  }
}
