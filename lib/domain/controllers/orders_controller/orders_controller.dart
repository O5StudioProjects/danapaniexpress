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
  final pendingFeedback = Get.find<PendingFeedbackController>();
  final nav = Get.find<NavigationController>();

  RxInt screenIndex = 0.obs;
  RxInt activeOrdersCount = 0.obs;
  // RxInt ordersCount = 0.obs;
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

  RxBool showBottomMessage = true.obs;
  RxBool reachedEndOfScroll = false.obs;

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

/*

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
*/



  // ===== ORDER STATUS LISTS =====
  // final String? userId = Get.find<AuthController>().currentUser.value!.userId;
// Active Orders
  RxList<OrderModel> activeOrders = <OrderModel>[].obs;
  Rx<Status> activeOrdersStatus = Status.IDLE.obs;
  int activeCurrentPage = 1;
  RxBool activeHasMore = true.obs;
  RxBool activeLoadingMore = false.obs;
  final int activeOrdersLimit = ORDERS_LIMIT;

// Confirmed Orders
  RxList<OrderModel> confirmedOrders = <OrderModel>[].obs;
  Rx<Status> confirmedOrdersStatus = Status.IDLE.obs;
  int confirmedCurrentPage = 1;
  RxBool confirmedHasMore = true.obs;
  RxBool confirmedLoadingMore = false.obs;
  final int confirmedOrdersLimit = ORDERS_LIMIT;

// Completed Orders
  RxList<OrderModel> completedOrders = <OrderModel>[].obs;
  Rx<Status> completedOrdersStatus = Status.IDLE.obs;
  int completedCurrentPage = 1;
  RxBool completedHasMore = true.obs;
  RxBool completedLoadingMore = false.obs;
  final int completedOrdersLimit = ORDERS_LIMIT;

// Cancelled Orders
  RxList<OrderModel> cancelledOrders = <OrderModel>[].obs;
  Rx<Status> cancelledOrdersStatus = Status.IDLE.obs;
  int cancelledCurrentPage = 1;
  RxBool cancelledHasMore = true.obs;
  RxBool cancelledLoadingMore = false.obs;
  final int cancelledOrdersLimit = ORDERS_LIMIT;


  List<OrderModel> getOrdersForTab(int index) {
    switch (index) {
      case 0: return activeOrders;
      case 1: return confirmedOrders;
      case 2: return completedOrders;
      case 3: return cancelledOrders;
      default: return [];
    }
  }

  void fetchOrdersForTab(int index) {
    switch (index) {
      case 0: fetchInitialActiveOrders(); break;
      case 1: fetchInitialConfirmedOrders(); break;
      case 2: fetchInitialCompletedOrders(); break;
      case 3: fetchInitialCancelledOrders(); break;
    }
  }

  void loadMoreOrdersForTab(int index) {
    switch (index) {
      case 0: loadMoreActiveOrders(); break;
      case 1: loadMoreConfirmedOrders(); break;
      case 2: loadMoreCompletedOrders(); break;
      case 3: loadMoreCancelledOrders(); break;
    }
  }

  RxBool getHasMoreForTab(int index) {
    switch (index) {
      case 0: return activeHasMore;
      case 1: return confirmedHasMore;
      case 2: return completedHasMore;
      case 3: return cancelledHasMore;
      default: return false.obs;
    }
  }

  RxBool getLoadingMoreForTab(int index) {
    switch (index) {
      case 0: return activeLoadingMore;
      case 1: return confirmedLoadingMore;
      case 2: return completedLoadingMore;
      case 3: return cancelledLoadingMore;
      default: return false.obs;
    }
  }



  // Method to get total count of Active orders for a user
  Future<void> getActiveOrdersCount() async {
    if(auth.currentUser.value!.userId == null){
      activeOrdersCount.value = 0;
    }else{
      try {
        // Fetch all active orders, without pagination (you can omit page/limit or pass null)
        final orders = await ordersRepo.getTotalOrdersCountByUserIdAndStatus(
          auth.currentUser.value!.userId!,
          OrderStatus.ACTIVE,
        );
        activeOrdersCount.value = orders;
        if (kDebugMode) {
          print('======================== ACTIVE ORDERS = ${activeOrdersCount.value}');
        }
      } catch (e) {
        // Handle error, maybe log or return 0 if failed
        debugPrint('Failed to get active orders Exception: $e');
        activeOrdersCount.value = 0;
      }
    }
  }


  /// ===== GENERIC METHOD FOR INITIAL FETCH =====
  Future<void> _fetchInitialOrdersByStatus({
    required String status,
    required RxList<OrderModel> targetList,
    required Rx<Status> targetStatus,
    required RxBool targetHasMore,
    required int orderLimit,
    required void Function(int) setCurrentPage,
  }) async {
    try {
      targetStatus.value = Status.LOADING;
      setCurrentPage(1);

      final fetchedOrders = await ordersRepo.getOrdersByUserIdAndStatus(
        userId: auth.currentUser.value!.userId!,
        orderStatus:  status,
        page: 1,
        limit: orderLimit,
      );

      targetList.assignAll(fetchedOrders);
      targetHasMore.value = fetchedOrders.length == orderLimit;
      targetStatus.value = Status.SUCCESS;
    } catch (e) {
      targetStatus.value = Status.FAILURE;
      if (kDebugMode) {
        print('Failed to load orders by status exception = $e');
      }
      //showSnackbar(isError: true, title: 'Error', message: 'Failed to load $status orders.');
    }
  }

  /// ===== GENERIC METHOD FOR LOAD MORE =====
  Future<void> _loadMoreOrdersByStatus({
    required String status,
    required RxList<OrderModel> targetList,
    required RxBool targetHasMore,
    required RxBool targetLoadingMore,
    required int currentPage,
    required int orderLimit,
    required void Function(int) setCurrentPage,
  }) async {
    if (targetLoadingMore.value || !targetHasMore.value) return;

    try {
      targetLoadingMore.value = true;
      final nextPage = currentPage + 1;
      setCurrentPage(nextPage);

      final moreOrders = await ordersRepo.getOrdersByUserIdAndStatus(
        userId: auth.currentUser.value!.userId!,
        orderStatus:  status,
        page: nextPage,
        limit: orderLimit,
      );

      targetList.addAll(moreOrders);

      if (moreOrders.length < orderLimit) {
        targetHasMore.value = false;
      }
    } catch (e) {
      setCurrentPage(currentPage); // rollback
      if (kDebugMode) {
        print('Failed to load more orders by status exception = $e');
      }
    } finally {
      targetLoadingMore.value = false;
    }
  }

  /// ===== PUBLIC METHODS FOR EACH STATUS =====

// Active
  Future<void> fetchInitialActiveOrders() => _fetchInitialOrdersByStatus(
    status: OrderStatus.ACTIVE,
    targetList: activeOrders,
    targetStatus: activeOrdersStatus,
    targetHasMore: activeHasMore,
    orderLimit: activeOrdersLimit,
    setCurrentPage: (val) => activeCurrentPage = val,
  );

  Future<void> loadMoreActiveOrders() => _loadMoreOrdersByStatus(
    status: OrderStatus.ACTIVE,
    targetList: activeOrders,
    targetHasMore: activeHasMore,
    targetLoadingMore: activeLoadingMore,
    currentPage: activeCurrentPage,
    orderLimit: activeOrdersLimit,
    setCurrentPage: (val) => activeCurrentPage = val,
  );

// Confirmed
  Future<void> fetchInitialConfirmedOrders() => _fetchInitialOrdersByStatus(
    status: OrderStatus.CONFIRMED,
    targetList: confirmedOrders,
    targetStatus: confirmedOrdersStatus,
    targetHasMore: confirmedHasMore,
    orderLimit: confirmedOrdersLimit,
    setCurrentPage: (val) => confirmedCurrentPage = val,
  );

  Future<void> loadMoreConfirmedOrders() => _loadMoreOrdersByStatus(
    status: OrderStatus.CONFIRMED,
    targetList: confirmedOrders,
    targetHasMore: confirmedHasMore,
    targetLoadingMore: confirmedLoadingMore,
    currentPage: confirmedCurrentPage,
    orderLimit: confirmedOrdersLimit,
    setCurrentPage: (val) => confirmedCurrentPage = val,
  );

// Completed
  Future<void> fetchInitialCompletedOrders() => _fetchInitialOrdersByStatus(
    status: OrderStatus.COMPLETED,
    targetList: completedOrders,
    targetStatus: completedOrdersStatus,
    targetHasMore: completedHasMore,
    orderLimit: completedOrdersLimit,
    setCurrentPage: (val) => completedCurrentPage = val,
  );

  Future<void> loadMoreCompletedOrders() => _loadMoreOrdersByStatus(
    status: OrderStatus.COMPLETED,
    targetList: completedOrders,
    targetHasMore: completedHasMore,
    targetLoadingMore: completedLoadingMore,
    currentPage: completedCurrentPage,
    orderLimit: completedOrdersLimit,
    setCurrentPage: (val) => completedCurrentPage = val,
  );

// Cancelled
  Future<void> fetchInitialCancelledOrders() => _fetchInitialOrdersByStatus(
    status: OrderStatus.CANCELLED,
    targetList: cancelledOrders,
    targetStatus: cancelledOrdersStatus,
    targetHasMore: cancelledHasMore,
    orderLimit: cancelledOrdersLimit,
    setCurrentPage: (val) => cancelledCurrentPage = val,
  );

  Future<void> loadMoreCancelledOrders() => _loadMoreOrdersByStatus(
    status: OrderStatus.CANCELLED,
    targetList: cancelledOrders,
    targetHasMore: cancelledHasMore,
    targetLoadingMore: cancelledLoadingMore,
    currentPage: cancelledCurrentPage,
    orderLimit: cancelledOrdersLimit,
    setCurrentPage: (val) => cancelledCurrentPage = val,
  );




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
        await fetchInitialActiveOrders();
        await getActiveOrdersCount();
        updateOrderStatus.value = Status.SUCCESS;
        showToast('${AppLanguage.orderCancelledSuccessfullyStr(appLanguage)}');

      } else {
        updateOrderStatus.value = Status.FAILURE;
        showToast('${AppLanguage.orderCancelledFailedStr(appLanguage)}');

        if (kDebugMode) {
          print('ORDER UPDATE FAILED ERROR : ${result['message']}');
        }

      }
    } catch (e) {
      updateOrderStatus.value = Status.FAILURE;
      showToast('${AppLanguage.somethingWentWrongStr(appLanguage)}');
      if (kDebugMode) {
        print('ORDER UPDATE FAILED Exception : $e');
      }
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
      showToast('${AppLanguage.somethingWentWrongStr(appLanguage)}');
      if (kDebugMode) {
        print('Fetch order by number Exception : $e');
      }
    }
  }


  /// ON BUTTON SECTION OF ORDER DETAILS
  Future<void> onTapButtonSectionsOrderTap() async {
    if(selectedOrder.value!.orderStatus == OrderStatus.CONFIRMED){

      showSnackbar(title: '${AppLanguage.orderConfirmedNonCancellableStr(appLanguage)}', message: '${AppLanguage.contactCustomerServiceToCancelStr(appLanguage)}');

    } else if(selectedOrder.value!.orderStatus == OrderStatus.COMPLETED){
      if(selectedOrder.value!.orderFeedback == null ){
        nav.gotoOrdersFeedbackScreen(orderModel: selectedOrder.value!);
      }

    } else if(selectedOrder.value!.orderStatus == OrderStatus.ACTIVE){
      showCustomDialog(gContext, AppBoolDialog(
          title: '${AppLanguage.cancelOrderStr(appLanguage)}',
          detail: '${AppLanguage.doYouWantToCancelOrderStr(appLanguage)}',
          iconType: IconType.ICON,
        icon: Icons.cancel_rounded,
        onTapConfirm: (){
            Navigator.of(gContext).pop();
            updateOrder(orderId: selectedOrder.value!.orderId!, riderId: selectedOrder.value!.riderId, orderNumber: selectedOrder.value!.orderNumber, orderStatus: OrderStatus.CANCELLED);
        },
      ));

    }
  }

  void clearOrders() {
    activeOrders.clear();
    confirmedOrders.clear();
    completedOrders.clear();
    cancelledOrders.clear();
    activeOrdersStatus.value = Status.IDLE;
    confirmedOrdersStatus.value = Status.IDLE;
    completedOrdersStatus.value = Status.IDLE;
    cancelledOrdersStatus.value = Status.IDLE;
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
        await pendingFeedback.fetchCompletedOrdersWithoutFeedback();
        insertFeedbackStatus.value = Status.SUCCESS;
        clearFeedbackKeys();
        nav.gotoOrdersFeedbackCompleteScreen(orderModel: selectedOrder.value!);


    } else {
        insertFeedbackStatus.value = Status.FAILURE;
        showToast('${AppLanguage.failedToSubmitFeedbackStr(appLanguage)}');
        if (kDebugMode) {
          print('Failed to submit feedback Error : ${result['message']}');
        }
      }
    } catch (e) {
      insertFeedbackStatus.value = Status.FAILURE;
      showToast('${AppLanguage.somethingWentWrongStr(appLanguage)}');
      if (kDebugMode) {
        print('Failed to submit feedback Exception : $e');
      }

    }
  }

  void updateFeedbackIndex(index, text) {
    feedbackItemIndex.value = index;
    feedbackItemText.value = text;
  }

  Future<void> onSubmitFeedback() async {
    if (feedbackItemText.value.isEmpty) {
      showSnackbar(
          title: '${AppLanguage.serviceRatingStr(appLanguage)}', message: '${AppLanguage.pleaseSelectServiceRatingStr(appLanguage)}');
      return;
    }
    if (riderRating.value == 0.0) {
      showSnackbar(
          title: '${AppLanguage.rateRiderStr(appLanguage)}', message: '${AppLanguage.pleaseRateRiderStr(appLanguage)}');
      return;
    }
    if (isPositive.value == false && isNegative.value == false) {
      showSnackbar(title: '${AppLanguage.experienceStr(appLanguage)}',
          message: '${AppLanguage.pleaseLikeOrDislikeStr(appLanguage)}');
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
        if (kDebugMode) {
          print('Rider rating updated successfully');
        }
      } else {
        updateRatingStatus.value = Status.FAILURE;
        if (kDebugMode) {
          print('Rider rating update FAILED ERROR : ${result['message']}');
        }
      }
    } catch (e) {
      updateRatingStatus.value = Status.FAILURE;
      if (kDebugMode) {
        print('Rider rating update FAILED Exception : $e');
      }
    }
  }


}