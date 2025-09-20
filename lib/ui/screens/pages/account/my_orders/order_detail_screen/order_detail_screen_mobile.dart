import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';


class OrderDetailScreenMobile extends StatelessWidget {
  const OrderDetailScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var orders = Get.find<OrdersController>();
    var data = Get.arguments[DATA_ORDER] as OrderModel;
    WidgetsBinding.instance.addPostFrameCallback((_){
      orders.fetchOrderByNumber(data.orderNumber!);
    });

    return _buildUI(orders, data);
  }

  Widget _buildUI(orders, data){
    return Obx(() {
      var orderData = orders.selectedOrder.value;
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _appBar(),
            _mainSection(orderData, orders),
          ],
        ),
      );
    });
  }

  _appBar(){
    return appBarCommon(title: AppLanguage.orderDetailStr(appLanguage), isBackNavigation: true);
  }

  _mainSection(orderData, orders){
    if(orderData == null || orders.getOrderByNumberStatus.value == Status.LOADING){
      return Expanded(child: loadingIndicator());
    } else{
      return _mainContent(orderData);
    }
  }

  _mainContent(orderData){
    return Expanded(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: MAIN_HORIZONTAL_PADDING,
            vertical: MAIN_HORIZONTAL_PADDING,
          ),
          child: Column(
            children: [
              _orderNumber(orderData),
              /// ORDER STATUS SECTION WITH HELPER METHODS STARTED FROM HERE
              OrderStatusSection(orderData: orderData),
              /// DELIVERY TYPE DETAIL SECTION STARTED HERE
              DeliveryTypeSection(orderData: orderData),
              /// PRODUCTS DETAIL SECTION STARTED HERE
              ProductSection(orderData: orderData),
              /// PAYMENT DETAIL SECTION STARTED HERE
              PaymentSection(orderData: orderData),
              /// ADDRESS DETAIL SECTION STARTED HERE
              AddressSection(orderData: orderData),
              /// RIDER NOTE SECTION STARTED HERE
              SpecialNoteForRider(orderData: orderData),
              /// RIDER DETAIL SECTION STARTED HERE
              RiderSection(orderData: orderData),
              /// USER FEEDBACK SECTION STARTED HERE
              UserFeedbackSection(orderData: orderData),

              if (orderData.orderStatus != OrderStatus.CANCELLED &&
                  (orderData.orderStatus != OrderStatus.COMPLETED || orderData.orderFeedback == null))
                setHeight(MAIN_VERTICAL_PADDING),
              if (orderData.orderStatus != OrderStatus.CANCELLED &&
                  (orderData.orderStatus != OrderStatus.COMPLETED || orderData.orderFeedback == null))
              /// BUTTON SECTION
                _buttonSection(orderData),
              setHeight(MAIN_VERTICAL_PADDING),

            ],
          ),
        ),
      ),
    );
  }

  _orderNumber(orderData){
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_VERTICAL_PADDING),
      child: orderDetailItemsUI(
        titleText: AppLanguage.orderNumberHashStr(appLanguage),
        titleTextStyle: headingTextStyle().copyWith(
        ),
        detailText:
        orderData.orderNumber?.split('_').last ?? '',
        detailTextStyle: headingTextStyle(),
      ),
    );
  }

  _buttonSection(OrderModel orderData){
    var orders = Get.find<OrdersController>();
    return Obx((){
      return
        orders.updateOrderStatus.value == Status.LOADING
            ? loadingIndicator()
            : appMaterialButton(
            text: orderData.orderStatus == OrderStatus.COMPLETED && orderData.orderFeedback == null ? AppLanguage.giveYourFeedbackStr(appLanguage) : AppLanguage.cancelOrderStr(appLanguage),
            isDisable: orderData.orderStatus == OrderStatus.CONFIRMED,
            onTap: ()=> orders.onTapButtonSectionsOrderTap()
        );
    });
  }

}







