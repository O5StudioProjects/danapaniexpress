import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import '../../../../../core/data_model_imports.dart';

class SearchProductItem extends StatelessWidget {
  final ProductModel data;
  const SearchProductItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {

    var cart  = Get.find<CartController>();
    var auth  = Get.find<AuthController>();
    var nav  = Get.find<NavigationController>();

    return Obx(
      ()=> Container(
        width: size.width,
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
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 Image
                Padding(
                  padding: const EdgeInsets.only(top: 8.0,bottom: 0.0, left: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Stack(
                      children: [
                        Container(
                          width: size.width * 0.16,
                          height: size.width * 0.16,
                          color: whiteColor,
                          child: ClipRRect(
                            child: appAsyncImage(
                              data.productImage,
                              boxFit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        // data.productBrand!.isNotEmpty
                        //     ? Positioned(
                        //   bottom: 0,
                        //   child: Container(
                        //     width: size.width * 0.15,
                        //     padding: EdgeInsets.symmetric(
                        //         horizontal: 0.0, vertical: 4.0),
                        //     decoration: BoxDecoration(
                        //       color: AppColors.materialButtonSkin(isDark).withValues(alpha: 0.6),
                        //     ),
                        //     child: Center(
                        //       child: appText(text: data.productBrand!,
                        //           maxLines: 1,
                        //           overFlow: TextOverflow.ellipsis,
                        //           textAlign: TextAlign.center,
                        //           textStyle: itemTextStyle().copyWith(
                        //               color: whiteColor)),
                        //     ),
                        //   ),
                        // )
                        //     : SizedBox()
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                    child: Column(
                      children: [

                        Align(
                          alignment: isRightLang
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: appText(
                            text: isRightLang
                                ? data.productNameUrdu
                                : data.productNameEng,
                            maxLines: 1,
                            overFlow: TextOverflow.ellipsis,
                            textAlign: setTextAlignment(appLanguage),
                            textStyle: itemTextStyle(),
                          ),
                        ),

                        /// WEIGHT AND SIZE
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 2.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: appText(
                                  text: '${data.productWeightGrams} gm',
                                  textStyle: textFormHintTextStyle().copyWith(fontSize: TAGS_FONT_SIZE),
                                ),
                              ),
                              appText(text: '${data.productSize}', textStyle: itemTextStyle().copyWith(fontSize: TAGS_FONT_SIZE)),
                            ],
                          ),
                        ),
                        /// PRODUCT PRICE
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    appText(
                                      text: 'Rs. ${data.productSellingPrice!.toStringAsFixed(1)}',
                                      textStyle: sellingPriceTextStyle(),
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
                              ),
                            ),
                            if(data.productCutPrice != null)
                              appText(
                                text: '-${calculateDiscount(data.productCutPrice!, data.productSellingPrice!)}%',
                                textStyle: sellingPriceTextStyle().copyWith(
                                  color: AppColors.percentageTextSkin(isDark),
                                ),
                              ),
                          ],
                        ),


                      ],
                    ),
                  ),
                )
              ],
            ),
            setHeight(8.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// FEATURED / SALE / AVAILABILITY
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                    child: Row(
                      children: [
                        if (data.productBrand!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: EnvColors.specialFestiveColorDark,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(4.0),
                                  bottomRight: Radius.circular(0.0),
                                ),
                              ),
                              child: appText(
                                text: data.productBrand,
                                textStyle: itemTextStyle().copyWith(color: whiteColor),
                              ),
                            ),
                          ),
                        // if (data.productIsFeatured == true)
                        //   Padding(
                        //     padding: const EdgeInsets.only(right: 5.0),
                        //     child: Container(
                        //       padding: EdgeInsets.symmetric(
                        //         horizontal: 8.0,
                        //         vertical: 4.0,
                        //       ),
                        //       decoration: BoxDecoration(
                        //         color: EnvColors.primaryColorLight,
                        //         borderRadius: BorderRadius.only(
                        //           topRight: Radius.circular(4.0),
                        //           bottomRight: Radius.circular(0.0),
                        //         ),
                        //       ),
                        //       child: appText(
                        //         text: AppLanguage.featureStr(appLanguage),
                        //         textStyle: itemTextStyle().copyWith(color: whiteColor),
                        //       ),
                        //     ),
                        //   ),
                        if (data.productIsFlashsale == true)
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: EnvColors.primaryColorDark,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(4.0),
                                  bottomRight: Radius.circular(0.0),
                                ),
                              ),
                              child: appText(
                                text: AppLanguage.flashSaleStr(appLanguage),
                                textStyle: itemTextStyle().copyWith(color: whiteColor),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                /// ADD TO CART BUTTON
                Obx((){
                  final isLoading = cart.addCartStatus[data.productId] == Status.LOADING;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                    child: isLoading ? SizedBox(
                      height: 35.0,
                      width: 100,
                      child: Align(
                          alignment: Alignment.center,
                          child: loadingIndicator()),
                    )  :
                    Align(
                      alignment: Alignment.centerLeft,
                      child: appMaterialButton(
                          text: data.productAvailability == false ? AppLanguage.outOfStockStr(appLanguage) : AppLanguage.addToCartStr(appLanguage),
                          isFullWidth: false,
                          isDisable: data.productAvailability == false,
                          buttonHeight: 35.0,
                          fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
                          onTap: () async {
                            if(auth.currentUser.value == null){
                              nav.gotoSignInScreen();
                            }
                            else if(data.productAvailability == false){
                              showToast(AppLanguage.outOfStockStr(appLanguage).toString());
                            } else {
                              await cart.addToCart(data.productId!);
                            }
                          }

                      ),
                    ),
                  );
                })
              ],
            )

          ],
        ),
      ),
    );
  }
}