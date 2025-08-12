

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/data/repositories/orders_repository/orders_filter_repository.dart';

import '../../../data/models/order_model.dart';
import '../auth_controller/auth_controller.dart';

class FilterOrdersController extends GetxController {

  final filterOrderRepo = FilterOrdersRepository();
  var auth = Get.find<AuthController>();

  RxString selectedFilterOption = OrdersFilter.SPECIFIC_DATE.obs;
  var orderNumber = ''.obs;

  RxString selectedDate = ''.obs;
  RxString startDate = ''.obs;
  RxString endDate = ''.obs;
  RxBool showBottomMessage = true.obs;
  RxBool reachedEndOfScroll = false.obs;

  final String userId = Get.find<AuthController>().currentUser.value!.userId!;

  /// Orders list
  RxList<OrderModel> ordersList = <OrderModel>[].obs;

  /// Status
  Rx<Status> ordersStatus = Status.IDLE.obs;

  /// Pagination config
  final int ordersLimit = ORDERS_LIMIT;
  int currentPage = 1;

  /// State variables
  RxBool hasMoreOrders = true.obs;
  RxBool isLoadingMore = false.obs;
  double _previousOffset = 0;

  /// Scroll Controller
  final ScrollController scrollController = ScrollController();

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

      if (currentOffset >= maxOffset - 200 && hasMoreOrders.value && !isLoadingMore.value) {
        if(selectedFilterOption.value == OrdersFilter.SPECIFIC_DATE){
          loadMoreOrders(startDate: selectedDate.value, endDate: null, orderNumber: null);
        }
        if(selectedFilterOption.value == OrdersFilter.DATE_RANGE){
          loadMoreOrders(startDate: startDate.value, endDate: endDate.value, orderNumber: null);
        }
      }
      _previousOffset = currentOffset;
    });
  }

  /// INITIAL FETCH (with filters)
  Future<void> fetchInitialOrders({String? startDate, String? endDate, String? orderNumber}) async {
    try {
      ordersStatus.value = Status.LOADING;
      currentPage = 1;

      final List<OrderModel> fetchedOrders =
      await filterOrderRepo.getOrdersByUserIdAndDate(
        userId,
        page: currentPage,
        limit: ordersLimit,
        startDate: startDate,
        endDate: endDate,
        orderNumber: orderNumber,
      );

      ordersList.clear();
      ordersList.assignAll(fetchedOrders);

      hasMoreOrders.value = fetchedOrders.length == ordersLimit;
      ordersStatus.value = Status.SUCCESS;
    } catch (e) {
      ordersStatus.value = Status.FAILURE;
      showSnackbar(
        isError: true,
        title: 'Error',
        message: 'Failed to load orders.',
      );
    }
  }

  /// LOAD MORE (pagination)
  Future<void> loadMoreOrders({String? startDate, String? endDate, String? orderNumber}) async {
    if (isLoadingMore.value || !hasMoreOrders.value) return;

    try {
      isLoadingMore.value = true;
      currentPage++;

      final List<OrderModel> moreOrders =
      await filterOrderRepo.getOrdersByUserIdAndDate(
        userId,
        page: currentPage,
        limit: ordersLimit,
        startDate: startDate,
        endDate: endDate,
        orderNumber: orderNumber,
      );

      ordersList.addAll(moreOrders);

      if (moreOrders.length < ordersLimit) {
        hasMoreOrders.value = false;
      }
    } catch (e) {
      currentPage--; // rollback
      showSnackbar(
        isError: true,
        title: 'Error',
        message: 'Failed to load more orders.',
      );
    } finally {
      isLoadingMore.value = false;
    }
  }


  Future<void> onTapSearchButton() async {

    if(selectedFilterOption.value == OrdersFilter.SPECIFIC_DATE){
      if(selectedDate.value.isEmpty){
        showSnackbar(
          isError: true,
            title: AppLanguage.selectDateStr(appLanguage).toString(),
            message: AppLanguage.selectSpecificDateFromCalendarStr(appLanguage).toString());
        return;
      }
      fetchInitialOrders(startDate: selectedDate.value, endDate: null, orderNumber: null);
    }
    else if(selectedFilterOption.value == OrdersFilter.DATE_RANGE){
      if(startDate.value.isEmpty){
        showSnackbar(
            isError: true,
            title: AppLanguage.selectStartDateStr(appLanguage).toString(),
            message: AppLanguage.selectStartDateFromCalendarStr(appLanguage).toString());
      } else if(endDate.value.isEmpty){
        showSnackbar(
            isError: true,
            title: AppLanguage.selectEndDateStr(appLanguage).toString(),
            message: AppLanguage.selectEndDateFromCalendarStr(appLanguage).toString());
      } else {
        fetchInitialOrders(startDate: startDate.value, endDate: endDate.value, orderNumber: null);

      }
    } else {
      showSnackbar(
          isError: true,
          title: AppLanguage.selectFilterOptionStr(appLanguage).toString(),
          message: AppLanguage.selectFilterOptionToSearchOrdersStr(appLanguage).toString());
    }
  }




  /// RESET FILTERS
  void resetFilters() {
    startDate.value = '';
    endDate.value = '';
    selectedFilterOption.value = OrdersFilter.ORDER_NUMBER;
  }




  clearFilters(){
    selectedDate.value = '';
    startDate.value = '';
    endDate.value = '';
  }
}