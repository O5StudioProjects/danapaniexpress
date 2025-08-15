import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class OrderItemUI extends StatelessWidget {
  final OrderModel data;
  final int index;
  final bool isFilterScreen;
  const OrderItemUI({super.key, required this.data, required this.index, this.isFilterScreen = false});

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavigationController>();
    return Obx((){
      final statusTextColor = getStatusTextColor(data.orderStatus!);
      final statusBgColor = getStatusBgColor(data.orderStatus!);
      return _build(nav,statusTextColor, statusBgColor);
    });
  }
  Widget _build(nav,statusTextColor, statusBgColor){
    return GestureDetector(
      onTap: ()=> nav.gotoOrdersDetailScreen(orderModel: data),
      child: Padding(
        padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Stack(
            children: [
              _mainUISection(),
              _orderStatus(statusBgColor, statusTextColor)
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainUISection(){
    return  Container(
      width: size.width,
      padding: EdgeInsets.only(left: MAIN_HORIZONTAL_PADDING, right: MAIN_HORIZONTAL_PADDING, top: MAIN_VERTICAL_PADDING, bottom: MAIN_VERTICAL_PADDING),
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
            child: isFilterScreen ? ShowFilteredOrderData(data: data) : ShowOrderData(data: data),
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
            child: isFilterScreen ? ShowFilteredOrderData(data: data) : ShowOrderData(data: data),
          )
        ],
      ),
    );
  }

  Widget _orderStatus(statusBgColor, statusTextColor){
    return
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
      );
  }

}