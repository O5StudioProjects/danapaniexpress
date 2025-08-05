import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/domain/controllers/orders_controller/orders_controller.dart';
import 'package:danapaniexpress/ui/screens/pages/account/my_orders/widgets/order_item.dart';
import 'package:path/path.dart';

import '../../../../../data/models/order_model.dart';

class MyOrdersMobile extends StatelessWidget {
  const MyOrdersMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = Get.find<OrdersController>();
    orders.screenIndex.value = Get.arguments[ORDERS_INDEX]  ?? 0;
    orders.getOrdersByUserId();
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
            child: PageView.builder(
              controller: orders.pageController,
              onPageChanged: orders.onPageChanged,
              itemCount: orderTabsModelList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
                  child: OrdersListForTab(index: index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget showOrdersList({context}) {
//   final orders = Get.find<OrdersController>();
//
//   return Obx(() {
//     List<OrderModel> getFilteredList(int index) {
//       var status = OrderStatus.ACTIVE;
//
//       switch (index) {
//         case 0:
//           status = OrderStatus.ACTIVE;
//           break;
//         case 1:
//           status = OrderStatus.CONFIRMED;
//           break;
//         case 2:
//           status = OrderStatus.COMPLETED;
//           break;
//         case 3:
//           status = OrderStatus.CANCELLED;
//           break;
//       }
//
//       var filtered = orders.ordersList
//           .where((order) => order.orderStatus == status)
//           .toList();
//
//       return sortByDateDesc(filtered, status);
//     }
//
//     final screenIndex = orders.screenIndex.value;
//     final ordersList = getFilteredList(screenIndex);
//
//     if (orders.ordersStatus.value == Status.LOADING) {
//       return loadingIndicator();
//     } else if (orders.ordersStatus.value == Status.FAILURE) {
//       return ErrorScreen();
//     } else if (ordersList.isEmpty) {
//       final tabModel = orderTabsModelList[screenIndex];
//       return EmptyScreen(
//         icon: tabModel.icon,
//         iconType: IconType.PNG,
//         text: appLanguage == URDU_LANGUAGE ? '${tabModel.titleUrdu} لسٹ خالی ہے' : '${tabModel.titleEng} list is empty',
//         color: AppColors.materialButtonSkin(isDark),
//       );
//     }
//
//     return ListView.builder(
//       itemCount: ordersList.length,
//       padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
//       shrinkWrap: true,
//       physics: const BouncingScrollPhysics(),
//       itemBuilder: (context, index) {
//         final data = ordersList[index];
//         return OrderItemUI(data: data, index: index+1,);
//       },
//     );
//   });
// }
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

class OrdersListForTab extends StatelessWidget {
  final int index;
  const OrdersListForTab({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final orders = Get.find<OrdersController>();

    return Obx(() {
      if (orders.ordersStatus.value == Status.LOADING) {
        return loadingIndicator();
      }

      final tabModel = orderTabsModelList[index];
      final list = orders.getOrdersForTab(index);
      final sortedList = sortByDateDesc(list, tabModel.statusKey);

      if (orders.ordersStatus.value == Status.FAILURE) {
        return ErrorScreen();
      }

      if (sortedList.isEmpty) {
        return EmptyScreen(
          icon: tabModel.icon,
          iconType: IconType.PNG,
          text: appLanguage == URDU_LANGUAGE
              ? '${tabModel.titleUrdu} لسٹ خالی ہے'
              : '${tabModel.titleEng} list is empty',
          color: AppColors.materialButtonSkin(isDark),
        );
      }

      return ListView.builder(
        itemCount: sortedList.length,
        padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          final data = sortedList[i];
          return OrderItemUI(data: data, index: i + 1);
        },
      );
    });
  }
}
