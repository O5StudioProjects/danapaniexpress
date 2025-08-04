import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/domain/controllers/orders_controller/orders_controller.dart';
import 'package:path/path.dart';

import '../../../../../data/models/order_model.dart';

class MyOrdersMobile extends StatelessWidget {
  const MyOrdersMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = Get.find<OrdersController>();
    orders.screenIndex.value = Get.arguments[ORDERS_INDEX]  ?? 0;

    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          appBarCommon(title: AppLanguage.myOrdersStr(appLanguage), isBackNavigation: true),
          setHeight(MAIN_HORIZONTAL_PADDING),
          MyOrders(ordersScreen: true),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
                child: showOrdersList(context: context),
              )
          ),
        ],
      ),
    );
  }
}

Widget showOrdersList({context}) {
  final orders = Get.find<OrdersController>();

  return Obx(() {
    List<OrderModel> getFilteredList(int index) {
      var status = OrderStatus.ACTIVE;

      switch (index) {
        case 0:
          status = OrderStatus.ACTIVE;
          break;
        case 1:
          status = OrderStatus.CONFIRMED;
          break;
        case 2:
          status = OrderStatus.COMPLETED;
          break;
        case 3:
          status = OrderStatus.CANCELLED;
          break;
      }

      var filtered = orders.ordersList
          .where((order) => order.orderStatus == status)
          .toList();

      return sortByDateDesc(filtered, status);
    }

    final screenIndex = orders.screenIndex.value;
    final ordersList = getFilteredList(screenIndex);

    if (orders.ordersStatus.value == Status.LOADING) {
      return loadingIndicator();
    } else if (orders.ordersStatus.value == Status.FAILURE) {
      return ErrorScreen();
    } else if (ordersList.isEmpty) {
      final tabModel = orderTabsModelList[screenIndex];
      return EmptyScreen(
        icon: tabModel.icon,
        iconType: IconType.PNG,
        text: appLanguage == URDU_LANGUAGE ? tabModel.titleUrdu : tabModel.titleEng,
        color: AppColors.materialButtonSkin(isDark),
      );
    }

    return ListView.builder(
      itemCount: ordersList.length,
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final data = ordersList[index];
        return orderItemUI(data);
      },
    );
  });
}
List<OrderModel> sortByDateDesc(List<OrderModel> list, status) {
  list.sort((a, b) {
    String? aDateStr;
    String? bDateStr;

    switch (status) {
      case OrderStatus.ACTIVE:
        aDateStr = a.orderPlacedDateTime;
        bDateStr = b.orderPlacedDateTime;
        break;
      case OrderStatus.CONFIRMED:
        aDateStr = a.orderConfirmedDateTime;
        bDateStr = b.orderConfirmedDateTime;
        break;
      case OrderStatus.COMPLETED:
        aDateStr = a.orderCompletedDateTime;
        bDateStr = b.orderCompletedDateTime;
        break;
      case OrderStatus.CANCELLED:
        aDateStr = a.orderCancelledDateTime;
        bDateStr = b.orderCancelledDateTime;
        break;
    }

    final aDate = DateTime.tryParse(aDateStr ?? '') ?? DateTime(1970);
    final bDate = DateTime.tryParse(bDateStr ?? '') ?? DateTime(1970);

    return bDate.compareTo(aDate); // Newest first
  });

  return list;
}


Widget orderItemUI(OrderModel data){
  final orders = Get.find<OrdersController>();
  return Obx((){
    var activeOrders = orders.screenIndex.value == 0;
    var confirmedOrders = orders.screenIndex.value == 1;
    var completedOrders = orders.screenIndex.value == 2;
    var cancelledOrders = orders.screenIndex.value == 3;

    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Stack(
          children: [
            Container(
              width: size.width,
              padding: EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
              decoration: BoxDecoration(
                color: AppColors.cardColorSkin(isDark),
                borderRadius: BorderRadius.circular(12.0),
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
                crossAxisAlignment: appLanguage == URDU_LANGUAGE ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text.rich(
                      textDirection: setTextDirection(appLanguage),
                      textAlign: setTextAlignment(appLanguage),
                      TextSpan(
                          text: '${AppLanguage.orderNumberStr(appLanguage)} ',
                          style: bodyTextStyle(),
                          children: [
                            TextSpan(
                                text:  data.orderNumber?.split('_').last ?? '',
                                style: itemTextStyle()
                            )
                          ]
                      )),
                  setHeight(4.0),
                  if(activeOrders)...[
                    Text.rich(
                        textDirection: setTextDirection(appLanguage),
                        textAlign: setTextAlignment(appLanguage),
                        TextSpan(
                            text: AppLanguage.orderPlacedOnStr(appLanguage),
                            style: bodyTextStyle(),
                            children: [
                              WidgetSpan(
                                  child: appText(text: formatDateTime(data.orderPlacedDateTime.toString()),
                                  textStyle: itemTextStyle().copyWith(fontSize: NORMAL_TEXT_FONT_SIZE),
                                    textDirection: TextDirection.ltr,
                                  )
                              ),
                            ]
                        )),
                  ] else if(confirmedOrders)...[
                    Text.rich(
                        textDirection: setTextDirection(appLanguage),
                        textAlign: setTextAlignment(appLanguage),
                        TextSpan(
                            text: AppLanguage.orderConfirmedOnStr(appLanguage),
                            style: bodyTextStyle(),
                            children: [
                              WidgetSpan(
                                  child: appText(text: formatDateTime(data.orderConfirmedDateTime.toString()),
                                    textStyle: itemTextStyle().copyWith(fontSize: NORMAL_TEXT_FONT_SIZE),
                                    textDirection: TextDirection.ltr,
                                  )
                              ),

                            ]
                        )),
                  ] else if(completedOrders)...[
                    Text.rich(
                        textDirection: setTextDirection(appLanguage),
                        textAlign: setTextAlignment(appLanguage),
                        TextSpan(
                            text: AppLanguage.orderCompletedOnStr(appLanguage),
                            style: bodyTextStyle(),
                            children: [
                              WidgetSpan(
                                  child: appText(text: formatDateTime(data.orderCompletedDateTime.toString()),
                                    textStyle: itemTextStyle().copyWith(fontSize: NORMAL_TEXT_FONT_SIZE),
                                    textDirection: TextDirection.ltr,
                                  )
                              ),

                            ]
                        )),
                  ] else if(cancelledOrders)...[
                    Text.rich(
                        textDirection: setTextDirection(appLanguage),
                        textAlign: setTextAlignment(appLanguage),
                        TextSpan(
                            text: AppLanguage.orderCancelledOnStr(appLanguage),
                            style: bodyTextStyle(),
                            children: [
                              WidgetSpan(
                                  child: appText(text: formatDateTime(data.orderCancelledDateTime.toString()),
                                    textStyle: itemTextStyle().copyWith(fontSize: NORMAL_TEXT_FONT_SIZE),
                                    textDirection: TextDirection.ltr,
                                  )
                              ),
                            ]
                        )),
                  ],
                  setHeight(4.0),

                  Text.rich(
                    textDirection: setTextDirection(appLanguage),
                      textAlign: setTextAlignment(appLanguage),
                      TextSpan(
                          text: AppLanguage.orderAmountStr(appLanguage),
                          style: bodyTextStyle(),
                          children: [
                            TextSpan(
                                text: 'Rs. ${data.totalSellingAmount! + data.deliveryCharges!}',
                                style: sellingPriceTextStyle().copyWith(fontSize: NORMAL_TEXT_FONT_SIZE-2),
                            )
                          ]
                      )),

                ],
              ),
            ),
            appLanguage == URDU_LANGUAGE
            ? Positioned(
              left: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                    color: AppColors.materialButtonSkin(isDark),
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(12.0))
                ),
                child: Center(child: appText(text: orderStatusConversion(data.orderStatus.toString()), textStyle: itemTextStyle().copyWith(
                    color: AppColors.materialButtonTextSkin(isDark)
                ))),
              ),
            )
            : Positioned(
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: AppColors.materialButtonSkin(isDark),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0))
                ),
                child: Center(child: appText(text: orderStatusConversion(data.orderStatus.toString()), textStyle: itemTextStyle().copyWith(
                  color: AppColors.materialButtonTextSkin(isDark)
                ))),
              ),
            )
          ],
        ),
      ),
    );
  });
}
