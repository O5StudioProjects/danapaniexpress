import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class FavoriteProductItem extends StatelessWidget {
  final ProductModel product;
  const FavoriteProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final favorites = Get.find<FavoritesController>();
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final imageSize = constraints.maxWidth * 0.2;

          return Container(
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
                            textStyle: itemTextStyle().copyWith(fontSize: HEADING_FONT_SIZE),
                            textDirection: setTextDirection(appLanguage),
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              appText(
                                text: '${product.productWeightGrams} gm',
                                textStyle: textFormHintTextStyle().copyWith(fontSize: NORMAL_TEXT_FONT_SIZE -2),
                                maxLines: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: appText(
                                  text: product.productSize,
                                  textStyle: itemTextStyle(),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6.0),
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
                    const SizedBox(width: MAIN_HORIZONTAL_PADDING),
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
                setHeight(MAIN_VERTICAL_PADDING),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 35.0,
                      child: appMaterialButton(
                          text: AppLanguage.addToCartStr(appLanguage),
                          fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE
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
          );
        },
      ),
    );
  }
}
