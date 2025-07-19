import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class ProductsRowUi extends StatelessWidget {
  final List<ProductModel> products;
  final String? headingTitle;
  final ProductsScreenType screenType;
  final bool? isTrailingText;
  final bool? isSeeAll;
  final bool? isDetailScreen;
  final double? horizontalPadding;
  final double? firstIndexLeftPadding;

  const ProductsRowUi({
    super.key,
    required this.products,
    this.headingTitle,
    required this.screenType, this.isTrailingText = false, this.isSeeAll = true, this.isDetailScreen= false, this.horizontalPadding = MAIN_HORIZONTAL_PADDING, this.firstIndexLeftPadding = MAIN_HORIZONTAL_PADDING,

  });

  @override
  Widget build(BuildContext context) {
    var navigation = Get.find<NavigationController>();
    return Obx(() {
      if (products.isNotEmpty) {
        return Column(
          children: [
            HomeHeadings(
              isTrailingText: isTrailingText!,
              isSeeAll: isSeeAll!,
              isLeadingIcon: screenType == ProductsScreenType.FLASHSALE ? true : false,
              leadingIcon: icFlashSale,
              horizontalPadding: horizontalPadding,
              mainHeadingText: screenType == ProductsScreenType.FEATURED
                  ? AppLanguage.featuredProductStr(appLanguage).toString()
                  : screenType == ProductsScreenType.FLASHSALE
                  ? AppLanguage.flashSaleStr(appLanguage).toString()
                  : headingTitle.toString(),
              onTapSeeAllText: () => screenType == ProductsScreenType.CATEGORIES
                  ? Get.back()
                  : navigation.gotoOtherProductsScreen(
                      screenType: screenType,
                    )
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: size.width),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    products.length > 10 ? 10 : products.length,
                    (index) {
                      var data = products[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? firstIndexLeftPadding! : 0.0,
                          top: MAIN_VERTICAL_PADDING,
                          bottom: MAIN_VERTICAL_PADDING,
                          right: MAIN_HORIZONTAL_PADDING,
                        ),
                        child: GestureDetector(
                          onTap: (){
                            if(isDetailScreen!){
                             Get.back();
                             navigation.gotoProductDetailScreen(data: data);
                              print('OnTap Working');
                            } else {
                              navigation.gotoProductDetailScreen(data: data);
                              print('OnTap Working');
                            }
                          },
                          child: SizedBox(
                            width: size.width * 0.4,
                            child: ProductItem(data: data),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        return SizedBox();
      }
    });
  }
}
