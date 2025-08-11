import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

import '../../../../../../data/models/order_model.dart';
import '../../../../../../domain/controllers/orders_controller/orders_controller.dart';

class OrderItemUI extends StatelessWidget {
  final OrderModel data;
  final int index;
  const OrderItemUI({super.key, required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavigationController>();
    return Obx((){
      final statusTextColor = _getStatusTextColor(data.orderStatus!);
      final statusBgColor = _getStatusBgColor(data.orderStatus!);
      return GestureDetector(
        onTap: ()=> nav.gotoOrdersDetailScreen(orderModel: data),
        child: Padding(
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
                  child: isRightLang
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ShowOrderData(data: data),
                      ),
                      setWidth(8.0),
                      ShowIndexNumber(index: index),
                    ],
                  )
                      : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ShowIndexNumber(index: index),
                      setWidth(8.0),
                      Expanded(
                        child: ShowOrderData(data: data),
                      )
                    ],
                  ),
                ),
                isRightLang
                    ? Positioned(
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(12.0))
                    ),
                    child: Center(child: appText(text: orderStatusConversion(data.orderStatus.toString()), textStyle: itemTextStyle().copyWith(
                        color: statusTextColor
                    ))),
                  ),
                )
                    : Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0))
                    ),
                    child: Center(child: appText(text: orderStatusConversion(data.orderStatus.toString()), textStyle: itemTextStyle().copyWith(
                        color: statusTextColor
                    ))),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
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

class ShowIndexNumber extends StatelessWidget {
  final int index;
  const ShowIndexNumber({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return SizedBox(
        width: 30,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 2.0,vertical: 2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  //   color: AppColors.materialButtonSkin(isDark)
                ),
                child: Center(child: appText(text: index.toString(), textStyle: itemTextStyle().copyWith(
                    fontSize: NORMAL_TEXT_FONT_SIZE-2
                ))))
          ],
        ),
      );
    });
  }
}

class ShowOrderData extends StatelessWidget {
  final OrderModel data;
  const ShowOrderData({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final orders = Get.find<OrdersController>();

    return Obx((){
      var activeOrders = orders.screenIndex.value == 0;
      var confirmedOrders = orders.screenIndex.value == 1;
      var completedOrders = orders.screenIndex.value == 2;
      var cancelledOrders = orders.screenIndex.value == 3;
      return Column(
        crossAxisAlignment: isRightLang ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          orderDetailItemsUI(
              titleText: '${AppLanguage.orderNumberStr(appLanguage)} ',
              titleTextStyle: secondaryTextStyle().copyWith(
                  color: AppColors.primaryTextColorSkin(isDark),
                  fontSize: NORMAL_TEXT_FONT_SIZE,
                  fontWeight: FontWeight.w800
              ),
              detailText: data.orderNumber?.split('_').last ?? '',
              detailTextStyle: bodyTextStyle().copyWith(
                  fontSize: NORMAL_TEXT_FONT_SIZE
              )
          ),
          setHeight(4.0),
          if(activeOrders)...[
            orderDetailItemsUI(
                titleText: AppLanguage.orderPlacedOnStr(appLanguage),
                titleTextStyle: secondaryTextStyle().copyWith(
                    color: AppColors.primaryTextColorSkin(isDark),
                    fontSize: NORMAL_TEXT_FONT_SIZE,
                    fontWeight: FontWeight.w800
                ),
                isDateTime: true,
                detailText: data.orderPlacedDateTime == null || data.orderPlacedDateTime!.isEmpty ? '' : formatDateTime(data.orderPlacedDateTime.toString()),
                detailTextStyle: bodyTextStyle().copyWith(
                    fontSize: NORMAL_TEXT_FONT_SIZE
                )
            ),

          ] else if(confirmedOrders)...[
            orderDetailItemsUI(
                titleText: AppLanguage.orderConfirmedOnStr(appLanguage),
                titleTextStyle: secondaryTextStyle().copyWith(
                    color: AppColors.primaryTextColorSkin(isDark),
                    fontSize: NORMAL_TEXT_FONT_SIZE,
                    fontWeight: FontWeight.w800
                ),
                detailText: data.orderConfirmedDateTime == null || data.orderConfirmedDateTime!.isEmpty ? '' : formatDateTime(data.orderConfirmedDateTime.toString()),
                detailTextStyle: bodyTextStyle().copyWith(
                    fontSize: NORMAL_TEXT_FONT_SIZE
                )
            ),

          ] else if(completedOrders)...[
            orderDetailItemsUI(
                titleText: AppLanguage.orderCompletedOnStr(appLanguage),
                titleTextStyle: secondaryTextStyle().copyWith(
                    color: AppColors.primaryTextColorSkin(isDark),
                    fontSize: NORMAL_TEXT_FONT_SIZE,
                    fontWeight: FontWeight.w800
                ),
                detailText: data.orderCompletedDateTime == null || data.orderCompletedDateTime!.isEmpty ? '' : formatDateTime(data.orderCompletedDateTime.toString()),
                detailTextStyle: bodyTextStyle().copyWith(
                    fontSize: NORMAL_TEXT_FONT_SIZE
                )
            ),
          ] else if(cancelledOrders)...[
            orderDetailItemsUI(
                titleText: AppLanguage.orderCancelledOnStr(appLanguage),
                titleTextStyle: secondaryTextStyle().copyWith(
                    color: AppColors.primaryTextColorSkin(isDark),
                    fontSize: NORMAL_TEXT_FONT_SIZE,
                    fontWeight: FontWeight.w800
                ),
                detailText: data.orderCancelledDateTime == null || data.orderCancelledDateTime!.isEmpty ? '' : formatDateTime(data.orderCancelledDateTime.toString()),
                detailTextStyle: bodyTextStyle().copyWith(
                    fontSize: NORMAL_TEXT_FONT_SIZE
                )
            ),
          ],
          setHeight(4.0),
          orderDetailItemsUI(
              titleText: AppLanguage.orderAmountStr(appLanguage),
              titleTextStyle: secondaryTextStyle().copyWith(
                  color: AppColors.primaryTextColorSkin(isDark),
                  fontSize: NORMAL_TEXT_FONT_SIZE,
                  fontWeight: FontWeight.w800
              ),
              detailText: '$appCurrency ${data.totalSellingAmount! + data.deliveryCharges!}',
              detailTextStyle: bodyTextStyle().copyWith(
                  fontSize: NORMAL_TEXT_FONT_SIZE
              )
          ),

        ],
      );
    });
  }
}

