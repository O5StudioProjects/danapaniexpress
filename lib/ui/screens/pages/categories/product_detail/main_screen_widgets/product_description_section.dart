import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/core/packages_import.dart';

class ProductDescriptionSection extends StatelessWidget {
  const ProductDescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    var productDetail = Get.find<ProductDetailController>();
    var products = Get.find<ProductsController>();
    var cart = Get.find<CartController>();
    return Obx((){
      final data = productDetail.productData.value!;
      return Column(
        crossAxisAlignment: isRightLang
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          _productName(data),
          _productPrice(data),
          _productWeightAndSize(data),
          _productTags(data),
          _productQuantity(data, cart, productDetail),
          if (data.productDetailEng != null && data.productNameUrdu != null)
            _productDescriptionAndRow(data, products)
        ],
      );
    });
  }
  /// PRODUCT NAME
  Widget _productName(ProductModel data){
    return appText(
      text: isRightLang
          ? data.productNameUrdu
          : data.productNameEng,
      textAlign: setTextAlignment(appLanguage),
      textDirection: setTextDirection(appLanguage),
      textStyle: bigBoldHeadingTextStyle(),
    );
  }

  /// PRODUCT PRICE
  Widget _productPrice(ProductModel data){
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          appText(
            text: 'Rs. ${data.productSellingPrice!.toStringAsFixed(1)}',
            textStyle: sellingPriceDetailTextStyle(),
          ),
          if (data.productCutPrice != null)
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: appText(
                text: 'Rs. ${data.productCutPrice?.toStringAsFixed(1)}',
                textStyle: cutPriceTextStyle(isDetail: true),
              ),
            ),
        ],
      ),
    );
  }

  /// WEIGHT AND SIZE
  Widget _productWeightAndSize(ProductModel data){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: appText(
              text: '${data.productWeightGrams} gm',
              textStyle: textFormHintTextStyle(),
            ),
          ),
          appText(text: '${data.productSize}', textStyle: itemTextStyle()),
        ],
      ),
    );
  }

  /// FEATURED / SALE / AVAILABILITY
  Widget _productTags(ProductModel data){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          if (data.productBrand!.isNotEmpty)
            ProductTags(tagText: data.productBrand.toString(), color: EnvColors.specialFestiveColorDark, isLeftPadding: false,),

          if (data.productIsFeatured == true)
            ProductTags(tagText: AppLanguage.featureStr(appLanguage).toString(), color: EnvColors.primaryColorLight, isLeftPadding: false,),


          if (data.productIsFlashsale == true)
            ProductTags(tagText: AppLanguage.flashSaleStr(appLanguage).toString(), color: EnvColors.specialFestiveColorDark, isLeftPadding: false,),

          if (data.productAvailability == false)
            ProductTags(tagText: AppLanguage.outOfStockStr(appLanguage).toString(), color: EnvColors.secondaryTextColorLight, isLeftPadding: false,),

        ],
      ),
    );
  }

  /// QUANTITY ADD DELETE
  Widget _productQuantity(ProductModel data, cart, productDetail){
    return Column(
      children: [
        appDivider(),
        Obx((){
          var isAddQuantityLoading = cart.addQuantityCartStatus[data.productId] == Status.LOADING ? true : false;
          var isRemoveQuantityLoading = cart.removeQuantityCartStatus[data.productId] == Status.LOADING ? true : false;
          return  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 26.0,
                height: 26.0,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.0),
                  child:
                  isRemoveQuantityLoading
                      ? loadingIndicator()
                      : counterButton(
                    icon: icMinus,
                    iconType: IconType.PNG,
                    isLimitExceed:
                    // productInCart != null ? productInCart.productQuantity == 1 ? true : false
                    // :
                    productDetail.quantity.value == 1 ? true : false,
                    onTap: (){

                      if(productDetail.quantity.value == 1 ){
                        showToast(AppLanguage.selectAtLeastOneProductStr(appLanguage).toString());
                      } else {
                        productDetail.onTapMinus();
                      }


                      // if(productInCart != null){
                      //   if( productInCart.productQuantity == 1){
                      //     showToast(AppLanguage.selectAtLeastOneProductStr(appLanguage).toString());
                      //   } else {
                      //     cart.removeQuantityFromCart(data.productId!);
                      //   }
                      //
                      // } else {
                      //   if(productDetail.quantity.value == 1 ){
                      //     showToast(AppLanguage.selectAtLeastOneProductStr(appLanguage).toString());
                      //   } else {
                      //     productDetail.onTapMinus();
                      //   }
                      // }

                    },
                  ),
                ),
              ),

              SizedBox(
                width: 60.0,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Center(
                    child: appText(
                      //  text: productInCart != null ? productInCart.productQuantity.toString() :  productDetail.quantity.string,
                      text:  productDetail.quantity.string,
                      textStyle: headingTextStyle().copyWith(
                        fontSize: 22.0,
                        fontFamily: oswaldRegular,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: 26.0,
                height: 26.0,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.0),
                  child: isAddQuantityLoading ? loadingIndicator()
                      : counterButton(
                      icon: icPlus,
                      iconType: IconType.PNG,
                      isLimitExceed:
                      //     productInCart != null ? productInCart.productQuantity == data.productQuantityLimit ? true : false
                      // :
                      data.productQuantityLimit == productDetail.quantity.value
                          ? true
                          : false,
                      onTap: (){

                        if(data.productQuantityLimit == productDetail.quantity.value){
                          showToast(AppLanguage.quantityLimitExceededStr(appLanguage).toString());
                        } else {
                          productDetail.onTapPlus(
                            productLimit: data.productQuantityLimit ?? productDetail.quantity.value,
                          );
                        }

                        // if(productInCart != null){
                        //   if(productInCart.productQuantity == data.productQuantityLimit){
                        //     showToast(AppLanguage.quantityLimitExceededStr(appLanguage).toString());
                        //   } else {
                        //     cart.addQuantityToCart(data.productId!);
                        //   }
                        // } else{
                        //   if(data.productQuantityLimit == productDetail.quantity.value){
                        //     showToast(AppLanguage.quantityLimitExceededStr(appLanguage).toString());
                        //   } else {
                        //     productDetail.onTapPlus(
                        //       productLimit: data.productQuantityLimit ?? productDetail.quantity.value,
                        //     );
                        //   }
                        // }

                      }
                  ),
                ),
              ),
              //  setWidth(MAIN_HORIZONTAL_PADDING),
            ],
          );
        }),
        appDivider(),
      ],
    );
  }

  /// DESCRIPTION AND FEATURED ROW
  Widget _productDescriptionAndRow(ProductModel data, products){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: size.width,
          child: appText(
              text: AppLanguage.descriptionStr(appLanguage),
              textStyle: headingTextStyle(),
              textDirection: setTextDirection(appLanguage),
              textAlign: setTextAlignment(appLanguage)
          ),
        ),
        setHeight(MAIN_HORIZONTAL_PADDING),
        SizedBox(
          width: size.width,
          child: ReadMoreText(
            productDetailMultiLangText(data),
            trimLines: 2,
            colorClickableText: Colors.blue,
            trimMode: TrimMode.Line,
            trimCollapsedText: ' ${AppLanguage.seeMoreStr(appLanguage)}',
            trimExpandedText: ' ${AppLanguage.seeLessStr(appLanguage)}',
            style: secondaryTextStyle(),
            textDirection: setTextDirection(appLanguage),
            textAlign: setTextAlignment(appLanguage),
            moreStyle: appTextButtonStyle().copyWith(
              color: AppColors.materialButtonSkin(isDark),
            ),
            lessStyle: appTextButtonStyle().copyWith(
              color: AppColors.materialButtonSkin(isDark),
            ),
          ),
        ),
        setHeight(MAIN_VERTICAL_PADDING),

        ProductsRowUi(
          products: products.featuredProducts,
          screenType: ProductsScreenType.FEATURED,
          horizontalPadding: 0.0,
          firstIndexLeftPadding: 2.0,
        ),
      ],
    );
  }

}