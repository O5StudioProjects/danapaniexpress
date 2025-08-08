import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/domain/controllers/orders_controller/orders_controller.dart';

class OrderDetailScreenMobile extends StatelessWidget {
  const OrderDetailScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var orders = Get.find<OrdersController>();
    var data = Get.arguments[DATA_ORDER] as OrderModel;
    orders.fetchOrderByNumber(data.orderNumber!);
    return Obx(() {
      var orderData = orders.selectedOrder.value;
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appBarCommon(title: 'Order Detail', isBackNavigation: true),
            orderData == null || orders.getOrderByNumberStatus.value == Status.LOADING
            ? Expanded(child: loadingIndicator())
            : Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: MAIN_HORIZONTAL_PADDING,
                    vertical: MAIN_HORIZONTAL_PADDING,
                  ),
                  child: Column(
                    children: [
                      orderDetailItemsUI(
                        titleText: AppLanguage.orderNumberHashStr(appLanguage),
                        titleTextStyle: headingTextStyle().copyWith(
                          fontSize: HEADING_FONT_SIZE,
                        ),
                        detailText:
                            orderData.orderNumber?.split('_').last ?? '',
                        detailTextStyle: headingTextStyle(),
                      ),
                      setHeight(MAIN_VERTICAL_PADDING),
                      orderStatusSection(orderData),
                      setHeight(MAIN_VERTICAL_PADDING),
                      deliveryTypeSection(orderData),
                      setHeight(MAIN_VERTICAL_PADDING),
                      productsSection(orderData),
                      setHeight(MAIN_VERTICAL_PADDING),
                      paymentSection(orderData),
                      setHeight(MAIN_VERTICAL_PADDING),
                      addressSection(orderData),
                      if(orderData.rider != null)
                        setHeight(MAIN_VERTICAL_PADDING),
                      riderSection(orderData),
                      if(orderData.orderFeedback != null)
                        setHeight(MAIN_VERTICAL_PADDING),
                      userFeedback(orderData),
                      if (orderData.orderStatus != OrderStatus.CANCELLED &&
                          (orderData.orderStatus != OrderStatus.COMPLETED || orderData.orderFeedback == null))
                        setHeight(MAIN_VERTICAL_PADDING),
                      if (orderData.orderStatus != OrderStatus.CANCELLED &&
                          (orderData.orderStatus != OrderStatus.COMPLETED || orderData.orderFeedback == null))
                      buttonSection(orderData),
                      setHeight(MAIN_VERTICAL_PADDING),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

/// ORDER STATUS SECTION WITH HELPER METHODS STARTED FROM HERE
Widget orderStatusSection(OrderModel orderData) {
  return Obx(() {
    final statusTextColor = _getStatusTextColor(orderData.orderStatus!);
    final statusBgColor = _getStatusBgColor(orderData.orderStatus!);

    return orderDetailSectionsUI(
      titleText: 'Order Status',
      column: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          orderDetailItemsFixedUI(
            titleText: 'Current Status',
            detailText: orderData.orderStatus,
            detailColor: statusTextColor,
            detailBgColor: statusBgColor,
          ),
          setHeight(8.0),
          appDivider(),
          setHeight(8.0),
          _statusRow(
            dateTime: orderData.orderPlacedDateTime,
            label: 'Order Placed',
            status: orderData.orderStatus!,
            dotColor: EnvColors.offerHighlightColorDark,
          ),
          setHeight(8.0),
          _statusRow(
            dateTime: orderData.orderConfirmedDateTime,
            label: 'Confirmed',
            status: orderData.orderStatus!,
            dotColor: EnvColors.accentCTAColorLight,
          ),
          setHeight(8.0),
          _statusRow(
            dateTime: orderData.orderCompletedDateTime,
            label: 'Completed',
            status: orderData.orderStatus!,
            dotColor: EnvColors.primaryColorLight,
          ),
          if(orderData.orderCancelledDateTime != null)
          setHeight(8.0),
          if(orderData.orderCancelledDateTime != null)
            _statusRow(
            dateTime: orderData.orderCancelledDateTime,
            label: 'Cancelled',
            status: orderData.orderStatus!,
            dotColor: EnvColors.specialFestiveColorLight,
          ),
        ],
      ),
    );
  });
}

Widget _statusRow({
  required String? dateTime,
  required String label,
  required String status,
  required Color dotColor,
}) {
  final isPending = dateTime == null || dateTime.isEmpty;
  final isCancel = (dateTime == null || dateTime.isEmpty) && status == OrderStatus.CANCELLED;
  final title = isCancel ? 'Order Cancelled' : isPending ? 'Pending' :  formatDateTime(dateTime);
  final titleColor = AppColors.primaryTextColorSkin(isDark).withValues(alpha: isPending ? 0.6 : 1.0);
  final detailColor = AppColors.primaryTextColorSkin(isDark).withValues(alpha: isPending ? 0.4 : 1.0);
  final indicatorColor = isPending ? AppColors.cardColorSkin(isDark) : dotColor;

  return Row(
    children: [
      Expanded(
        child: orderDetailItemsFixedUI(
          titleText: title,
          detailText: label,
          titleColor: titleColor,
          detailColor: detailColor,
        ),
      ),
      setWidth(8.0),
      Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
          color: indicatorColor,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    ],
  );
}

Color _getStatusTextColor(String status) {
  switch (status) {
    case OrderStatus.ACTIVE:
      return EnvColors.backgroundColorDark;
    default:
      return EnvColors.backgroundColorLight;
  }
}

Color _getStatusBgColor(String status) {
  switch (status) {
    case OrderStatus.ACTIVE:
      return EnvColors.offerHighlightColorDark;
    case OrderStatus.CONFIRMED:
      return EnvColors.accentCTAColorLight;
    case OrderStatus.COMPLETED:
      return EnvColors.primaryColorLight;
    case OrderStatus.CANCELLED:
      return EnvColors.specialFestiveColorLight;
    default:
      return EnvColors.primaryColorLight;
  }
}
/// ORDER STATUS SECTION WITH HELPER METHODS ENDED HERE

/// PAYMENT DETAIL SECTION STARTED HERE
Widget paymentSection(OrderModel orderData){
  return orderDetailSectionsUI(
    titleText: 'Payment',
    column: Column(
      children: [
        orderDetailItemsFixedUI(
            titleText: 'Payment Method',
            detailText: orderData.paymentMethod!
        ),
        setHeight(8.0),
        orderDetailItemsFixedUI(
            titleText: 'Total Amount',
            detailText: 'Rs. ${orderData.totalCutPriceAmount!}'
        ),
        setHeight(8.0),
        orderDetailItemsFixedUI(
            titleText: 'Discount',
            detailText: '- Rs. ${orderData.totalDiscount!}'
        ),
        setHeight(8.0),
        orderDetailItemsFixedUI(
            titleText: 'Discounted Amount',
            detailText: 'Rs. ${orderData.totalSellingAmount!}'
        ),
        setHeight(8.0),
        orderDetailItemsFixedUI(
            titleText: 'Delivery Charges',
            detailText: 'Rs. ${orderData.deliveryCharges!}'
        ),
        setHeight(8.0),
        orderDetailItemsFixedUI(
            titleText: 'GST',
            detailText: 'Rs. ${orderData.salesTax!}'
        ),
        appDivider(),
        orderDetailItemsFixedUI(
          titleText: 'Payable Amount',
          detailText: 'Rs. ${(orderData.totalSellingAmount! + orderData.deliveryCharges! + orderData.salesTax!).toString()}'
        ),

      ],
    )
  );
}

/// ADDRESS DETAIL SECTION STARTED HERE
Widget addressSection(OrderModel orderData){
  var userData = orderData.user!.shippingAddress!;
  return orderDetailSectionsUI(
      titleText: 'Shipping Address',
      column: Column(
        children: [
          appText(text: '${userData.name!}, ${userData.phone}, ${userData.address}, ${userData.nearestPlace}, ${userData.city}, ${userData.postalCode}', maxLines: 50,
          textStyle: bodyTextStyle().copyWith(fontSize: NORMAL_TEXT_FONT_SIZE-2)
          ),
          setHeight(8.0),
          orderDetailItemsFixedUI(
              titleText: 'Shipping',
              detailText: orderData.shippingMethod!
          ),
        ],
      )
  );
}

/// PRODUCTS DETAIL SECTION STARTED HERE
Widget productsSection(OrderModel orderData){
  var products = orderData.orderedProducts!;
  return orderDetailSectionsUI(
      titleText: 'Ordered Products',
      column: Column(
        children: [
          Column(
            children: List.generate(products.length, (index) {
              var product = products[index];
              return Column(
                children: [
                  Row(
                    children: [
                      appText(
                        text: (index + 1).toString(),
                        textStyle: itemTextStyle(),
                      ),
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
                              text: isRightLang
                                  ? product.productNameUrdu
                                  : product.productNameEng,
                              textStyle: itemTextStyle().copyWith(
                                fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
                              ),
                              textDirection: setTextDirection(appLanguage),
                              maxLines: 1,
                            ),
                            Row(
                              children: [
                                if (product.productWeightGrams != null)
                                  appText(
                                    text: '${product.productWeightGrams} gm',
                                    textStyle: textFormHintTextStyle().copyWith(
                                      fontSize: TAGS_FONT_SIZE,
                                    ),
                                    maxLines: 1,
                                  ),
                                if (product.productSize != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6.0),
                                    child: appText(
                                      text: product.productSize,
                                      textStyle: itemTextStyle().copyWith(
                                        fontSize: TAGS_FONT_SIZE,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                              ],
                            ),

                            if (product.productCutPrice != null)
                              appText(
                                text: 'Rs. ${product.productCutPrice}',
                                maxLines: 1,
                                textStyle:
                                cutPriceTextStyle(
                                  isDetail: false,
                                ).copyWith(
                                  fontSize:
                                  TAGS_FONT_SIZE,
                                ),
                              ),
                            setWidth(8.0),
                            appText(
                              text: 'Rs. ${product.productSellingPrice}',
                              textStyle: sellingPriceTextStyle().copyWith(
                                fontSize: TAGS_FONT_SIZE,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      setWidth(MAIN_HORIZONTAL_PADDING),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          appText(
                            text:
                            '${product.productQty} x ${product.productSellingPrice!.toStringAsFixed(0)} = Rs. ${(product.productQty!.toInt() * product.productSellingPrice!.toDouble()).toStringAsFixed(0)}',
                            textStyle: secondaryTextStyle().copyWith(
                              color: AppColors.sellingPriceDetailTextSkin(
                                isDark,
                              ),
                              fontSize: TAGS_FONT_SIZE,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (index < products.length - 1)
                    setHeight(MAIN_HORIZONTAL_PADDING),
                ],
              );
            }),
          ),
        ],
      )
  );
}

/// DELIVERY TYPE DETAIL SECTION STARTED HERE
Widget deliveryTypeSection(OrderModel orderData){
  return orderDetailSectionsUI(
      titleText: 'Delivery',
      column: Column(
        children: [
          orderDetailItemsFixedUI(
            titleText: 'Delivery Type',
            detailText: orderData.isFlashDelivery == true ? AppLanguage.flashDeliveryStr(appLanguage) : AppLanguage.slotDeliveryStr(appLanguage)
          ),
          if(orderData.isSlotDelivery == true)
          setHeight(8.0),
          if(orderData.isSlotDelivery == true)
            orderDetailItemsFixedUI(
              titleText: 'Delivery Date',
              detailText: orderData.slotDate.toString()
            ),
          if(orderData.isSlotDelivery == true)
            setHeight(8.0),
          if(orderData.isSlotDelivery == true)
            orderDetailItemsFixedUI(
                titleText: 'Ordered Slot',
                detailText: orderData.slotLabel
            ),
        ],
      )
  );
}

/// RIDER DETAIL SECTION STARTED HERE
Widget riderSection(OrderModel orderData){
  return orderData.rider == null
      ? SizedBox.shrink()
      : orderDetailSectionsUI(
      titleText: 'Rider Detail',
      column:
       Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: appAsyncImage(orderData.rider!.riderImage, width: 24.0)),
              ),
              setWidth(8.0),
              Expanded(
                child: orderDetailItemsFixedUI(
                    titleText: 'Rider Name',
                    detailText: orderData.rider!.riderName
                ),
              ),
            ],
          )


        ],
      )
  );
}

/// USER FEEDBACK SECTION STARTED HERE
Widget userFeedback(OrderModel orderData){
  return orderData.orderFeedback == null
      ? SizedBox.shrink()
      : GestureDetector(
    onTap: ()=> Get.find<NavigationController>().gotoOrdersFeedbackScreen(orderModel: orderData),
        child: orderDetailSectionsUI(
        titleText: 'My Feedback',
        column:
        Column(
          children: [
            orderDetailItemsFixedUI(
                titleText: 'About our service',
                detailText: orderData.orderFeedback!.feedbackType
            ),
            setHeight(8.0),
            orderDetailItemsFixedUI(
                titleText: 'App experience',
                detailText: orderData.orderFeedback!.isPositive == true ? 'Positive' : 'Negative'
            ),
            if(orderData.orderFeedback!.feedbackDetail!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                setHeight(8.0),
                appDivider(),
                setHeight(8.0),
                appText(
                  text: 'Feedback comments',
                  textStyle: itemTextStyle().copyWith(fontWeight: FontWeight.w800,
                    color: AppColors.primaryTextColorSkin(isDark),
                  ),
                ),
                setHeight(8.0),
                appText(text: orderData.orderFeedback!.feedbackDetail.toString(), maxLines: 100,
                    textStyle: bodyTextStyle().copyWith(fontSize: NORMAL_TEXT_FONT_SIZE-2)
                ),
              ],
            )
          ],
        )
          ),
      );
}

/// BUTTON SECTION
Widget buttonSection(OrderModel orderData){
  var orders = Get.find<OrdersController>();
  return Obx((){
    return
      orders.updateOrderStatus.value == Status.LOADING
      ? loadingIndicator()
      : appMaterialButton(
        text: orderData.orderStatus == OrderStatus.COMPLETED && orderData.orderFeedback == null ? 'Give your feedback' : 'Cancel Order',
        isDisable: orderData.orderStatus == OrderStatus.CONFIRMED,
        onTap: ()=> orders.onTapButtonSectionsOrderTap()
    );
  });
}


Widget orderDetailSectionsUI({titleText, column}) {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          width: size.width,
          padding: EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
          decoration: BoxDecoration(
            color: AppColors.backgroundColorSkin(isDark),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: AppColors.primaryTextColorSkin(isDark),
              width: 1.0,
            ),
          ),

          child: column,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: MAIN_VERTICAL_PADDING),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.0),
          color: AppColors.backgroundColorSkin(isDark),
          child: appText(
            text: titleText,
            textStyle: itemTextStyle().copyWith(
              color: AppColors.materialButtonSkin(isDark),
              fontSize: NORMAL_TEXT_FONT_SIZE
            ),
          ),
        ),
      ),
    ],
  );
}
