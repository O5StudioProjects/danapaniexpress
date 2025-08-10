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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// 🔹 Image
            Padding(
              padding: const EdgeInsets.only(top: 8.0,bottom: 8.0, left: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Stack(
                  children: [
                    Container(
                      width: size.width * 0.24,
                      height: size.height * 0.16,
                      color: whiteColor,
                      child: ClipRRect(
                        child: appAsyncImage(
                          data.productImage,
                          boxFit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    data.productAvailability == false
                        ? Positioned(
                      bottom: 0,
                      child: Container(
                        width: size.width * 0.24,
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 4.0),
                        decoration: BoxDecoration(
                            color: EnvColors.secondaryTextColorLight.withValues(alpha: 0.7),
                        ),
                        child: Center(
                          child: appText(text: AppLanguage.outOfStockStr(appLanguage),
                              textAlign: TextAlign.center,
                              textStyle: itemTextStyle().copyWith(
                                  color: whiteColor)),
                        ),
                      ),
                    )
                        : SizedBox()
                  ],
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                    /// FEATURED / SALE / AVAILABILITY
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
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
                          if (data.productIsFeatured == true)
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  color: EnvColors.primaryColorLight,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(4.0),
                                    bottomRight: Radius.circular(0.0),
                                  ),
                                ),
                                child: appText(
                                  text: AppLanguage.featureStr(appLanguage),
                                  textStyle: itemTextStyle().copyWith(color: whiteColor),
                                ),
                              ),
                            ),
                          if (data.productIsFlashsale == true)
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
                                  text: AppLanguage.flashSaleStr(appLanguage),
                                  textStyle: itemTextStyle().copyWith(color: whiteColor),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    /// ADD TO CART BUTTON
                    Obx((){
                      final isLoading = cart.addCartStatus[data.productId] == Status.LOADING;
                      return Padding(
                        padding: const EdgeInsets.only(left: 0.0, right: 0.0, bottom: 0.0),
                        child: GestureDetector(
                          onTap: () async {
                            if(auth.currentUser.value == null){
                              nav.gotoSignInScreen();
                            }
                            else if(data.productAvailability == true){
                              await cart.addToCart(data.productId!);
                            } else {
                              showToast(AppLanguage.outOfStockStr(appLanguage).toString());
                            }

                          },
                          child: isLoading ? SizedBox(
                            //  height: nameHeight,
                            child: loadingIndicator(),
                          ) : Container(
                               height: 30.0,
                            width: size.width,
                            decoration: BoxDecoration(
                                color: data.productAvailability == false ? AppColors.disableMaterialButtonSkin(isDark) : AppColors.materialButtonSkin(isDark),
                                borderRadius: BorderRadius.circular(8.0)
                            ),
                            child: Center(
                                child: appText(
                                    text: AppLanguage.addToCartStr(appLanguage),
                                    textStyle: buttonTextStyle(color: data.productAvailability == false ? AppColors.materialButtonTextSkin(isDark).withValues(alpha: 0.5) : AppColors.materialButtonTextSkin(isDark)))),
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}