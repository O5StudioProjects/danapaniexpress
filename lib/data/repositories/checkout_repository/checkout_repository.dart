import 'package:danapaniexpress/data/repositories/checkout_repository/checkout_datasource.dart';

class CheckoutRepository extends CheckoutDatasource{

  /// GET DELIVERY DAYS WITH SLOTS (7 DAYS)
  Future<Map<String, dynamic>> getDeliveryDaysWithSlots() async {
    return await getDeliveryDaysWithSlotsApi();
  }

  /// CHECKOUT ORDER AND PLACE FINAL ORDER
  Future<Map<String, dynamic>> checkoutOrder({
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
    return await checkoutOrderApi(
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
  }


}