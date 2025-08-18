import 'dart:convert';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:http/http.dart' as http;

class CheckoutDatasource extends BaseRepository{

  /// GET DELIVERY DAYS WITH SLOTS (7 DAYS)
  Future<Map<String, dynamic>> getDeliveryDaysWithSlotsApi() async {
    final uri = Uri.parse(APiEndpoints.getDeliveryDaysAndSlots);

    final response = await http.get(
      uri,
      headers: apiHeaders,
    );

    return handleApiResponseAsMap(response);
  }

  /// CHECKOUT ORDER API CALL
  Future<Map<String, dynamic>> checkoutOrderApi({
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
    final uri = Uri.parse(APiEndpoints.checkoutOrder);

    final Map<String, dynamic> body = {
      'user_id': userId,
      'order_status': orderStatus,
      'delivery_charges': deliveryCharges,
      'sales_tax': salesTax,
      'payment_method': paymentMethod,
      'shipping_method': shippingMethod,
      'is_flash_delivery': isFlashDelivery,
      'is_slot_delivery': isSlotDelivery,
      if (slotId != null) 'slot_id': slotId,
      if (slotDate != null) 'slot_date': slotDate,
      if (slotLabel != null) 'slot_label': slotLabel,
      if (addressId != null) 'address_id': addressId,
      if (specialNoteForRider != null)
        'special_note_for_rider': specialNoteForRider,
    };

    final response = await http.post(
      uri,
      headers: apiHeaders,
      body: jsonEncode(body),
    );

    return handleApiResponseAsMap(response);
  }


}