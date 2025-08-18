import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class HomeScreenMobile extends StatelessWidget {
  const HomeScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {

    final home  = Get.find<HomeController>();

    return Obx((){
      return Container(
        height: size.height,
        width: size.width,
        color: AppColors.backgroundColorSkin(isDark),
        child: RefreshIndicator(
          backgroundColor: AppColors.materialButtonSkin(isDark),
          color: AppColors.materialButtonTextSkin(isDark),
          elevation: 0.0,
          onRefresh: () async {
            home.fetchInitialMethods();
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
                    CustomOrdersBanner(),
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
