import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/controllers/orders_controller/orders_controller.dart';
import 'package:danapaniexpress/ui/screens/pages/account/my_orders/widgets/order_item.dart';

import '../../../../../data/models/order_model.dart';

class MyOrdersMobile extends StatelessWidget {
  const MyOrdersMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = Get.find<OrdersController>();
    final nav = Get.find<NavigationController>();
    orders.screenIndex.value = Get.arguments[ORDERS_INDEX] ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // orders.fetchInitialOrders();
      orders.pageController.jumpToPage(orders.screenIndex.value);
      // Fetch the initial list for the default tab
      orders.fetchOrdersForTab(orders.screenIndex.value);
    });

    return Obx(() {

      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(
              title: AppLanguage.myOrdersStr(appLanguage),
              isBackNavigation: true,
              isTrailing: true,
              trailingIcon: icSearch,
              trailingIconType: IconType.SVG,
              trailingOnTap: ()=> nav.gotoOrdersFilterScreen(),
            ),
            setHeight(MAIN_HORIZONTAL_PADDING),
            MyOrders(ordersScreen: true),

            Expanded(
              child: PageView.builder(
                controller: orders.pageController,
                onPageChanged: orders.onPageChanged,
                itemCount: orderTabsModelList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: MAIN_HORIZONTAL_PADDING,
                    ),
                    child: OrdersListForTab(index: index),
                  );
                },
              ),
            ),

            /// SHOW BOTTOM MESSAGE / LOADING INDICATOR
            Obx(() {
              final tabIndex =
                  orders.screenIndex.value; // or widget.index if passed
              final isLoadingMore = orders.getLoadingMoreForTab(tabIndex).value;
              final hasMore = orders.getHasMoreForTab(tabIndex).value;
              final reachedEnd = orders.reachedEndOfScroll.value;

              // ✅ Only show when all products are scrolled & no more left
              if (!hasMore && reachedEnd) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Center(
                    child: appText(
                      text: 'No more orders',
                      textStyle: itemTextStyle(),
                    ),
                  ),
                );
              }

              // ✅ Show loading if fetching more
              if (isLoadingMore) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: loadingIndicator(),
                );
              }

              return const SizedBox(); // nothing to show
            }),
          ],
        ),
      );
    });
  }
}

List<OrderModel> sortByDateDesc(List<OrderModel> list, status) {
  // ✅ Work on a copy to avoid mutating the original RxList
  final sortedList = List<OrderModel>.from(list);

  sortedList.sort((a, b) {
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

  return sortedList;
}

class OrdersListForTab extends StatefulWidget {
  final int index;

  const OrdersListForTab({super.key, required this.index});

  @override
  State<OrdersListForTab> createState() => _OrdersListForTabState();
}

class _OrdersListForTabState extends State<OrdersListForTab> {
  final ScrollController _scrollController = ScrollController();
  final orders = Get.find<OrdersController>();
  double _previousOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      orders.fetchOrdersForTab(widget.index);
    });
  }

  void _scrollListener() {
    final currentOffset = _scrollController.position.pixels;
    final maxOffset = _scrollController.position.maxScrollExtent;

    // ✅ Bottom message visibility
    orders.showBottomMessage.value = currentOffset > _previousOffset;

    // ✅ End of scroll detection
    orders.reachedEndOfScroll.value = currentOffset >= maxOffset - 10;

    // ✅ Load more trigger (per tab)
    final tabIndex = widget.index;
    final hasMore = orders.getHasMoreForTab(tabIndex).value;
    final isLoadingMore = orders.getLoadingMoreForTab(tabIndex).value;

    if (currentOffset >= maxOffset - 200 && hasMore && !isLoadingMore) {
      orders.loadMoreOrdersForTab(tabIndex);
    }

    _previousOffset = currentOffset;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tabModel = orderTabsModelList[widget.index];
      final list = orders.getOrdersForTab(widget.index);
      final sortedList = sortByDateDesc(list, tabModel.statusKey);

      // // ✅ Update ordersCount
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   if (orders.ordersCount.value != sortedList.length) {
      //     orders.ordersCount.value = sortedList.length;
      //   }
      // });

      final status = () {
        switch (widget.index) {
          case 0:
            return orders.activeOrdersStatus.value;
          case 1:
            return orders.confirmedOrdersStatus.value;
          case 2:
            return orders.completedOrdersStatus.value;
          case 3:
            return orders.cancelledOrdersStatus.value;
          default:
            return Status.IDLE;
        }
      }();

      if (status == Status.LOADING) return loadingIndicator();
      if (status == Status.FAILURE) return ErrorScreen();
      if (sortedList.isEmpty) {
        return EmptyScreen(
          icon: tabModel.icon,
          iconType: IconType.PNG,
          text: isRightLang
              ? '${tabModel.titleUrdu} لسٹ خالی ہے'
              : '${tabModel.titleEng} list is empty',
          color: AppColors.materialButtonSkin(isDark),
        );
      }

      return ListView.builder(
        controller: _scrollController,
        itemCount: sortedList.length,
        padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          final data = sortedList[i];
          return OrderItemUI(data: data, index: i + 1);
        },
      );
    });
  }
}
