import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/ui/screens/pages/account/address_book/widgets/default_address_section.dart';

import '../../../../app_common/components/delivery_slots_widget.dart';

class CheckoutScreenMobile extends StatelessWidget {
  const CheckoutScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final checkout = Get.find<CheckoutController>();

    return Obx(() {
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appBarCommon(title: 'Checkout', isBackNavigation: true),

            /// TOP CHECKOUT DETAIL STATUS
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MAIN_HORIZONTAL_PADDING,
                vertical: MAIN_VERTICAL_PADDING,
              ),
              child: Row(
                children: [
                  checkoutDetailStatus(
                    title: 'Shipping',
                    isDone:  checkout.shippingValue && checkout.shippingSlotCheck,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: appDivider(),
                    ),
                  ),
                  checkoutDetailStatus(
                    title: 'Payment',
                    isDone: checkout.paymentValue,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: appDivider(),
                    ),
                  ),
                  checkoutDetailStatus(
                    title: 'Review',
                    isDone: checkout.review.value,
                  ),
                ],
              ),
            ),
            setHeight(20.0),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                    children: [
                  defaultAddressSection(),
                      Padding(
                        padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING),
                        child: appDivider(),
                      ),
                      deliveryType(),
                      Padding(
                        padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING),
                        child: appDivider(),
                      ),
                      selectPaymentMethod(isSelected: checkout.cod.value),
                      Padding(
                        padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING),
                        child: appDivider(),
                      ),
                      reviewOrderedProducts(),
                      Padding(
                        padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING),
                        child: appDivider(),
                      ),
                      billingInfo(),
                      setHeight(MAIN_VERTICAL_PADDING),
                      Padding(
                        padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
                        child: appMaterialButton(
                          text: 'Place Order',
                          isDisable: checkout.shippingValue && checkout.paymentValue ? false : true,
                          onTap: (){

                            if(checkout.shippingAddress.value == null){
                              showSnackbar(title: 'Address not found', message: 'Add Address to place order', isError: true);
                              return;
                            }

                            if(!checkout.slotDelivery.value && !checkout.flashDelivery.value){
                              showSnackbar(title: 'Delivery Type', message: 'Select Delivery Type', isError: true);
                              return;
                            }
                            if(!checkout.cod.value){
                              showSnackbar(title: 'Payment Method', message: 'Select Payment Method', isError: true);
                              return;
                            }

                            if(checkout.slotDelivery.value){
                              if(checkout.selectedSlotId.value == 0){
                                showSnackbar(title: 'Select Slot', message: 'Slot is not Selected', isError: true);
                                return;
                              }
                            }





                          }
                        ),
                      ),
                      setHeight(MAIN_VERTICAL_PADDING),


                    ]),
              ),
            ),
            // checkout.getDeliverySlotsStatus.value == Status.LOADING
            //   ? loadingIndicator()
            //     : Expanded(child: DeliverySlotsWidget()),
          ],
        ),
      );
    });
  }
}

/// TOP CHECKOUT DETAIL STATUS
Widget checkoutDetailStatus({title, isDone = false}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      appText(
        text: title,
        textStyle: itemTextStyle().copyWith(fontSize: NORMAL_TEXT_FONT_SIZE),
      ),
      setWidth(6.0),
      appIcon(
        iconType: IconType.ICON,
        icon: isDone ? Icons.verified_rounded : Icons.verified_outlined,
        color: isDone
            ? AppColors.materialButtonSkin(isDark)
            : AppColors.secondaryTextColorSkin(isDark),
        width: 16.0,
      ),
    ],
  );
}

/// SHIPPING ADDRESS SECTION
Widget defaultAddressSection() {
  var nav = Get.find<NavigationController>();
  var checkout = Get.find<CheckoutController>();
  var auth = Get.find<AuthController>();
  return Column(
    children: [
      setHeight(MAIN_HORIZONTAL_PADDING),
      HomeHeadings(
        mainHeadingText: 'Shipping Address',
        isSeeAll: true,
        isTrailingText: true,
        trailingText: 'Address book',
        onTapSeeAllText: ()=> nav.gotoAddressBookScreen(addressScreenType: AddressScreenType.CHECKOUT),
      ),
      GestureDetector(
        onTap: () => nav.gotoAddressBookScreen(addressScreenType: AddressScreenType.CHECKOUT),
        child: Obx(() {
          var defaultAddress = auth.currentUser.value?.userDefaultAddress;
          // if(defaultAddress != null){
          //   checkout.shippingAddress.value = defaultAddress;
          // }
          return Column(
            children: [
              checkout.shippingAddress.value != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        setHeight(MAIN_VERTICAL_PADDING),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: MAIN_HORIZONTAL_PADDING,
                          ),
                          child: AddressItemUI(
                            data: checkout.shippingAddress.value!,
                            isDefault: checkout.shippingAddress.value!.addressId == defaultAddress!.addressId ? true : false,
                            addressScreenType: AddressScreenType.IDLE,
                          ),
                        ),
                        //appDivider(),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: MAIN_HORIZONTAL_PADDING,
                        vertical: MAIN_VERTICAL_PADDING,
                      ),
                      child: Container(
                        width: size.width,
                        padding: const EdgeInsets.all(MAIN_VERTICAL_PADDING),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: MAIN_HORIZONTAL_PADDING,
                              ),
                              child: appIcon(
                                iconType: IconType.ICON,
                                icon: Icons.location_city_rounded,
                                width: 34.0,
                                color: AppColors.materialButtonSkin(isDark),
                              ),
                            ),
                            appText(
                              text: AppLanguage.defaultAddressNotFoundStr(
                                appLanguage,
                              ),
                              textDirection: setTextDirection(appLanguage),
                              textAlign: TextAlign.center,
                              textStyle: secondaryTextStyle(),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          );
        }),
      ),
    ],
  );
}

/// SELECT PAYMENT METHOD
Widget selectPaymentMethod({isSelected = false}){
  var checkout = Get.find<CheckoutController>();
  return Obx(
    ()=> Column(
      children: [
        setHeight(MAIN_VERTICAL_PADDING),
        HomeHeadings(
          mainHeadingText: 'Payment Method',
          isSeeAll: false,
          isTrailingText: false,
        ),

        setHeight(MAIN_HORIZONTAL_PADDING),

        listItemIcon(iconType: IconType.ICON ,leadingIcon: Icons.payment,
        trailingIcon: isSelected ? icRadioButtonSelected : icRadioButton,
        itemTitle: 'Cash On Delivery', onItemClick: (){
          checkout.cod.value = true;
    })
      ],
    ),
  );
}

/// DELIVERY TYPE
Widget deliveryType(){
  var checkout = Get.find<CheckoutController>();
  return Column(
    children: [
      setHeight(MAIN_VERTICAL_PADDING),
      HomeHeadings(
        mainHeadingText: 'Select Delivery',
        isSeeAll: false,
        isTrailingText: false,
      ),
      setHeight(MAIN_HORIZONTAL_PADDING),
      Row(
        children: [
          Expanded(
            child: listItemIcon(iconType: IconType.PNG ,leadingIcon: icFlashSale,
                trailingIcon: checkout.flashDelivery.value ? icRadioButtonSelected : icRadioButton,
                itemTitle: 'Flash', onItemClick: (){
                  checkout.flashDelivery.value = true;
                  checkout.slotDelivery.value = false;
                }),
          ),
          setWidth(8.0),
          Expanded(
            child: listItemIcon(iconType: IconType.ICON ,leadingIcon: Icons.calendar_month_rounded,
                trailingIcon: checkout.slotDelivery.value ? icRadioButtonSelected : icRadioButton,
                itemTitle: 'Slot', onItemClick: (){
                  checkout.slotDelivery.value = true;
                  checkout.flashDelivery.value = false;
                }),
          )
        ],
      ),
       setHeight(MAIN_HORIZONTAL_PADDING),
      checkout.slotDelivery.value == true ?
      checkout.getDeliverySlotsStatus.value == Status.LOADING
        ? loadingIndicator()
          : DeliverySlotsWidget()
      : SizedBox.shrink()
      ,
    ],
  );
}

/// REVIEW PRODUCTS
Widget reviewOrderedProducts(){
  var cart = Get.find<CartController>();
  return Obx((){
    var products = cart.cartProducts;
    return Column(
      children: [
        setHeight(MAIN_VERTICAL_PADDING),
        HomeHeadings(
          mainHeadingText: 'Ordered Products',
          isSeeAll: false,
          isTrailingText: false,
        ),
        setHeight(MAIN_VERTICAL_PADDING),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
          child: Column(
            children: List.generate(products.length, (index){
              var product = products[index];
              return Column(
                children: [
                  Row(
                    children: [
                      appText(text: (index +1).toString(), textStyle: itemTextStyle()),
                      setWidth(8.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Container(
                          color: whiteColor,
                          width: size.width * 0.12,
                          height: size.width * 0.12,
                          child: appAsyncImage(
                            product.productImage,
                            boxFit: BoxFit.cover,
                          ),
                        ),
                      ),
                      setWidth(8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            appText(
                              text: appLanguage == URDU ? product.productNameUrdu : product.productNameEng,
                              textStyle: itemTextStyle().copyWith(fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE),
                              textDirection: setTextDirection(appLanguage),
                              maxLines: 1,
                            ),
                            Row(
                              children: [
                                if(product.productWeightGrams != null)
                                  appText(
                                    text: '${product.productWeightGrams} gm',
                                    textStyle: textFormHintTextStyle().copyWith(fontSize: TAGS_FONT_SIZE),
                                    maxLines: 1,
                                  ),
                                if(product.productSize != null)
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
                                  textStyle: sellingPriceTextStyle().copyWith(fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE),
                                  maxLines: 1,
                                ),
                                setWidth(8.0),
                                if(product.productCutPrice != null)

                                  appText(
                                    text: 'Rs. ${product.productCutPrice}',
                                    maxLines: 1,
                                    textStyle: cutPriceTextStyle(isDetail: false).copyWith(fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE),
                                  ),

                              ],
                            ),
                          ],
                        ),
                      ),
                      setWidth(MAIN_HORIZONTAL_PADDING),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [

                          appText(text: '${product.productQuantity} x ${product.productSellingPrice!.toStringAsFixed(0)} = Rs. ${(product.productQuantity!.toInt() * product.productSellingPrice!.toDouble()).toStringAsFixed(0)}',
                              textStyle: secondaryTextStyle().copyWith(color: AppColors.sellingPriceDetailTextSkin(isDark), fontSize: TAGS_FONT_SIZE)
                          )
                        ],
                      )
                    ],
                  ),
                  if(index < products.length-1)
                  setHeight(MAIN_HORIZONTAL_PADDING),
                ],
              );
            }),
          ),
        )


      ],
    );
  });
}

/// BILLING SECTION
Widget billingInfo(){
  var cart = Get.find<CartController>();
  var checkout = Get.find<CheckoutController>();
  return Obx((){
    return Column(
      children: [
        setHeight(MAIN_VERTICAL_PADDING),
        HomeHeadings(
          mainHeadingText: 'Billing Information',
          isSeeAll: false,
          isTrailingText: false,
        ),
        setHeight(MAIN_HORIZONTAL_PADDING),

        Container(
          padding: EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
          decoration: BoxDecoration(
            color: AppColors.cardColorSkin(isDark),
          ),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  billingInfoItems(
                    title: 'Shipping : ' ,
                    detail: checkout.shippingMethod.value.toString(),
                    detailTextStyle: itemTextStyle()
                  ),
                  billingInfoItems(
                      title: 'Delivery type : ' ,
                      detail: checkout.deliveryType,
                      detailTextStyle: itemTextStyle()
                  ),
                  billingInfoItems(
                      title: 'Total Products : ' ,
                      detail: cart.cartProducts.length.toString(),
                      detailTextStyle: itemTextStyle()
                  ),
                  billingInfoItems(
                      title: 'Products Quantity : ' ,
                      detail: cart.totalProductsQuantity.value.toString(),
                      detailTextStyle: itemTextStyle()
                  ),

                ],
              ),
              appDivider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING, vertical: 8.0),
                child: Row(
                  children: [
                    appText(text: 'Total Amount : ' , textStyle: bodyTextStyle()),
                    setWidth(8.0),
                    appText(text: 'Rs. ${cart.totalSellingPrice.value.toStringAsFixed(1)} ' , textStyle: itemTextStyle().copyWith(color: AppColors.sellingPriceDetailTextSkin(isDark))),
                    setWidth(4.0),
                    appText(text: 'Rs. ${cart.totalCutPrice.value.toStringAsFixed(1)} ' , textStyle: cutPriceTextStyle().copyWith(color: AppColors.cutPriceDetailTextColorSkin(isDark))),
                  ],
                ),
              ),

              billingInfoItems(
                  title: 'Discount : ' ,
                  detail: 'Rs. ${(cart.totalCutPrice.value - cart.totalSellingPrice.value).toStringAsFixed(1)}',
                  detailTextStyle: itemTextStyle().copyWith(color: AppColors.materialButtonSkin(isDark))
              ),
              billingInfoItems(
                  title: 'Delivery Charges : ' ,
                  detail: 'Rs. ${checkout.deliveryChargesValue.toStringAsFixed(1)}',
                  detailTextStyle:itemTextStyle()
              ),
              billingInfoItems(
                  title: 'GST : ' ,
                  detail: 'Rs. ${checkout.tax.value.toStringAsFixed(1)}',
                  detailTextStyle:itemTextStyle()
              ),

          //    appDivider(),
              setHeight(MAIN_HORIZONTAL_PADDING),
              Container(
                padding: EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
                color: AppColors.backgroundColorSkin(isDark),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    appText(text: 'Total Payable Amount : ' , textStyle: headingTextStyle()),
                    setWidth(8.0),
                    appText(text: 'Rs. ${checkout.totalPayableAmount.toStringAsFixed(1)}' , textStyle: sellingPriceTextStyle().copyWith(fontSize: HEADING_FONT_SIZE, color: AppColors.sellingPriceDetailTextSkin(isDark))),
                  ],
                ),
              ),
              setHeight(MAIN_HORIZONTAL_PADDING),

            ],
          ),
        )
        




      ],
    );
  });
}

Widget billingInfoItems({title, detail, detailTextStyle}){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING, vertical: 8.0),
    child: Row(
      children: [
        appText(text: title , textStyle: bodyTextStyle()),
        setWidth(8.0),
        appText(text: detail , textStyle: detailTextStyle),
      ],
    ),
  );
}