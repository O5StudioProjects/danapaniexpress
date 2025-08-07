import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/domain/controllers/orders_controller/orders_controller.dart';
import 'package:danapaniexpress/ui/app_common/components/app_pull_to_refresh.dart';
import 'package:danapaniexpress/ui/screens/pages/account/my_orders/widgets/order_item.dart';

import '../../../../../data/models/order_model.dart';

class MyOrdersMobile extends StatelessWidget {
  const MyOrdersMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = Get.find<OrdersController>();
    orders.screenIndex.value = Get.arguments[ORDERS_INDEX]  ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      orders.fetchInitialOrders();
      orders.pageController.jumpToPage(orders.screenIndex.value);
    });

    return Obx((){
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(title: AppLanguage.myOrdersStr(appLanguage), isBackNavigation: true),
            if (orders.ordersStatus.value != Status.LOADING)
            Container(
              color: AppColors.cardColorSkin(isDark),
              padding: EdgeInsets.all(4.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      final currentIndex = orders.screenIndex.value;
                      final currentTab = orderTabsModelList[currentIndex];
                      return appText(
                        text: 'Total ${currentTab.titleEng} Orders',
                        textStyle: itemTextStyle(),
                      );
                    }),
                    Spacer(),
                    Obx(() {
                      final currentIndex = orders.screenIndex.value;
                      final currentList = orders.getOrdersForTab(currentIndex);
                      return appText(
                        text: '${currentList.length}',
                        textStyle: bodyTextStyle(),
                      );
                    }),

                  ],
                ),
              ),
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
                    padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
                    child: OrdersListForTab(index: index),
                  );
                },
              ),
            ),

            /// SHOW BOTTOM MESSAGE /LOADING INDICATOR
            Obx(() {
              final isLoadingMore = orders.isLoadingMore.value;
              final hasMore = orders.hasMoreOrders.value;
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

              return SizedBox(); // nothing to show
            })
          ],
        ),
      );
    });


  }
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
  }

  void _scrollListener() {
    final currentOffset = _scrollController.position.pixels;
    final maxOffset = _scrollController.position.maxScrollExtent;

    // ✅ Bottom message visibility
    if (currentOffset > _previousOffset) {
      orders.showBottomMessage.value = true;
    } else {
      orders.showBottomMessage.value = false;
    }

    // ✅ End of scroll detection
    orders.reachedEndOfScroll.value = currentOffset >= maxOffset - 10;

    // // ✅ Load more trigger
    if (currentOffset >= maxOffset - 200) {
      if (orders.hasMoreOrders.value && !orders.isLoadingMore.value) {
        orders.loadMoreOrders();
      }
    }

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (orders.ordersStatus.value == Status.LOADING) {
        return loadingIndicator();
      }

      final tabModel = orderTabsModelList[widget.index];
      final list = orders.getOrdersForTab(widget.index);
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
        controller: _scrollController,
        itemCount: sortedList.length,
        padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, i) {
            final data = sortedList[i];
            orders.ordersCount.value = sortedList.length;
            return OrderItemUI(data: data, index: i + 1);
        },
      );
    });
  }
}
