import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

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
      return _buildUI(activeOrders, confirmedOrders, completedOrders, cancelledOrders);
    });
  }

  Widget _buildUI(activeOrders, confirmedOrders, completedOrders, cancelledOrders){
    return Column(
      crossAxisAlignment: isRightLang ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        _orderNumber(),

        if(activeOrders)...[
          _orderPlacedDateTime(),
        ] else if(confirmedOrders)...[
          _orderConfirmedDateTime(),
        ] else if(completedOrders)...[
          _orderCompletedDateTime(),
        ] else if(cancelledOrders)...[
          _orderCancelledDateTime(),
        ],
        _orderAmount(),

      ],
    );
  }

  Widget _orderNumber(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: orderDetailItemsUI(
          titleText: AppLanguage.orderNumberHashStr(appLanguage),
          titleTextStyle: secondaryTextStyle().copyWith(
              color: AppColors.primaryTextColorSkin(isDark),
              fontSize: isRightLang ? SUB_HEADING_TEXT_BUTTON_FONT_SIZE+2 : SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
              fontWeight: FontWeight.w800
          ),
          detailText: data.orderNumber?.split('_').last ?? '',
          detailTextStyle: bodyTextStyle().copyWith(fontFamily: robotoRegular, fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE)
      ),
    );
  }

  Widget _orderPlacedDateTime(){
    return orderDetailItemsUI(
        titleText: AppLanguage.orderPlacedOnStr(appLanguage),
        titleTextStyle: secondaryTextStyle().copyWith(
            color: AppColors.primaryTextColorSkin(isDark),
            fontSize: isRightLang ? SUB_HEADING_TEXT_BUTTON_FONT_SIZE+2 : SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
            fontWeight: FontWeight.w800
        ),
        isDate: true,
        detailText: data.orderPlacedDateTime == null || data.orderPlacedDateTime!.isEmpty ? '' : formatDateTime(data.orderPlacedDateTime.toString()),
        detailTextStyle: bodyTextStyle().copyWith(fontFamily: robotoRegular, fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE)
    );
  }

  Widget _orderConfirmedDateTime(){
    return orderDetailItemsUI(
        titleText: AppLanguage.orderConfirmedOnStr(appLanguage),
        titleTextStyle: secondaryTextStyle().copyWith(
            color: AppColors.primaryTextColorSkin(isDark),
            fontSize: isRightLang ? SUB_HEADING_TEXT_BUTTON_FONT_SIZE+2 : SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
            fontWeight: FontWeight.w800
        ),
        detailText: data.orderConfirmedDateTime == null || data.orderConfirmedDateTime!.isEmpty ? '' : formatDateTime(data.orderConfirmedDateTime.toString()),
        detailTextStyle: bodyTextStyle().copyWith(fontFamily: robotoRegular, fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE)

    );
  }

  Widget _orderCompletedDateTime(){
    return orderDetailItemsUI(
        titleText: AppLanguage.orderCompletedOnStr(appLanguage),
        titleTextStyle: secondaryTextStyle().copyWith(
            color: AppColors.primaryTextColorSkin(isDark),
            fontSize: isRightLang ? SUB_HEADING_TEXT_BUTTON_FONT_SIZE+2 : SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
            fontWeight: FontWeight.w800
        ),
        detailText: data.orderCompletedDateTime == null || data.orderCompletedDateTime!.isEmpty ? '' : formatDateTime(data.orderCompletedDateTime.toString()),
        detailTextStyle: bodyTextStyle().copyWith(fontFamily: robotoRegular, fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE)
    );
  }

  Widget _orderCancelledDateTime(){
    return orderDetailItemsUI(
        titleText: AppLanguage.orderCancelledOnStr(appLanguage),
        titleTextStyle: secondaryTextStyle().copyWith(
            color: AppColors.primaryTextColorSkin(isDark),
            fontSize: isRightLang ? SUB_HEADING_TEXT_BUTTON_FONT_SIZE+2 : SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
            fontWeight: FontWeight.w800
        ),
        detailText: data.orderCancelledDateTime == null || data.orderCancelledDateTime!.isEmpty ? '' : formatDateTime(data.orderCancelledDateTime.toString()),
        detailTextStyle: bodyTextStyle().copyWith(fontFamily: robotoRegular, fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE)

    );
  }

  Widget _orderAmount(){
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: orderDetailItemsUI(
          titleText: AppLanguage.orderAmountStr(appLanguage),
          titleTextStyle: secondaryTextStyle().copyWith(
              color: AppColors.primaryTextColorSkin(isDark),
              fontSize: isRightLang ? SUB_HEADING_TEXT_BUTTON_FONT_SIZE+2 : SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
              fontWeight: FontWeight.w800
          ),
          detailText: '$appCurrency ${data.totalSellingAmount! + data.deliveryCharges!}',
          detailTextStyle: bodyTextStyle().copyWith(fontFamily: robotoRegular, fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE)
      ),
    );
  }

}