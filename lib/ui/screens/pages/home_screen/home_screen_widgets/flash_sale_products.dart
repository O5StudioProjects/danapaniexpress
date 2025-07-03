import 'package:danapaniexpress/core/common_imports.dart';

import 'package:danapaniexpress/core/controllers_import.dart';

class FlashSaleProducts extends StatelessWidget {
  const FlashSaleProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashBoardController>();
    final navigation  = Get.find<NavigationController>();

    return Obx(() {
      if (controller.flashSaleProducts.isNotEmpty) {
        return Column(

          children: [
            HomeHeadings(
              mainHeadingText: AppLanguage.flashSaleStr(appLanguage).toString(),
              onTapSeeAllText: ()=> navigation.gotoOtherProductsScreen(screenType: ProductsScreenType.FLASHSALE),
              isLeadingIcon: true,
              leadingIcon: icFlashSale,
            ),
            //  setHeight(MAIN_HORIZONTAL_PADDING),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: size.width), // Force at least screen width
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                      controller.flashSaleProducts.length > 10 ? 10 : controller.flashSaleProducts.length, (index,) {
                    var data = controller.flashSaleProducts[index];
                    return Padding(
                        padding: EdgeInsets.only(left: index == 0 ? MAIN_HORIZONTAL_PADDING : 0.0,
                            top: MAIN_VERTICAL_PADDING,
                            bottom: MAIN_VERTICAL_PADDING, right: MAIN_HORIZONTAL_PADDING
                        ),
                        child: SizedBox(
                            width: size.width * 0.4 ,
                            child: ProductItem(data: data)));
                  }),
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
