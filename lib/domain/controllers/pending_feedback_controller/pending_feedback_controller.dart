

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/data/models/order_model.dart';
import 'package:danapaniexpress/data/repositories/pending_feedback_repository/pending_feedback_repository.dart';
import 'package:danapaniexpress/domain/controllers/auth_controller/auth_controller.dart';

class PendingFeedbackController extends GetxController {

  final pendingFeedbackRepo = PendingFeedbackRepository();
  final auth = Get.find<AuthController>();


  RxString searchQuery = ''.obs;
  double _previousOffset = 0;
  RxBool showBottomMessage = true.obs;
  RxBool reachedEndOfScroll = false.obs;
  /// Scroll Controller
  final ScrollController scrollController = ScrollController();




  /// FETCH ORDERS OF USER WITHOUT FEEDBACK COMPLETED
  // Observables
  var completedOrdersWithoutFeedback = <OrderModel>[].obs;

  Rx<Status> ordersWithoutFeedbackStatus = Status.IDLE.obs;
  var isLoadingMoreOrdersWithoutFeedback = false.obs;
  var hasMoreOrdersWithoutFeedback = true.obs;
  var ordersWithoutFeedbackCurrentPage = 1.obs;

  final int _ordersWithoutFeedbackLimit = ORDERS_LIMIT;


  @override
  void onInit() {
    super.onInit();
    setupScrollListener();
  }


  void setupScrollListener() {
    scrollController.addListener(() {

      final currentOffset = scrollController.position.pixels;
      final maxOffset = scrollController.position.maxScrollExtent;

      // ✅ Bottom message visibility
      showBottomMessage.value = currentOffset > _previousOffset;

      // ✅ End of scroll detection
      reachedEndOfScroll.value = currentOffset >= maxOffset - 10;

      // ✅ Load more trigger (per tab)

      if (currentOffset >= maxOffset - 200 && hasMoreOrdersWithoutFeedback.value && !isLoadingMoreOrdersWithoutFeedback.value) {
        loadMoreCompletedOrdersWithoutFeedback();
      }
      _previousOffset = currentOffset;
    });
  }


  /// INITIAL FETCH
  Future<void> fetchCompletedOrdersWithoutFeedback() async {
    if(auth.currentUser.value!.userId != null){
      ordersWithoutFeedbackStatus.value = Status.LOADING;
      ordersWithoutFeedbackCurrentPage.value = 1;
      hasMoreOrdersWithoutFeedback.value = true;
      completedOrdersWithoutFeedback.clear();

      try {
        final orders = await pendingFeedbackRepo.getCompletedOrdersWithoutFeedback(
          userId: auth.currentUser.value!.userId!,
          page: ordersWithoutFeedbackCurrentPage.value,
          limit: _ordersWithoutFeedbackLimit,
        );

        completedOrdersWithoutFeedback.assignAll(orders);
        hasMoreOrdersWithoutFeedback.value = orders.length == _ordersWithoutFeedbackLimit;

        ordersWithoutFeedbackStatus.value = Status.SUCCESS;
      } catch (e) {
        ordersWithoutFeedbackStatus.value = Status.FAILURE;
        showSnackbar(
          isError: true,
          title: 'Error',
          message: 'Failed to load orders: $e',
        );
      }
    } else if (kDebugMode) {
      print('==============user is not logged in for feedback orders');
    }

  }

  /// LOAD MORE
  Future<void> loadMoreCompletedOrdersWithoutFeedback() async {
    if (isLoadingMoreOrdersWithoutFeedback.value || !hasMoreOrdersWithoutFeedback.value) return;

    isLoadingMoreOrdersWithoutFeedback.value = true;
    ordersWithoutFeedbackCurrentPage.value++;

    try {
      final moreOrders = await pendingFeedbackRepo.getCompletedOrdersWithoutFeedback(
        userId: auth.currentUser.value!.userId!,
        page: ordersWithoutFeedbackCurrentPage.value,
        limit: _ordersWithoutFeedbackLimit,
      );

      if (moreOrders.isEmpty) {
        hasMoreOrdersWithoutFeedback.value = false;
      } else {
        completedOrdersWithoutFeedback.addAll(moreOrders);
        if (moreOrders.length < _ordersWithoutFeedbackLimit) {
          hasMoreOrdersWithoutFeedback.value = false;
        }
      }
    } catch (e) {
      showSnackbar(
        isError: true,
        title: 'Error',
        message: 'Failed to load more orders: $e',
      );
    } finally {
      isLoadingMoreOrdersWithoutFeedback.value = false;
    }
  }

}