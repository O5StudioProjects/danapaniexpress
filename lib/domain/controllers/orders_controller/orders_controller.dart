
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/data/repositories/orders_repository/orders_repository.dart';

import '../../../data/models/order_model.dart';

class OrdersController extends GetxController {
  final scrollController = ScrollController();
  final pageController = PageController(); // ⬅️ Add this for PageView

  final ordersRepo = OrdersRepository();
  final auth = Get.find<AuthController>();
  RxInt screenIndex = 0.obs;

  @override
  void onInit() {
    getOrdersByUserId();
    super.onInit();
  }

  void scrollToIndex() {
    final itemWidth = 120.0;
    final offset = (itemWidth * screenIndex.value).clamp(
      0.0,
      scrollController.position.maxScrollExtent,
    );

    scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void updateTabIndex(int index) {
    screenIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    scrollToIndex(); // scroll horizontal tab bar
  }

  void onPageChanged(int index) {
    screenIndex.value = index;
    scrollToIndex(); // keep horizontal tab bar in sync
  }


  RxList<OrderModel> ordersList = <OrderModel>[].obs;
  Rx<Status> ordersStatus = Status.IDLE.obs;

  Future<void> getOrdersByUserId() async {
    var userId = auth.currentUser.value!.userId!;
    try {
      ordersStatus.value = Status.LOADING;
      final orders = await ordersRepo.getOrdersByUserId(userId);
      ordersList.assignAll(orders);
      ordersStatus.value = Status.SUCCESS;
    } catch (e) {
      ordersStatus.value = Status.FAILURE;
      print("Exception : $e");
      showSnackbar(
        isError: true,
        title: 'Failed',
        message: 'Could not fetch orders: ${e.toString()}',
      );
    }
  }

  void clearOrders() {
    ordersList.clear();
    ordersStatus.value = Status.IDLE;
  }
  /// Helper method to filter orders by current tab index
  List<OrderModel> getOrdersForTab(int index) {
    final tab = orderTabsModelList[index];

    if (tab.statusKey.isEmpty) return [];

    return ordersList
        .where((order) => order.orderStatus == tab.statusKey)
        .toList();
  }

}