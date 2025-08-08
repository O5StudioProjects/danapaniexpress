import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/ui/app_common/dialogs/events_popup.dart';
import 'package:danapaniexpress/ui/screens/pages/home_screen/home_screen_widgets/custom_orders.dart';


class HomeScreenMobile extends StatelessWidget {
  const HomeScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var home = Get.find<HomeController>();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if(home.eventsPopupData.value != null){
    //     showCustomDialog(context, AppEventsDialog(data: home.eventsPopupData.value));
    //   }
    //
    // });
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
