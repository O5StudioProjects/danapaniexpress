import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/data/repositories/checkout_repository/checkout_repository.dart';
import 'package:danapaniexpress/domain/controllers/orders_controller/orders_controller.dart';

import '../../../data/models/delivery_slots_model.dart';

class CheckoutController extends GetxController {
  final checkoutRepo = CheckoutRepository();
  final cart = Get.find<CartController>();
  final auth = Get.find<AuthController>();
  final nav = Get.find<NavigationController>();
  final order = Get.put(OrdersController());
  RxList<DeliveryDay> deliveryDays = <DeliveryDay>[].obs;
  Rx<Status> getDeliveryDaysStatus = Status.IDLE.obs;
  Rx<Status> getDeliverySlotsStatus = Status.IDLE.obs;
  Rx<Status> checkOutStatus = Status.IDLE.obs;
  RxInt selectedDayIndex = 0.obs;
  RxInt selectedSlotId = 0.obs;
  RxString selectedSlotLabel = ''.obs;
  RxString selectedSlotDate = ''.obs;

  RxBool review = false.obs;
  RxBool cod = false.obs;
  RxBool flashDelivery = false.obs;
  RxBool slotDelivery = false.obs;
  RxDouble tax = 0.0.obs;
  RxString shippingMethod = AppLanguage.homeDeliveryStr(appLanguage).toString().obs;
  var specialNoteTextController = TextEditingController().obs;

  final Rx<AddressModel?> shippingAddress = Rx<AddressModel?>(null);


  @override
  void onInit() {
    super.onInit();
    fetchAddressData();
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
    if (shippingAddress.value != null &&
        (flashDelivery.value || slotDelivery.value)) {
      return true;
    } else {
      return false;
    }
  }

  bool get paymentValue {
    if (cod.value == false) {
      return false;
    } else {
      return true;
    }
  }

  double get deliveryChargesValue {
    if (flashDelivery.value) {
      if (cart.totalSellingPrice.value < 1000.0) {
        return 100.0;
      } else if (cart.totalSellingPrice.value > 1000.0 &&
          cart.totalSellingPrice.value < 2000.0) {
        return 80.0;
      } else if (cart.totalSellingPrice.value > 2000.0 &&
          cart.totalSellingPrice.value < 3000.0) {
        return 50.0;
      } else if (cart.totalSellingPrice.value > 3000.0) {
        return 0.0;
      } else {
        return 0.0;
      }
    } else if (slotDelivery.value) {
      if (cart.totalSellingPrice.value < 1000.0) {
        return 100.0;
      } else {
        return 0.0;
      }
    } else {
      return 0.0;
    }
  }

  double get totalPayableAmount {
    return cart.totalSellingPrice.value + deliveryChargesValue + tax.value;
  }

  String get deliveryType {
    if (flashDelivery.value) {
      return AppLanguage.flashDeliveryStr(appLanguage).toString();
    } else {
      return AppLanguage.slotDeliveryStr(appLanguage).toString();
    }
  }

  bool get shippingSlotCheck {
    if (slotDelivery.value) {
      if (selectedSlotId.value != 0) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }


  Future<void> checkoutOrder({
    required String userId,
    required String orderStatus,
    required double deliveryCharges,
    required double salesTax,
    required String paymentMethod,
    required String shippingMethod,
    String? addressId,
    String? specialNoteForRider,
    bool isFlashDelivery = false,
    bool isSlotDelivery = false,
    int? slotId,
    String? slotDate,
    String? slotLabel,
  }) async {
    checkOutStatus.value = Status.LOADING;
    try {
      final result = await checkoutRepo.checkoutOrder(
        userId: userId,
        orderStatus: orderStatus,
        deliveryCharges: deliveryCharges,
        salesTax: salesTax,
        paymentMethod: paymentMethod,
        shippingMethod: shippingMethod,
        addressId: addressId,
        specialNoteForRider: specialNoteForRider,
        isFlashDelivery: isFlashDelivery,
        isSlotDelivery: isSlotDelivery,
        slotId: slotId,
        slotDate: slotDate,
        slotLabel: slotLabel,
      );

      if (result['success'] == true) {
        order.fetchInitialOrders();
        checkOutStatus.value = Status.SUCCESS;
        showSnackbar(
          isError: false,
          title: 'Success',
          message: result['message'] ?? 'Order placed successfully',
        );
        // You can optionally clear cart or navigate
        nav.gotoOrderedPlacedScreen(orderData: null);
        await cart.fetchCartProducts();
        await auth.fetchUserProfile();
      } else {
        checkOutStatus.value = Status.FAILURE;
        showSnackbar(
          isError: true,
          title: 'Error',
          message: result['message'] ?? 'Something went wrong',
        );
      }
    } catch (e) {
      checkOutStatus.value = Status.FAILURE;
      print('Exception: $e');
      showSnackbar(
        isError: true,
        title: 'Exception',
        message: e.toString(),
      );
    }
  }


  Future<void> onTapCheckout() async {
    if (shippingAddress.value == null) {
      showSnackbar(
        title: AppLanguage.addressNotFoundStr(
          appLanguage,
        ).toString(),
        message: AppLanguage.addAddressToOrderStr(
          appLanguage,
        ).toString(),
        isError: true,
      );
      return;
    }

    if (!slotDelivery.value &&
        !flashDelivery.value) {
      showSnackbar(
        title: AppLanguage.deliveryTypeStr(
          appLanguage,
        ).toString(),
        message: AppLanguage.selectDeliveryTypeStr(
          appLanguage,
        ).toString(),
        isError: true,
      );
      return;
    }
    if (!cod.value) {
      showSnackbar(
        title: AppLanguage.paymentMethodStr(
          appLanguage,
        ).toString(),
        message: AppLanguage.selectPaymentMethodStr(
          appLanguage,
        ).toString(),
        isError: true,
      );
      return;
    }

    if (slotDelivery.value) {
      if (selectedSlotId.value == 0) {
        showSnackbar(
          title: AppLanguage.selectSlotStr(
            appLanguage,
          ).toString(),
          message: AppLanguage.slotNotSelectedStr(
            appLanguage,
          ).toString(),
          isError: true,
        );
        return;
      }
    }

    await checkoutOrder(
        userId: auth.currentUser.value!.userId!,
        orderStatus: OrderStatus.ACTIVE,
        deliveryCharges: deliveryChargesValue,
        salesTax: tax.value,
        paymentMethod: PaymentMethods.COD,
        shippingMethod: shippingMethod.value,
        addressId: shippingAddress.value!.addressId,
        specialNoteForRider: specialNoteTextController.value.text.trim(),
        isFlashDelivery: flashDelivery.value,
        isSlotDelivery: slotDelivery.value,
        slotId: selectedSlotId.value,
        slotDate: selectedSlotDate.value,
        slotLabel: selectedSlotLabel.value,
    );
  }

}