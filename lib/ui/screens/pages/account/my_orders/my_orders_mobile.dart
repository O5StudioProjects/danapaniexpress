import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

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
      var orderTabsModelList = [
        OrderTabsModel(
          icon: icOrderActive,
          title: AppLanguage.activeStr(appLanguage).toString(),
          statusKey: OrderStatus.ACTIVE, // ← Add this
        ),
        OrderTabsModel(
          icon: icOrderConfirmed,
          title: AppLanguage.confirmedStr(appLanguage).toString(),
          statusKey: OrderStatus.CONFIRMED,
        ),
        OrderTabsModel(
          icon: icOrderCompleted,
          title: AppLanguage.completedStr(appLanguage).toString(),
          statusKey: OrderStatus.COMPLETED,
        ),
        OrderTabsModel(
          icon: icOrderCancel,
          title: AppLanguage.cancelledStr(appLanguage).toString(),
          statusKey: OrderStatus.CANCELLED,
        ),
      ];
      return _buildUI(orders, nav, orderTabsModelList);
    });
  }

  Widget _buildUI(orders, nav, orderTabsModelList) {
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          _appBar(nav),
          MyOrders(ordersScreen: true),
          _pageViewBuilder(orders,orderTabsModelList),
          /// SHOW BOTTOM MESSAGE / LOADING INDICATOR
          _bottomMessages(orders),
        ],
      ),
    );
  }

  Widget _appBar(nav) {
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      child: appBarCommon(
        title: AppLanguage.myOrdersStr(appLanguage),
        isBackNavigation: true,
        isTrailing: true,
        trailingIcon: icSearch,
        trailingIconType: IconType.SVG,
        trailingOnTap: () => nav.gotoOrdersFilterScreen(),
      ),
    );
  }

  Widget _pageViewBuilder(orders, orderTabsModelList) {
    return Expanded(
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
    );
  }

  Widget _bottomMessages(orders){
    return Obx(() {
      final tabIndex = orders.screenIndex.value; // or widget.index if passed
      final isLoadingMore = orders.getLoadingMoreForTab(tabIndex).value;
      final hasMore = orders.getHasMoreForTab(tabIndex).value;
      final reachedEnd = orders.reachedEndOfScroll.value;

      return  BottomMessagesSection(
          isLoadingMore: isLoadingMore,
          hasMore: hasMore,
          reachedEnd: reachedEnd,
          message: AppLanguage.noMoreOrdersStr(appLanguage).toString());

    });
  }

}




