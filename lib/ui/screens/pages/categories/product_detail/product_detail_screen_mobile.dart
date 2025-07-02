import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/ui/app_common/components/expandable_text.dart';
import 'package:danapaniexpress/ui/screens/pages/categories/product_detail/product_detail_utils.dart';
import 'package:readmore/readmore.dart';
import '../../../../../core/data_model_imports.dart';

class ProductDetailScreenMobile extends StatelessWidget {
  const ProductDetailScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var product = Get.put(ProductDetailController());
    return Obx(() {
      var data = product.productData.value!;
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.cardColorSkin(isDark),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                // physics: BouncingScrollPhysics(),
                child: Column(
                  children: [

                    ///TOP IMAGE SECTION
                    centerImageForProductsUI(data.productImage),

                    ///PRODUCT DETAIL PART
                    productDetailPartUI(data: data),
                  ],
                ),
              ),
            ),

            /// Bottom Part -- Add to cart and calculator
            cartSectionUI(data: data),
          ],
        ),
      );
    });
  }
}

///TOP IMAGE SECTION
Widget centerImageForProductsUI(image) {
  return SizedBox(
    width: size.width,
    height: size.height * 0.4,
    //  decoration: BoxDecoration(color: AppColors.cardColorSkin(isDark)),
    child: Stack(
      children: [

        ///CENTER IMAGE FOR PRODUCT
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                color: AppColors.backgroundColorSkin(isDark),
                width: size.width * 0.6,
                // or use min(size.width, size.height) * 0.5
                child: AspectRatio(
                  aspectRatio: 1,
                  child: appAsyncImage(image, boxFit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ),

        ///BACK NAVIGATION BUTTON
        Positioned(
          top: 50.0,
          left: MAIN_HORIZONTAL_PADDING,
          child: appFloatingButton(icon: icArrowLeft, onTap: (){
            Get.back();
            // if(appLanguage == ENGLISH_LANGUAGE) {
            //   Get.find<ThemeController>().changeLanguage(language: URDU_LANGUAGE);
            // } else {
            //   Get.find<ThemeController>().changeLanguage(language: ENGLISH_LANGUAGE);
            // }
          }),
        ),
      ],
    ),
  );
}

///PRODUCT DETAIL BACKGROUND LAYOUT
Widget productDetailPartUI({required ProductsModel data}) {
  return ConstrainedBox(
    constraints: BoxConstraints(minHeight: size.height,minWidth: size.width),
    child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundColorSkin(isDark),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26.0),
            topRight: Radius.circular(26.0),
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withAlpha(10),
          //     blurRadius: 4,
          //     spreadRadius: 2,
          //     offset: const Offset(2, 1),
          //   ),
          // ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
          child: productDetailLDataUI(data: data),
        )
    ),
  );
}

/// PRODUCT DETAIL DATA UI PRESENTATION
Column productDetailLDataUI({required ProductsModel data}) {
  var product = Get.find<ProductDetailController>();
  return Column(
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: appLanguage == URDU_LANGUAGE ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: [
      ///CATEGORY AND SUBCATEGORY - FAVORITE BUTTON
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          appText(text: '${data.productCategory} > ${data.productSubCategory}',
              textStyle: secondaryTextStyle().copyWith(
                  color: AppColors.secondaryTextColorSkin(isDark).withValues(
                      alpha: 0.7))),

          GestureDetector(
              onTap: (){
                Get.find<ThemeController>().changeTheme();
              },
              child: appIcon(iconType: IconType.PNG, icon: icHeart, width: 20.0, color: AppColors.backgroundColorInverseSkin(isDark)))
        ],
      ),
      setHeight(MAIN_HORIZONTAL_PADDING),

      /// PRODUCT NAME
      appText(text: appLanguage == URDU_LANGUAGE ? data.productNameUrdu : data.productNameEng, 
          textAlign: setTextAlignment(appLanguage),
          textDirection: setTextDirection(appLanguage),
          textStyle: bigBoldHeadingTextStyle()),

      /// PRODUCT PRICE
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          appText(
            text: 'Rs. ${data.productSellingPrice!.toStringAsFixed(1)}', textStyle: sellingPriceDetailTextStyle(),
          ),
          if(data.productCutPrice != null)
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: appText(
              text: 'Rs. ${data.productCutPrice?.toStringAsFixed(1)}', textStyle: cutPriceTextStyle(isDetail: true),
            ),
          ),
          Spacer(),
          /// DISCOUNT
          if(data.productCutPrice != null)
            Container(
              width: 50.0,
              height: 50.0,
              //padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.materialButtonSkin(isDark),
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: Center(
                child: appText(
                  text: '-${calculateDiscount(data.productCutPrice!, data.productSellingPrice!)}%',
                  textStyle: sellingPriceTextStyle().copyWith(
                    color: AppColors.percentageTextSkin(isDark),
                  ),
                ),
              ),
            ),
        ],
      ),

      /// WEIGHT AND SIZE
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: appText(text: '${data.productWeightGrams} gm', textStyle: textFormHintTextStyle()),
            ),
            appText(text: '${data.productSize}', textStyle: itemTextStyle())
          ],
        ),
      ),

      /// FEATURED / SALE / AVAILABILITY
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [

            if(data.productBrand!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                      color: EnvColors.specialFestiveColorDark,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4.0),
                          bottomRight: Radius.circular(0.0))
                  ),
                  child: appText(text: data.productBrand,
                      textStyle: itemTextStyle().copyWith(
                          color: whiteColor)),
                ),
              ),

            if(data.productIsFeatured == true)
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
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
            ),

            if(data.productIsFlashsale == true)
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                      color: EnvColors.specialFestiveColorDark,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4.0),
                          bottomRight: Radius.circular(0.0))
                  ),
                  child: appText(text: AppLanguage.flashSaleStr(appLanguage),
                      textStyle: itemTextStyle().copyWith(
                          color: whiteColor)),
                ),
              ),
            if(data.productAvailability == false)
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                    color: EnvColors.secondaryTextColorLight ,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4.0),
                        bottomRight: Radius.circular(0.0))
                ),
                child: appText(text: AppLanguage.outOfStockStr(appLanguage),
                    textStyle: itemTextStyle().copyWith(
                        color:  whiteColor)),
              ),
          ],
        ),
      ),

      /// QUANTITY ADD DELETE
      appDivider(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: ()=> product.onTapMinus(),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: appIcon(iconType: IconType.PNG, icon: icMinus, width: 18.0, color: AppColors.sellingPriceDetailTextSkin(isDark)),
            ),
          ),

          SizedBox(
            width: 30.0,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Center(
                child: appText(text: product.quantity.string, textStyle: headingTextStyle().copyWith(
                  fontSize: 28.0,
                  fontFamily: oswaldRegular
                )),
              ),
            ),
          ),

          GestureDetector(
            onTap: ()=> product.onTapPlus(),
            child: Container(
                padding: EdgeInsets.all(20.0),
                child: appIcon(iconType: IconType.PNG, icon: icPlus, width: 18.0, color: AppColors.sellingPriceDetailTextSkin(isDark))),
          ),
          setWidth(MAIN_HORIZONTAL_PADDING),
        ],
      ),
      appDivider(),

      /// DESCRIPTION PART

      if(data.productDetailEng!.isNotEmpty)
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appText(text: 'Description', textStyle: headingTextStyle()),
          setHeight(MAIN_HORIZONTAL_PADDING),
          ReadMoreText(
          appLanguage == URDU_LANGUAGE ? data.productDetailUrdu.toString() : data.productDetailEng.toString(),
            trimLines: 2,
            colorClickableText: Colors.blue,
            trimMode: TrimMode.Line,
            trimCollapsedText: ' See more',
            trimExpandedText: ' See less',
            style: secondaryTextStyle(),
            textDirection: setTextDirection(appLanguage),
            textAlign: setTextAlignment(appLanguage),
            moreStyle: appTextButtonStyle().copyWith(color: AppColors.materialButtonSkin(isDark)),
            lessStyle: appTextButtonStyle().copyWith(color: AppColors.materialButtonSkin(isDark)),
          ),
       

        ],
      )


    ],
  );
}

/// PRODUCT BOTTOM PART UI CART AND TOTAL AMOUNT

Widget cartSectionUI({required ProductsModel data}){
  var product = Get.find<ProductDetailController>();
  return Container(
    color: AppColors.backgroundColorSkin(isDark),
    width: size.width,
    height: 80.0,
    child: Padding(
      padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ///TOTAL AMOUNT
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appText(text: 'Rs. ${calculateTotalAmount(productPrice: data.productSellingPrice!, quantity: product.quantity.value).toStringAsFixed(1)}/-',
              textStyle: sellingPriceDetailTextStyle()
              ),
              setHeight(4.0),
              appText(text: 'Total Amount', textStyle: itemTextStyle()),

            ],
          ),

          ///ADD TO CART
          appMaterialButton(text: 'Add To Cart', onTap: (){})
        ],
      ),
    ),
  );
}
