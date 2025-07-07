import 'package:danapaniexpress/core/common_imports.dart';


class HomeScreenMobile extends StatelessWidget {
  const HomeScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Container(
        height: size.height,
        width: size.width,
        color: AppColors.backgroundColorSkin(isDark),
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
  }
}
