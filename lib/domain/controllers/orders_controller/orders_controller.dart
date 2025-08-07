import 'package:confetti/confetti.dart';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/data/repositories/orders_repository/orders_repository.dart';
import 'package:danapaniexpress/ui/app_common/dialogs/bool_dialog.dart';

import '../../../data/models/order_model.dart';

class OrdersController extends GetxController {
  final scrollController = ScrollController();
  final pageController = PageController();
  final ordersRepo = OrdersRepository();

  final auth = Get.find<AuthController>();
  final nav = Get.find<NavigationController>();

  RxInt screenIndex = 0.obs;
  RxInt ordersCount = 0.obs;
  var updateOrderStatus = Status.IDLE.obs;
  var getOrderByNumberStatus = Status.IDLE.obs;
  var insertFeedbackStatus = Status.IDLE.obs;
  var updateRatingStatus = Status.IDLE.obs;


  var selectedOrder = Rx<OrderModel?>(null);


  /// FEEDBACK SECTION
  RxInt feedbackItemIndex = 0.obs;
  RxString feedbackItemText = ''.obs;
  RxDouble riderRating = 0.0.obs;
  RxBool isPositive = false.obs;
  RxBool isNegative = false.obs;
  var feedbackTextController = TextEditingController().obs;


  /// SCROLLER AND PAGER SECTION FOR MY ORDER SCREEN
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


  /// ORDER SECTION
  RxList<OrderModel> ordersList = <OrderModel>[].obs;
  Rx<Status> ordersStatus = Status.IDLE.obs;
  final int ordersLimit = ORDERS_LIMIT;
  int currentPage = 1;

  RxBool hasMoreOrders = true.obs;
  RxBool isLoadingMore = false.obs;
  RxBool showBottomMessage = true.obs;
  RxBool reachedEndOfScroll = false.obs;
  final String userId = Get.find<AuthController>().currentUser.value!.userId!;

  /// INITIAL FETCH
  Future<void> fetchInitialOrders() async {
    try {
      ordersStatus.value = Status.LOADING;
      currentPage = 1;

      final List<OrderModel> fetchedOrders =
      await ordersRepo.getOrdersByUserId(userId, page: currentPage, limit: ordersLimit);

      ordersList.clear();
      ordersList.assignAll(fetchedOrders);

      hasMoreOrders.value = fetchedOrders.length == ordersLimit;
      ordersStatus.value = Status.SUCCESS;
    } catch (e) {
      ordersStatus.value = Status.FAILURE;
      showSnackbar(isError: true, title: 'Error', message: 'Failed to load orders.');
    }
  }

  /// LOAD MORE
  Future<void> loadMoreOrders() async {
    if (isLoadingMore.value || !hasMoreOrders.value) return;

    try {
      isLoadingMore.value = true;
      currentPage++;

      final List<OrderModel> moreOrders =
      await ordersRepo.getOrdersByUserId(userId, page: currentPage, limit: ordersLimit);

      ordersList.addAll(moreOrders);

      if (moreOrders.length < ordersLimit) {
        hasMoreOrders.value = false;
      }
    } catch (e) {
      currentPage--; // rollback on failure
      showSnackbar(isError: true, title: 'Error', message: 'Failed to load more orders.');
    } finally {
      isLoadingMore.value = false;
    }
  }


/*  /// ORDER SECTION THIS CODE WILL BE USED IN ADMIN APP
  RxList<OrderModel> ordersList = <OrderModel>[].obs;
  Rx<Status> ordersStatus = Status.IDLE.obs;
  final int ordersLimit = ORDERS_LIMIT;
  int currentPage = 1;

  RxBool hasMoreOrders = true.obs;
  RxBool isLoadingMore = false.obs;
  /// INITIAL FETCH
  Future<void> fetchInitialOrders() async {
    try {
      ordersStatus.value = Status.LOADING;
      currentPage = 1;

      final result = await ordersRepo.getAllOrders(currentPage, ordersLimit);
      final List<OrderModel> fetchedOrders = result['orders'];

      ordersList.clear();
      ordersList.assignAll(fetchedOrders);

      hasMoreOrders.value = fetchedOrders.length == ordersLimit;
      ordersStatus.value = Status.SUCCESS;
    } catch (e) {
      ordersStatus.value = Status.FAILURE;
      showSnackbar(isError: true, title: 'Error', message: 'Failed to load orders.');
    }
  }
  /// LOAD MORE
  Future<void> loadMoreOrders() async {
    if (isLoadingMore.value || !hasMoreOrders.value) return;

    try {
      isLoadingMore.value = true;
      currentPage++;

      final result = await ordersRepo.getAllOrders(currentPage, ordersLimit);
      final List<OrderModel> moreOrders = result['orders'];

      ordersList.addAll(moreOrders);

      if (moreOrders.length < ordersLimit) {
        hasMoreOrders.value = false;
      }
    } catch (e) {
      currentPage--; // rollback on failure
      showSnackbar(isError: true, title: 'Error', message: 'Failed to load more orders.');
    } finally {
      isLoadingMore.value = false;
    }
  }*/



  // Future<void> getOrdersByUserId() async {
  //   var userId = auth.currentUser.value!.userId!;
  //   try {
  //     ordersStatus.value = Status.LOADING;
  //     final orders = await ordersRepo.getOrdersByUserId(userId);
  //     ordersList.assignAll(orders);
  //     ordersStatus.value = Status.SUCCESS;
  //   } catch (e) {
  //     ordersStatus.value = Status.FAILURE;
  //     print("Exception : $e");
  //     showSnackbar(
  //       isError: true,
  //       title: 'Failed',
  //       message: 'Could not fetch orders: ${e.toString()}',
  //     );
  //   }
  // }

  /// UPDATE ORDER
  Future<void> updateOrder({
    required String orderId,
    String? riderId,
    String? orderStatus,
    String? orderNumber,
  }) async {
    try {
      updateOrderStatus.value = Status.LOADING;

      final result = await ordersRepo.updateOrder(
        orderId: orderId,
        riderId: riderId,
        orderStatus: orderStatus,
      );

      if (result['status'] == 'success') {
        if (orderNumber != null || orderNumber!.isNotEmpty) {
          await fetchOrderByNumber(orderNumber);
        }
        await fetchInitialOrders();
        updateOrderStatus.value = Status.SUCCESS;
        showSnackbar(
          isError: false,
          title: 'Success',
          message: result['message'] ?? 'Order updated successfully',
        );
      } else {
        updateOrderStatus.value = Status.FAILURE;
        showSnackbar(
          isError: true,
          title: 'Error',
          message: result['message'] ?? 'Update failed',
        );
      }
    } catch (e) {
      updateOrderStatus.value = Status.FAILURE;
      showSnackbar(
        isError: true,
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  /// GET ORDER BY ORDER NUMBER
  Future<void> fetchOrderByNumber(String orderNumber) async {
    try {
      getOrderByNumberStatus.value = Status.LOADING;

      final order = await ordersRepo.getOrderByNumber(orderNumber);
      selectedOrder.value = order;

      getOrderByNumberStatus.value = Status.SUCCESS;
    } catch (e) {
      getOrderByNumberStatus.value = Status.FAILURE;
      showSnackbar(
        isError: true,
        title: 'Error',
        message: e.toString(),
      );
    }
  }


  /// ON BUTTON SECTION OF ORDER DETAILS
  Future<void> onTapButtonSectionsOrderTap() async {
    if(selectedOrder.value!.orderStatus == OrderStatus.CONFIRMED){

      showSnackbar(title: 'Order confirmed non cancelable', message: 'Please contact our customer service to cancel confirmed order.');

    } else if(selectedOrder.value!.orderStatus == OrderStatus.COMPLETED){
      if(selectedOrder.value!.orderFeedback == null ){
        nav.gotoOrdersFeedbackScreen(orderModel: selectedOrder.value!);
      }

    } else if(selectedOrder.value!.orderStatus == OrderStatus.ACTIVE){
      showCustomDialog(gContext, AppBoolDialog(
          title: 'Cancel Order',
          detail: 'Do you want to cancel order?',
          iconType: IconType.ICON,
        icon: Icons.cancel_rounded,
        onTapConfirm: (){
            Navigator.of(gContext).pop();
            updateOrder(orderId: selectedOrder.value!.orderId!, orderNumber: selectedOrder.value!.orderNumber, orderStatus: OrderStatus.CANCELLED);
        },
      ));

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


  /// FEEDBACK SECTION
  /// INSERT ORDER FEEDBACK
  Future<void> insertOrderFeedback({
    required String userId,
    required String orderId,
    required String orderNumber,
    required bool isPositive,
    required bool isNegative,
    required String feedBackType,
    required String feedBackDetail,
  }) async {
    try {
      insertFeedbackStatus.value = Status.LOADING;

      final result = await ordersRepo.insertOrderFeedback(
        userId: userId,
        orderId: orderId,
        orderNumber: orderNumber,
        isPositive: isPositive,
        isNegative: isNegative,
        feedBackType: feedBackType,
        feedBackDetail: feedBackDetail,
      );

      if (result['status'] == true) {
        await updateRiderRating(
            riderId: selectedOrder.value!.riderId!,
            riderRating: riderRating.value
        );
        await fetchOrderByNumber(orderNumber);
        insertFeedbackStatus.value = Status.SUCCESS;
        showSnackbar(
          isError: false,
          title: 'Success',
          message: result['message'] ?? 'Feedback submitted successfully',
        );
        clearFeedbackKeys();
        nav.gotoOrdersFeedbackCompleteScreen(orderModel: selectedOrder.value!);


    } else {
        insertFeedbackStatus.value = Status.FAILURE;
        showSnackbar(
          isError: true,
          title: 'Error',
          message: result['message'] ?? 'Failed to submit feedback',
        );
      }
    } catch (e) {
      insertFeedbackStatus.value = Status.FAILURE;
      showSnackbar(
        isError: true,
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  void updateFeedbackIndex(index, text) {
    feedbackItemIndex.value = index;
    feedbackItemText.value = text;
  }

  Future<void> onSubmitFeedback() async {
    if (feedbackItemText.value.isEmpty) {
      showSnackbar(
          title: 'Service rating', message: 'Please select service rating');
      return;
    }
    if (riderRating.value == 0.0) {
      showSnackbar(
          title: 'Rate rider', message: 'Please rate our rider from 1-5');
      return;
    }
    if (isPositive.value == false && isNegative.value == false) {
      showSnackbar(title: 'Experience',
          message: 'Please Like or Dislike to share your experience with us.');
      return;
    }

    await insertOrderFeedback(
        userId: auth.currentUser.value!.userId!,
        orderId: selectedOrder.value!.orderId!,
        orderNumber: selectedOrder.value!.orderNumber!,
        isPositive: isPositive.value,
        isNegative: isNegative.value,
        feedBackType: feedbackItemText.value,
        feedBackDetail: feedbackTextController.value.text.trim()
    );
  }

  void clearFeedbackKeys(){
    isPositive.value = false;
    isNegative.value = false;
    feedbackItemText.value = '';
    feedbackItemIndex.value = 10;
    riderRating.value = 0.0;
    feedbackTextController.value.clear();
  }

  /// UPDATE RIDER RATING ONLY
  Future<void> updateRiderRating({
    required String riderId,
    required double riderRating,
  }) async {
    try {
      updateRatingStatus.value = Status.LOADING;

      final result = await ordersRepo.updateRiderRating(
        riderId: riderId,
        riderRating: riderRating,
      );

      if (result['status'] == true) {
        updateRatingStatus.value = Status.SUCCESS;
        showSnackbar(
          isError: false,
          title: 'Success',
          message: result['message'] ?? 'Rider rating updated successfully',
        );
      } else {
        updateRatingStatus.value = Status.FAILURE;
        showSnackbar(
          isError: true,
          title: 'Error',
          message: result['message'] ?? 'Failed to update rider rating',
        );
      }
    } catch (e) {
      updateRatingStatus.value = Status.FAILURE;
      showSnackbar(
        isError: true,
        title: 'Error',
        message: e.toString(),
      );
    }
  }


}