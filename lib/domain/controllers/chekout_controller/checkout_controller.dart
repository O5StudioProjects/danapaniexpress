

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/data/repositories/checkout_repository/checkout_repository.dart';

import '../../../data/models/delivery_slots_model.dart';

class CheckoutController extends GetxController{
  final checkoutRepo = CheckoutRepository();
  final cart = Get.find<CartController>();
  final auth = Get.find<AuthController>();
  RxList<DeliveryDay> deliveryDays = <DeliveryDay>[].obs;
  Rx<Status> getDeliveryDaysStatus = Status.IDLE.obs;
  Rx<Status> getDeliverySlotsStatus = Status.IDLE.obs;
  RxInt selectedDayIndex = 0.obs;
  RxInt selectedSlotId = 0.obs;

  RxBool review = false.obs;
  RxBool cod = false.obs;
  RxBool flashDelivery = false.obs;
  RxBool slotDelivery = false.obs;
  RxDouble tax = 0.0.obs;
  RxString shippingMethod = 'Home Delivery'.obs;

  final Rx<AddressModel?> shippingAddress = Rx<AddressModel?>(null);


  @override
  void onInit() {
    super.onInit();
    fetchAddressData();
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
    if (kDebugMode) {
      print(selectedDayIndex.value);
    }

  }

  Future<void> fetchAddressData() async {
    shippingAddress.value = auth.currentUser.value?.userDefaultAddress;
   print('Address Data : ${shippingAddress.value}');
   print(shippingAddress.value?.address);
  }

  bool get shippingValue {
    if(shippingAddress.value != null && (flashDelivery.value || slotDelivery.value)){
      return true;
    } else {
      return false;
    }
  }
  bool get paymentValue {
    if(cod.value == false){
      return false;
    } else {
      return true;
    }
  }

  double get deliveryChargesValue {
    if(flashDelivery.value){
      if(cart.totalSellingPrice.value < 1000.0){
        return 150.0;
      } else if(cart.totalSellingPrice.value > 1000.0 && cart.totalSellingPrice.value < 2000.0){
        return 80.0;
      } else if(cart.totalSellingPrice.value > 2000.0 && cart.totalSellingPrice.value < 3000.0){
        return 50.0;
      } else if(cart.totalSellingPrice.value > 3000.0){
        return 0.0;
      }else {
        return 0.0;
      }
    }else if(slotDelivery.value){
      if(cart.totalSellingPrice.value < 1000.0){
        return 100.0;
      } else {
        return 0.0;
      }
    } else {
      return 0.0;
    }

  }

  double get totalPayableAmount {
    return cart.totalSellingPrice.value + deliveryChargesValue + tax.value ;
  }

  String get deliveryType {
    if(flashDelivery.value){
      return "Flash Delivery";
    } else {
      return "Slot Delivery";
    }
  }

  bool get shippingSlotCheck {
    if(slotDelivery.value){
      if(selectedSlotId.value != 0){
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }

  }

}