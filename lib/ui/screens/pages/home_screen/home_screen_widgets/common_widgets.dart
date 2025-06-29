import 'dart:ffi';

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class HomeHeadings extends StatelessWidget {
  final String mainHeadingText;
  final bool isLeadingIcon;
  final String? leadingIcon;
  final GestureTapCallback onTapSeeAllText;
  const HomeHeadings({super.key, required this.mainHeadingText, required this.onTapSeeAllText,  this.isLeadingIcon = false,  this.leadingIcon});

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Padding(
        padding: const EdgeInsets.only(right: MAIN_HORIZONTAL_PADDING, left: MAIN_HORIZONTAL_PADDING),
        child: appLanguage == URDU_LANGUAGE
            ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onTapSeeAllText,
              child: appText(
                text: AppLanguage.seeAllStr(appLanguage),
                textStyle: secondaryTextStyle(),
              ),
            ),
            Spacer(),

            appText(
              text: mainHeadingText,
              textStyle: headingTextStyle(),
            ),
            isLeadingIcon ?
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: appIcon(iconType: IconType.PNG, icon: leadingIcon, width: 24.0, color: AppColors.percentageTextSkin(isDark)),
            ) : SizedBox(),

          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isLeadingIcon ?
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: appIcon(iconType: IconType.PNG, icon: leadingIcon, width: 24.0, color: AppColors.percentageTextSkin(isDark)),
            ) : SizedBox(),
            appText(
              text: mainHeadingText,
              textStyle: headingTextStyle(),
            ),
            Spacer(),
            GestureDetector(
              onTap: onTapSeeAllText,
              child: appText(
                text: AppLanguage.seeAllStr(appLanguage),
                textStyle: secondaryTextStyle(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final ProductsModel data;
  const ProductItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth;
        final imageHeight = itemWidth; // keeping square
        final nameHeight = 36.0;       // fits 2 lines approx
        final priceRowHeight = 40.0;
        final padding = 12.0 * 2;

        final totalHeight = imageHeight + nameHeight + priceRowHeight + padding;

        return Container(
          height: totalHeight, // Important!
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 Image
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: imageHeight,
                        color: whiteColor,
                        child: ClipRRect(
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                              color: EnvColors.primaryColorLight,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(4.0),
                                  bottomRight: Radius.circular(0.0))
                          ),
                          child: appText(text: AppLanguage.featureStr(appLanguage),
                              textStyle: itemTextStyle().copyWith(
                                  color: whiteColor)),
                        ),
                      )
                          : SizedBox(),
                      data.productAvailability == false
                          ? Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                              color: EnvColors.secondaryTextColorLight,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  bottomRight: Radius.circular(0.0))
                          ),
                          child: appText(text: AppLanguage.outOfStockStr(appLanguage),
                              textStyle: itemTextStyle().copyWith(
                                  color: whiteColor)),
                        ),
                      )
                          : SizedBox()
                    ],
                  ),

                  /// 🔹 Description
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: nameHeight,
                          child: Align(
                            alignment: appLanguage == URDU_LANGUAGE
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: appText(
                              text: appLanguage == URDU_LANGUAGE
                                  ? data.productNameUrdu
                                  : data.productNameEng,
                              maxLines: 2,
                              overFlow: TextOverflow.ellipsis,
                              textAlign: setTextAlignment(appLanguage),
                              textStyle: itemTextStyle(),
                            ),
                          ),
                        ),
                        SizedBox(height: 6.0),
                        SizedBox(
                          height: priceRowHeight,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  appText(
                                    text: 'Rs. ${data.productCutPrice}',
                                    textStyle: cutPriceTextStyle(),
                                  ),
                                  appText(
                                    text: 'Rs. ${data.productSellingPrice}',
                                    textStyle: sellingPriceTextStyle(),
                                  ),
                                ],
                              ),
                              Spacer(),
                              appText(
                                text: '-${calculateDiscount(data.productCutPrice!, data.productSellingPrice!)}%',
                                textStyle: sellingPriceTextStyle().copyWith(
                                  color: AppColors.percentageTextSkin(isDark),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /// 🔹 Flash Sale Tag
              if (data.productIsFlashsale == true)
                Positioned(
                  top: -3,
                  left: -3.5,
                  child: appAssetImage(image: imgSale, width: 70.0),
                ),
            ],
          ),
        );
      },
    );
  }
}
