import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

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
      var orderTabsModelList = [
        OrderTabsModel(
          icon: icOrderActive,
          title: AppLanguage.activeStr(appLanguage).toString(),
          statusKey: 'Active', // ← Add this
        ),
        OrderTabsModel(
          icon: icOrderConfirmed,
          title: AppLanguage.confirmedStr(appLanguage).toString(),
          statusKey: 'Confirmed',
        ),
        OrderTabsModel(
          icon: icOrderCompleted,
          title: AppLanguage.completedStr(appLanguage).toString(),
          statusKey: 'Completed',
        ),
        OrderTabsModel(
          icon: icOrderCancel,
          title: AppLanguage.cancelledStr(appLanguage).toString(),
          statusKey: 'Cancelled',
        ),
      ];

      final tabModel = orderTabsModelList[widget.index];
      final list = orders.getOrdersForTab(widget.index);
      final sortedList = sortByDateDesc(list, tabModel.statusKey);

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
          text: AppLanguage.noOrdersStr(appLanguage).toString(),
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