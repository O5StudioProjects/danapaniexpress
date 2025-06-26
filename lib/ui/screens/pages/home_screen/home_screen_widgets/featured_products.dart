import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

import '../../../../../domain/controllers/dashboard_controller/dashboard_controller.dart';

class FeaturedProducts extends StatelessWidget {
  const FeaturedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashBoardController>();

    return Obx(() {
      if (controller.categoriesList.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.only(
            top: 0.0,
            bottom: MAIN_VERTICAL_PADDING,
            left: MAIN_HORIZONTAL_PADDING,
            // right: MAIN_HORIZONTAL_PADDING,
          ),
          child: Column(

            children: [
              Padding(
                padding: const EdgeInsets.only(right: MAIN_HORIZONTAL_PADDING),
                child: appLanguage == URDU_LANGUAGE
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    appText(
                      text: 'مزید دیکھیے',
                      textStyle: secondaryTextStyle(),
                    ),

                    GestureDetector(
                      onTap: (){},
                      child: appText(
                        text: 'مصنوعات کی کیٹیگریز',
                        textStyle: headingTextStyle(),
                      ),
                    ),

                  ],
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    appText(
                      text: 'Featured Products',
                      textStyle: headingTextStyle(),
                    ),
                    appText(
                      text: 'See All',
                      textStyle: secondaryTextStyle(),
                    ),
                  ],
                ),
              ),
              //  setHeight(MAIN_HORIZONTAL_PADDING),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  children: List.generate( controller.productsList.where((test)=> test.productIsFeatured == true).length > 10 ? 10 : controller.productsList.where((test)=> test.productIsFeatured == true).length, (
                      index,
                      ) {
                    var data = controller.productsList[index];
                    return featuredProductsItem(data: data);
                  }),
                ),
              ),
            ],
          ),
        );
      } else {
        return SizedBox();
      }
    });
  }
}

Widget featuredProductsItem({required ProductsModel data}) {
  return Padding(
    padding: const EdgeInsets.only(
        top: MAIN_HORIZONTAL_PADDING,
        right: MAIN_HORIZONTAL_PADDING,
      bottom: MAIN_VERTICAL_PADDING
    ),
    child: Container(
     width: size.width * 0.4,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.cardColorSkin(isDark),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Fixed size image container
              Stack(
                children: [
                  Container(
                    width: size.width * 0.4,
                    height: size.width * 0.4,
                    decoration: BoxDecoration(
                      color: AppColors.cardColorSkin(isDark),
                    ),
                    child: ClipRRect(
                      // borderRadius: BorderRadius.circular(12.0),
                      child: appAsyncImage(
                        data.productImage,
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),

                  data.productIsFeatured == true
                  ? Positioned(
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                          color: EnvColors.primaryColorLight,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(4.0), bottomRight: Radius.circular(0.0))
                      ),
                      child: appText(text: 'Feature', textStyle: itemTextStyle().copyWith(color: whiteColor)),
                    ),
                  )
                  : SizedBox(),
                  data.productAvailability == false
                  ? Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                          color: EnvColors.secondaryTextColorLight,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), bottomRight: Radius.circular(0.0))
                      ),
                      child: appText(text: 'Out of stock', textStyle: itemTextStyle().copyWith(color: whiteColor)),
                    ),
                  )
                      : SizedBox()
                ],
              ),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// PRODUCT NAME
                    SizedBox(
                      height: size.height * 0.045,
                      width: size.width,
                      child: Align(
                        alignment: appLanguage == URDU_LANGUAGE
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: appText(
                            text:
                            appLanguage == URDU_LANGUAGE
                                ? data.productNameUrdu
                                : data.productNameEng,
                            maxLines: 2,
                            overFlow: TextOverflow.ellipsis,
                            textAlign: setTextAlignment(appLanguage),
                            textStyle: itemTextStyle()
                        ),
                      ),
                    ),


                    /// CUT PRICE // Price
                   setHeight(6.0),

                    SizedBox(
                      height: size.height * 0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              appText(text: 'Rs. ${data.productCutPrice}', textStyle: cutPriceTextStyle()),// CUT PRICE
                              appText(text: 'Rs. ${data.productSellingPrice}', textStyle: sellingPriceTextStyle()) // SELLING PRICE
                            ],
                          ),
                          Spacer(),
                          appText(text: '-${calculateDiscount(data.productCutPrice!, data.productSellingPrice!)}%', textStyle: sellingPriceTextStyle().copyWith(color: AppColors.percentageTextSkin(isDark)))
                        ],
                      ),
                    )

                  ],
                ),
              )
              // 🔹 Responsive Text

            ],
          ),

          data.productIsFlashsale == true
          ? Positioned(
              top: -3,
              left: -3.5,
              child: appAssetImage(image: imgSale, width: 70.0))
          : SizedBox(),

        ],
      )
    ),
  );
}