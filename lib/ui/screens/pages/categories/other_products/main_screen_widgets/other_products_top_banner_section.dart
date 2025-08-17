import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class OtherProductsTopBannerSection extends StatelessWidget {
  final ProductsScreenType screenType;
  const OtherProductsTopBannerSection({super.key, required this.screenType});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI(){
    final otherProductsController = Get.put(OtherProductsController());
    final navigation = Get.find<NavigationController>();
    final home = Get.find<HomeController>();

    return Obx((){
      final screenName = screenType == ProductsScreenType.FEATURED
          ? AppLanguage.featuredProductStr(appLanguage)
          : screenType == ProductsScreenType.FLASHSALE
          ? AppLanguage.flashSaleStr(appLanguage)
          : screenType == ProductsScreenType.POPULAR
          ? AppLanguage.popularProductsStr(appLanguage)
          : null;

      final coverImage = screenType == ProductsScreenType.FEATURED
          ? home.coverImages.value!.featured
          : screenType == ProductsScreenType.FLASHSALE
          ? home.coverImages.value!.flashSale
          : screenType == ProductsScreenType.POPULAR
          ? home.coverImages.value!.popular
          : null;


      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: otherProductsController.showTopHeader.value
            ? TopImageHeader(title: screenName!, coverImage: coverImage ?? "")
            : appBarCommon(
          title: screenName!,
          isBackNavigation: true,
          isTrailing: true,
          trailingIcon: icSearch,
          trailingIconType: IconType.SVG,
          trailingOnTap: () => navigation.gotoSearchScreen(),
        ),
      );
    });
  }

}
