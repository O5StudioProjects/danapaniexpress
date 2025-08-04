import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/controllers/orders_controller/orders_controller.dart';


class MyOrders extends StatelessWidget {
  final bool ordersScreen;
  const MyOrders({super.key, required this.ordersScreen});

  @override
  Widget build(BuildContext context) {
    var orders = Get.put(OrdersController());

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: ordersScreen ? orders.scrollController: null,
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(left: MAIN_HORIZONTAL_PADDING),
        child: Row(
          children: List.generate(orderTabsModelList.length, (index){
            var orderData = orderTabsModelList[index];
            return ordersScreen ?  ordersScreenOrdersList(orderData, index) : accountScreenOrdersList(orderData, index);
          }),
        ),
      ),
    );
  }
}

Widget accountScreenOrdersList(OrderTabsModel orderData, index){
  final nav = Get.find<NavigationController>();
  return Padding(
    padding: const EdgeInsets.only(right: MAIN_HORIZONTAL_PADDING, bottom: MAIN_VERTICAL_PADDING),
    child: GestureDetector(
      onTap: ()=> nav.gotoOrdersScreen(screenIndex: index),
      child: Container(
        width: size.width * 0.25,
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
          children: [
            appIcon(iconType: IconType.PNG, icon: orderData.icon, width: 20.0, color: AppColors.materialButtonSkin(isDark)),
            setHeight(MAIN_HORIZONTAL_PADDING/2),
            appText(text: appLanguage == URDU_LANGUAGE ? orderData.titleUrdu : orderData.titleEng, textStyle: itemTextStyle())
          ],
        ),
      ),
    ),
  );
}

Widget ordersScreenOrdersList(OrderTabsModel orderData, index){
  var orders = Get.find<OrdersController>();
  // var orders = Get.put(OrdersController());
  WidgetsBinding.instance.addPostFrameCallback((_) {
    orders.scrollToIndex();
  });
  return Obx((){
    var currentIndex = index == orders.screenIndex.value;
    return Padding(
      padding: const EdgeInsets.only(right: MAIN_HORIZONTAL_PADDING, bottom: MAIN_VERTICAL_PADDING),
      child: GestureDetector(
          onTap: () {
            orders.updateTabIndex(index);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              orders.scrollToIndex();
            });
          },
        child: Container(
          padding: EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
          decoration: BoxDecoration(
            color: currentIndex ? AppColors.materialButtonSkin(isDark) : AppColors.cardColorSkin(isDark),
            borderRadius: BorderRadius.circular(4.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(30),
                blurRadius: 1,
                spreadRadius: 0,
                offset: const Offset(1, 2),
              ),
            ],
          ),
          child: appLanguage == URDU_LANGUAGE
              ? Row(
            children: [
              appText(text: appLanguage == URDU_LANGUAGE ? orderData.titleUrdu : orderData.titleEng,
                  textStyle: itemTextStyle().copyWith(color: currentIndex ? AppColors.materialButtonTextSkin(isDark) : AppColors.primaryTextColorSkin(isDark))),
              setWidth(8.0),
              appIcon(iconType: IconType.PNG, icon: orderData.icon, width: 20.0, color: currentIndex ? AppColors.materialButtonTextSkin(isDark) : AppColors.materialButtonSkin(isDark)),

            ],
          )
              : Row(
            children: [
              appIcon(iconType: IconType.PNG, icon: orderData.icon, width: 20.0, color: currentIndex ? AppColors.materialButtonTextSkin(isDark) : AppColors.materialButtonSkin(isDark)),
              setWidth(8.0),
              appText(text: appLanguage == URDU_LANGUAGE ? orderData.titleUrdu : orderData.titleEng, textStyle: itemTextStyle().copyWith(color: currentIndex ? AppColors.materialButtonTextSkin(isDark) : AppColors.primaryTextColorSkin(isDark)))
            ],
          ),
        ),
      ),
    );
  });
}