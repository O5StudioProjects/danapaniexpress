import 'package:danapaniexpress/core/common_imports.dart';

class HomeScreenMobile extends StatelessWidget {
  const HomeScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {

    return Obx((){
      return Container(
        height: size.height,
        width: size.width,
        color: AppColors.backgroundColorSkin(isDark),
        child: RefreshIndicator(
          onRefresh: () async {

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
