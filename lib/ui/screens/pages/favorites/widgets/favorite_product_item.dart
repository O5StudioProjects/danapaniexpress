import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class FavoriteProductItem extends StatelessWidget {
  final ProductModel product;
  const FavoriteProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final favorites = Get.find<FavoritesController>();
    final cart = Get.find<CartController>();
    final nav = Get.find<NavigationController>();
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final imageSize = constraints.maxWidth * 0.15;

          return Obx((){
            final isLoading = cart.addCartStatus[product.productId] == Status.LOADING;
            return GestureDetector(
              onTap: ()=> nav.gotoProductDetailScreen(data: product),
              child: Container(
                //  height: imageSize * 1.4, // fixes container height based on image size + padding
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: AppColors.cardColorSkin(isDark),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(30),
                      blurRadius: 1,
                      spreadRadius: 0,
                      offset: const Offset(1, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Container(
                            color: whiteColor,
                            width: imageSize,
                            height: imageSize,
                            child: appAsyncImage(
                              product.productImage,
                              boxFit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: MAIN_HORIZONTAL_PADDING),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              appText(
                                text: appLanguage == URDU_LANGUAGE ? product.productNameUrdu : product.productNameEng,
                                textStyle: itemTextStyle().copyWith(fontSize: NORMAL_TEXT_FONT_SIZE),
                                textDirection: setTextDirection(appLanguage),
                                maxLines: 1,
                              ),
                              Row(
                                children: [
                                  appText(
                                    text: '${product.productWeightGrams} gm',
                                    textStyle: textFormHintTextStyle().copyWith(fontSize: TAGS_FONT_SIZE),
                                    maxLines: 1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6.0),
                                    child: appText(
                                      text: product.productSize,
                                      textStyle: itemTextStyle().copyWith(fontSize: TAGS_FONT_SIZE),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  appText(
                                    text: 'Rs. ${product.productSellingPrice}',
                                    textStyle: sellingPriceTextStyle(),
                                    maxLines: 1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6.0),
                                    child: appText(
                                      text: 'Rs. ${product.productCutPrice}',
                                      maxLines: 1,
                                      textStyle: cutPriceTextStyle(isDetail: false),
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                        setHeight(8.0),
                        Obx((){
                          final isLoading = favorites.favoriteLoadingStatus[product.productId] == Status.LOADING;
                          return GestureDetector(
                            onTap: (){
                              favorites.toggleFavorite(product.productId!);
                            },
                            child: isLoading
                                ? SizedBox(
                              width: 24.0,
                              height: 24.0,
                              child: loadingIndicator(),
                            )
                                :appIcon(
                              iconType: IconType.PNG,
                              icon: icHeartFill,
                              width: 24.0,
                              color: AppColors.materialButtonSkin(isDark),
                            ),
                          );
                        })
                      ],
                    ),
                    setHeight(8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        isLoading ? SizedBox(
                          height: 35.0,
                          width: 100.0,
                          child: loadingIndicator(),
                        ) : SizedBox(
                          height: 35.0,
                          child: appMaterialButton(
                              text: product.productAvailability == false ? AppLanguage.outOfStockStr(appLanguage) :AppLanguage.addToCartStr(appLanguage),
                              fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
                              isDisable: product.productAvailability == false,
                              onTap: () async {
                                if(product.productAvailability == true){
                                  await cart.addToCart(product.productId!);
                                } else {
                                  showToast(AppLanguage.outOfStockStr(appLanguage).toString());
                                }
                              }
                          ),
                        ),
                        Spacer(),
                        if (product.productBrand!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: EnvColors.specialFestiveColorDark,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  bottomRight: Radius.circular(0.0),
                                ),
                              ),
                              child: appText(
                                text: product.productBrand,
                                textStyle: itemTextStyle().copyWith(color: whiteColor),
                              ),
                            ),
                          ),

                        if (product.productIsFlashsale == true)
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: EnvColors.primaryColorLight,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  bottomRight: Radius.circular(0.0),
                                ),
                              ),
                              child: appText(
                                text: AppLanguage.flashSaleStr(appLanguage),
                                textStyle: itemTextStyle().copyWith(color: whiteColor),
                              ),
                            ),
                          ),

                        // appFloatingButton(
                        //   icon: icCart,
                        //   iconType: IconType.PNG,
                        //   iconWidth: 14.0,
                        //   circlePadding: 8.0,
                        //   onTap: () {},
                        // ),


                        //  const SizedBox(height: 12),

                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
