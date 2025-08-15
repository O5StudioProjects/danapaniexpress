import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class ShowFilteredOrderData extends StatelessWidget {
  final OrderModel data;
  const ShowFilteredOrderData({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return _buildUI();
    });
  }

  Widget _buildUI(){
    return Column(
      crossAxisAlignment: isRightLang ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        _orderNumber(),
        if(data.orderPlacedDateTime != null )
          _orderPlacedDateTime(),

        if(data.orderConfirmedDateTime != null)
          _orderConfirmedDateTime(),

        if(data.orderCompletedDateTime != null)
          _orderCompletedDateTime(),
        if(data.orderCancelledDateTime != null )
          _orderCancelledDateTime(),

        _orderAmount(),

      ],
    );
  }

  Widget _orderNumber(){
    return orderDetailItemsUI(
        titleText: AppLanguage.orderNumberHashStr(appLanguage),
        titleTextStyle: secondaryTextStyle().copyWith(
            color: AppColors.primaryTextColorSkin(isDark),
            fontSize: isRightLang ? NORMAL_TEXT_FONT_SIZE+2 : NORMAL_TEXT_FONT_SIZE,
            fontWeight: FontWeight.w800
        ),
        detailText: data.orderNumber?.split('_').last ?? '',
        detailTextStyle: bodyTextStyle().copyWith(fontFamily: robotoRegular, fontSize: NORMAL_TEXT_FONT_SIZE)
    );
  }

  Widget _orderPlacedDateTime(){
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: orderDetailItemsUI(
          titleText: AppLanguage.orderPlacedOnStr(appLanguage),
          titleTextStyle: secondaryTextStyle().copyWith(
              color: AppColors.primaryTextColorSkin(isDark),
              fontSize: isRightLang ? NORMAL_TEXT_FONT_SIZE+2 : NORMAL_TEXT_FONT_SIZE,
              fontWeight: FontWeight.w800
          ),
          isDate: true,
          detailText: formatDateTime(data.orderPlacedDateTime.toString()),
          detailTextStyle: bodyTextStyle().copyWith(fontFamily: robotoRegular, fontSize: NORMAL_TEXT_FONT_SIZE)
      ),
    );
  }

  Widget _orderConfirmedDateTime(){
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: orderDetailItemsUI(
          titleText: AppLanguage.orderConfirmedOnStr(appLanguage),
          titleTextStyle: secondaryTextStyle().copyWith(
              color: AppColors.primaryTextColorSkin(isDark),
              fontSize: isRightLang ? NORMAL_TEXT_FONT_SIZE+2 : NORMAL_TEXT_FONT_SIZE,
              fontWeight: FontWeight.w800
          ),
          detailText: data.orderConfirmedDateTime == null || data.orderConfirmedDateTime!.isEmpty ? '' : formatDateTime(data.orderConfirmedDateTime.toString()),
          detailTextStyle: bodyTextStyle().copyWith(fontFamily: robotoRegular, fontSize: NORMAL_TEXT_FONT_SIZE)

      ),
    );
  }

  Widget _orderCompletedDateTime(){
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: orderDetailItemsUI(
          titleText: AppLanguage.orderCompletedOnStr(appLanguage),
          titleTextStyle: secondaryTextStyle().copyWith(
              color: AppColors.primaryTextColorSkin(isDark),
              fontSize: isRightLang ? NORMAL_TEXT_FONT_SIZE+2 : NORMAL_TEXT_FONT_SIZE,
              fontWeight: FontWeight.w800
          ),
          detailText: data.orderCompletedDateTime == null || data.orderCompletedDateTime!.isEmpty ? '' : formatDateTime(data.orderCompletedDateTime.toString()),
          detailTextStyle: bodyTextStyle().copyWith(fontFamily: robotoRegular, fontSize: NORMAL_TEXT_FONT_SIZE)

      ),
    );
  }

  Widget _orderCancelledDateTime(){
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: orderDetailItemsUI(
          titleText: AppLanguage.orderCancelledOnStr(appLanguage),
          titleTextStyle: secondaryTextStyle().copyWith(
              color: AppColors.primaryTextColorSkin(isDark),
              fontSize: isRightLang ? NORMAL_TEXT_FONT_SIZE+2 : NORMAL_TEXT_FONT_SIZE,
              fontWeight: FontWeight.w800
          ),
          detailText: data.orderCancelledDateTime == null || data.orderCancelledDateTime!.isEmpty ? '' : formatDateTime(data.orderCancelledDateTime.toString()),
          detailTextStyle: bodyTextStyle().copyWith(fontFamily: robotoRegular, fontSize: NORMAL_TEXT_FONT_SIZE)

      ),
    );
  }

  Widget _orderAmount(){
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: orderDetailItemsUI(
          titleText: AppLanguage.orderAmountStr(appLanguage),
          titleTextStyle: secondaryTextStyle().copyWith(
              color: AppColors.primaryTextColorSkin(isDark),
              fontSize: isRightLang ? NORMAL_TEXT_FONT_SIZE+2 : NORMAL_TEXT_FONT_SIZE,
              fontWeight: FontWeight.w800
          ),
          detailText: '$appCurrency ${data.totalSellingAmount! + data.deliveryCharges!}',
          detailTextStyle: bodyTextStyle().copyWith(fontFamily: robotoRegular, fontSize: NORMAL_TEXT_FONT_SIZE)
      ),
    );
  }


}