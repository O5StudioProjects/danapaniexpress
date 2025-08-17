import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class TopBannerProductsSection extends StatelessWidget {
  final CategoryModel? categoriesData;
  const TopBannerProductsSection({super.key, this.categoriesData});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI(){
    var productController = Get.find<ProductScrollController>();
    var navigation = Get.find<NavigationController>();
    return Obx((){
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: productController.showTopHeader.value
            ? TopImageHeader(
          title: topBannerProductsMultiLangText(categoriesData),
          coverImage: categoriesData?.categoryCoverImage ?? "",
        )
            : appBarCommon(
          title: topBannerProductsMultiLangText(categoriesData),
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
