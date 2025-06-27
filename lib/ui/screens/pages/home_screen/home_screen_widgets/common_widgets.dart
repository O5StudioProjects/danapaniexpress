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
              onTap: onTapSeeAllText,
              child: appText(
                text: mainHeadingText,
                textStyle: headingTextStyle(),
              ),
            ),

          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            appText(
              text: mainHeadingText,
              textStyle: headingTextStyle(),
            ),
            GestureDetector(
              onTap: onTapSeeAllText,
              child: appText(
                text: 'See All',
                textStyle: secondaryTextStyle(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class ProductImagePart extends StatelessWidget {
  final double? width;
  final double? height;
  final ProductsModel data;
  const ProductImagePart({super.key, this.width, this.height, required this.data});

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Stack(
        children: [
          Container(
            // width: size.width * 0.4,
            // height: size.width * 0.4,
            width: width,
            height: height,
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
              padding: EdgeInsets.symmetric(
                  horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                  color: EnvColors.primaryColorLight,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4.0),
                      bottomRight: Radius.circular(0.0))
              ),
              child: appText(text: 'Feature',
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
              child: appText(text: 'Out of stock',
                  textStyle: itemTextStyle().copyWith(
                      color: whiteColor)),
            ),
          )
              : SizedBox()
        ],
      ),
    );
  }
}



class ProductDescriptionPart extends StatelessWidget {
  final ProductsModel data;
  const ProductDescriptionPart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return  Obx(
      ()=> Padding(
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
                      appText(text: 'Rs. ${data.productCutPrice}',
                          textStyle: cutPriceTextStyle()),
                      // CUT PRICE
                      appText(text: 'Rs. ${data.productSellingPrice}',
                          textStyle: sellingPriceTextStyle())
                      // SELLING PRICE
                    ],
                  ),
                  Spacer(),
                  appText(text: '-${calculateDiscount(
                      data.productCutPrice!,
                      data.productSellingPrice!)}%',
                      textStyle: sellingPriceTextStyle().copyWith(
                          color: AppColors.percentageTextSkin(
                              isDark)))
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}



class FullProductUI extends StatelessWidget {
  final ProductsModel data;
  const FullProductUI({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Fixed size image container
            ProductImagePart(
                width: size.width * 0.4,
                height: size.width * 0.4,
                data: data),

            ProductDescriptionPart(data: data)
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
    );
  }
}
