

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/data/repositories/checkout_repository/checkout_repository.dart';

import '../../../data/models/delivery_slots_model.dart';

class CheckoutController extends GetxController{
  final checkoutRepo = CheckoutRepository();
  RxList<DeliveryDay> deliveryDays = <DeliveryDay>[].obs;
  Rx<Status> getDeliveryDaysStatus = Status.IDLE.obs;
  Rx<Status> getDeliverySlotsStatus = Status.IDLE.obs;
  RxInt selectedDayIndex = 0.obs;
  RxInt selectedSlotId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDeliveryDaysWithSlots();
  }

  Future<void> fetchDeliveryDaysWithSlots() async {
    try {
      getDeliverySlotsStatus.value = Status.LOADING;

      final response = await checkoutRepo.getDeliveryDaysWithSlots();
      if (response['status'] == true && response['data'] != null) {
        final List<dynamic> dataList = response['data'];
        final List<DeliveryDay> days = dataList
            .map((json) => DeliveryDay.fromJson(json))
            .toList();
        deliveryDays.assignAll(days);
        getDeliverySlotsStatus.value = Status.SUCCESS;
      } else {
        getDeliverySlotsStatus.value = Status.FAILURE;
        showSnackbar(
          isError: true,
          title: 'Error',
          message: response['message'] ?? 'Failed to load delivery slots.',
        );
      }
    } catch (e) {
      getDeliverySlotsStatus.value = Status.FAILURE;
      showSnackbar(
        isError: true,
        title: 'Exception',
        message: e.toString(),
      );
    }
  }

  Future<void> onTapDayNames(index) async {
    selectedDayIndex.value = index;
    selectedSlotId.value = 0;
    print(selectedDayIndex.value);

  }

}