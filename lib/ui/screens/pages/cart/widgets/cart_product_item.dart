import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/ui/app_common/dialogs/bool_dialog.dart';

class CartProductItem extends StatelessWidget {
  final ProductModel product;
  const CartProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final nav = Get.find<NavigationController>();
    return Obx((){
      var isLoading = cart.deleteCartItemStatus[product.productId] == Status.LOADING ? true : false;
      var isAddQuantityLoading = cart.addQuantityCartStatus[product.productId] == Status.LOADING ? true : false;
      var isRemoveQuantityLoading = cart.removeQuantityCartStatus[product.productId] == Status.LOADING ? true : false;
      return GestureDetector(
        onTap: ()=> nav.gotoProductDetailScreen(data: product),
        child: Padding(
          padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final imageSize = constraints.maxWidth * 0.16;
        
              return Container(
                width: size.width,
                //  height: imageSize * 3, // fixes container height based on image size + padding
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
                        setWidth(MAIN_HORIZONTAL_PADDING),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: appText(
                                      text: appLanguage == URDU ? product.productNameUrdu : product.productNameEng,
                                      textStyle: itemTextStyle().copyWith(fontSize: NORMAL_TEXT_FONT_SIZE),
                                      textDirection: TextDirection.ltr,
                                      maxLines: 1,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      showCustomDialog(context, AppBoolDialog(
                                          title: AppLanguage.removeProductStr(appLanguage).toString(),
                                          detail: AppLanguage.removeProductConfirmStr(appLanguage).toString(),
                                          iconType: IconType.SVG,
                                        onTapConfirm: () async {
                                            Navigator.of(context).pop();
                                            await cart.deleteCartItem(product.productId!);
                                        },
                                        icon: icDelete,
                                      ));
                                    },
                                    child: isLoading ? SizedBox(
                                      width: 24.0,
                                      child: loadingIndicator(),
                                    ) : appIcon(
                                        icon: icDelete,
                                        iconType: IconType.PNG,
                                        width: 24.0,
                                        color: AppColors.materialButtonSkin(isDark)
                                    ),
                                  ),
        
                                ],
                              ),
        
                               const SizedBox(height: 8.0),
        
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          if(product.productWeightGrams != null)
                                            appText(
                                              text: '${product.productWeightGrams} gm',
                                              textStyle: textFormHintTextStyle().copyWith(fontSize: NORMAL_TEXT_FONT_SIZE -2),
                                              maxLines: 1,
                                            ),
                                          if(product.productSize != null)
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
                                      setHeight(2.0),
                                      if(product.productCutPrice != null)
                                        appText(
                                          text: 'Rs. ${product.productCutPrice}',
                                          maxLines: 1,
                                          textStyle: cutPriceTextStyle(isDetail: false),
                                        ),
                                      if(product.productSellingPrice != null)
                                        appText(
                                          text: 'Rs. ${product.productSellingPrice}',
                                          textStyle: sellingPriceTextStyle(),
                                          maxLines: 1,
                                        ),
        
                                    ],
                                  ),
                                  //Spacer(),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [

                                            SizedBox(
                                              width: 24.0,
                                              height: 24.0,
                                              child: isRemoveQuantityLoading
                                                  ? loadingIndicator()
                                                  : counterButton(icon: icMinus, iconType: IconType.PNG,
                                                  isLimitExceed: product.productQuantity! == 1 ? true : false,
                                                  onTap: () async{
                                                    if(product.productQuantity! == 1 ){
                                                      showToast(AppLanguage.selectAtLeastOneProductStr(appLanguage).toString());
                                                    } else {
                                                      await cart.removeQuantityFromCart(product.productId!);
                                                    }
                                                  }),
                                            ),


                                            SizedBox(
                                              width: 50.0,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                                child: Center(child: appText(text: '${product.productQuantity}', textStyle: bodyTextStyle(). copyWith(fontSize: 24.0))),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 24.0,
                                              height: 24.0,
                                              child: isAddQuantityLoading
                                                  ? loadingIndicator()
                                                  : counterButton(icon: icPlus, iconType: IconType.PNG,
                                                  isLimitExceed: product.productQuantityLimit == product.productQuantity ? true : false,
                                                  onTap: () async{
                                                    if(product.productQuantityLimit == product.productQuantity){
                                                      showToast(AppLanguage.quantityLimitExceededStr(appLanguage).toString());
                                                    } else {
                                                      await cart.addQuantityToCart(product.productId!);
                                                    }

                                                  }),
                                            )

        
                                          ],
                                        ),
                                        setHeight(6.0),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
                                            decoration: BoxDecoration(
                                             // color: AppColors.materialButtonSkin(isDark),
                                              borderRadius: BorderRadius.circular(4.0)
                                            ),
                                            child: appText(text: '${product.productQuantity} x ${product.productSellingPrice!.toStringAsFixed(0)} = Rs. ${(product.productQuantity!.toInt() * product.productSellingPrice!.toDouble()).toStringAsFixed(0)}',
                                            textStyle: secondaryTextStyle().copyWith(color: AppColors.sellingPriceDetailTextSkin(isDark))
                                            )),
        
                                      ],
                                    ),
                                  )
        
                                ],
                              )
        
        
        
        
                            ],
                          ),
                        ),
                        // setWidth(MAIN_HORIZONTAL_PADDING),
        
        
                      ],
                    ),
                    //  Spacer(),
                    //   setHeight(MAIN_HORIZONTAL_PADDING),
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //
                    //     children: [
                    //       appIcon(
                    //           icon: icDeleteCart,
                    //           iconType: IconType.PNG,
                    //           width: 24.0,
                    //           color: EnvColors.specialFestiveColorDark
                    //       ),
                    //      Spacer(),
                    //       counterButton(icon: icMinus, iconType: IconType.PNG, onTap: (){}),
                    //       Padding(
                    //         padding: EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
                    //         child: appText(text: '1', textStyle: bodyTextStyle(). copyWith(fontSize: 24.0)),
                    //       ),
                    //       counterButton(icon: icPlus, iconType: IconType.PNG, onTap: (){}),
                    //
                    //     ],
                    //   )
        
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
