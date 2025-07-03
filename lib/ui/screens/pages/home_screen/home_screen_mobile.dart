import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/ui/screens/pages/home_screen/home_screen_widgets/featured_products.dart';
import 'package:danapaniexpress/ui/screens/pages/home_screen/home_screen_widgets/flash_sale_products.dart';
import 'package:danapaniexpress/ui/screens/pages/home_screen/home_screen_widgets/popular_products.dart';
import 'package:danapaniexpress/ui/screens/pages/home_screen/home_screen_widgets/single_banner.dart';

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
