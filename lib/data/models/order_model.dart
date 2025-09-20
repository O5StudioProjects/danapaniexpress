import 'package:danapaniexpress/core/data_model_imports.dart';

class OrderModel {
  final String? userId;
  final String? orderId;
  final String? orderNumber;
  final String? riderId;
  final String? riderName;
  final String? riderPhone;
  final String? riderImage;
  final String? orderFeedbackId;

  final String? orderPlacedDateTime;
  final String? orderConfirmedDateTime;
  final String? orderCompletedDateTime;
  final String? orderCancelledDateTime;

  final String? orderStatus;
  final String? paymentMethod;
  final String? shippingMethod;
  final String? shippingAddress;

  final double? totalSellingAmount;
  final double? totalCutPriceAmount;
  final double? totalDiscount;
  final double? deliveryCharges;
  final double? salesTax;

  final bool? isFlashDelivery;
  final String? flashDeliveryDateTime;

  final bool? isSlotDelivery;
  final String? slotDate;
  final int? slotId;
  final String? slotLabel;
  final String? specialNoteForRider;

  final bool? cancelByAdmin;
  final String? reasonForCancel;

  final RiderModel? rider;
  final OrderFeedbackModel? orderFeedback;
  final OrderUserModel? user;
  final List<OrderedProductModel>? orderedProducts;

  const OrderModel({
    this.userId,
    this.orderId,
    this.orderNumber,
    this.riderId,
    this.riderName,
    this.riderPhone,
    this.riderImage,
    this.orderFeedbackId,
    this.orderPlacedDateTime,
    this.orderConfirmedDateTime,
    this.orderCompletedDateTime,
    this.orderCancelledDateTime,
    this.orderStatus,
    this.paymentMethod,
    this.shippingMethod,
    this.shippingAddress,
    this.totalSellingAmount,
    this.totalCutPriceAmount,
    this.totalDiscount,
    this.deliveryCharges,
    this.salesTax,
    this.isFlashDelivery,
    this.flashDeliveryDateTime,
    this.isSlotDelivery,
    this.slotDate,
    this.slotId,
    this.slotLabel,
    this.specialNoteForRider,
    this.cancelByAdmin,
    this.reasonForCancel,
    this.rider,
    this.orderFeedback,
    this.user,
    this.orderedProducts,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      userId: json['user_id'],
      orderId: json['order_id'],
      orderNumber: json['order_number'],
      riderId: json['rider_id'],
      riderName: json['rider_name'],
      riderPhone: json['rider_phone'],
      riderImage: json['rider_image'],
      orderFeedbackId: json['order_feedback_id'],
      orderPlacedDateTime: json['order_placed_date_time'],
      orderConfirmedDateTime: json['order_confirmed_date_time'],
      orderCompletedDateTime: json['order_completed_date_time'],
      orderCancelledDateTime: json['order_cancelled_date_time'],
      orderStatus: json['order_status'],
      paymentMethod: json['payment_method'],
      shippingMethod: json['shipping_method'],
      shippingAddress: json['shipping_address'],
      totalSellingAmount: (json['total_selling_amount'] as num?)?.toDouble(),
      totalCutPriceAmount: (json['total_cut_price_amount'] as num?)?.toDouble(),
      totalDiscount: (json['total_discount'] as num?)?.toDouble(),
      deliveryCharges: (json['delivery_charges'] as num?)?.toDouble(),
      salesTax: (json['sales_tax'] as num?)?.toDouble(),
      isFlashDelivery: json['is_flash_delivery'] is bool
          ? json['is_flash_delivery']
          : (json['is_flash_delivery'] == '1' || json['is_flash_delivery'] == 1 || json['is_flash_delivery'] == true),
      flashDeliveryDateTime: json['flash_delivery_date_time'],
      isSlotDelivery: json['is_slot_delivery'] is bool
          ? json['is_slot_delivery']
          : (json['is_slot_delivery'] == '1' || json['is_slot_delivery'] == 1 || json['is_slot_delivery'] == true),
      slotDate: json['slot_date'],
      slotId: json['slot_id'],
      slotLabel: json['slot_label'],
      specialNoteForRider: json['special_note_for_rider'],
      cancelByAdmin: json['cancel_by_admin'] is bool
          ? json['cancel_by_admin']
          : (json['cancel_by_admin'] == '1' || json['cancel_by_admin'] == 1 || json['cancel_by_admin'] == true),
      reasonForCancel: json['reason_for_cancel'],
      rider: json['rider'] != null ? RiderModel.fromJson(json['rider']) : null,
      orderFeedback: json['order_feedback'] != null
          ? OrderFeedbackModel.fromJson(json['order_feedback'])
          : null,
      user: json['user'] != null ? OrderUserModel.fromJson(json['user']) : null,
      orderedProducts: (json['ordered_products'] as List<dynamic>?)
          ?.map((e) => OrderedProductModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'order_id': orderId,
      'order_number': orderNumber,
      'rider_id': riderId,
      'rider_name': riderName,
      'rider_phone': riderPhone,
      'rider_image': riderImage,
      'order_feedback_id': orderFeedbackId,
      'order_placed_date_time': orderPlacedDateTime,
      'order_confirmed_date_time': orderConfirmedDateTime,
      'order_completed_date_time': orderCompletedDateTime,
      'order_cancelled_date_time': orderCancelledDateTime,
      'order_status': orderStatus,
      'payment_method': paymentMethod,
      'shipping_method': shippingMethod,
      'shipping_address': shippingAddress,
      'total_selling_amount': totalSellingAmount,
      'total_cut_price_amount': totalCutPriceAmount,
      'total_discount': totalDiscount,
      'delivery_charges': deliveryCharges,
      'sales_tax': salesTax,
      'is_flash_delivery': isFlashDelivery,
      'flash_delivery_date_time': flashDeliveryDateTime,
      'is_slot_delivery': isSlotDelivery,
      'slot_date': slotDate,
      'slot_id': slotId,
      'slot_label': slotLabel,
      'special_note_for_rider': specialNoteForRider,
      'cancel_by_admin': cancelByAdmin,
      'reason_for_cancel': reasonForCancel,
      'rider': rider?.toJson(),
      'order_feedback': orderFeedback?.toJson(),
      'user': user?.toJson(), // ✅ fixed
      'ordered_products': orderedProducts?.map((e) => e.toJson()).toList(),
    };
  }

}


class OrderUserModel {
  final String? fullName;
  final String? email;
  final String? phone;
  final String? image;
  final String? shippingAddress; // <-- FIXED (was AddressModel)

  OrderUserModel({
    this.fullName,
    this.email,
    this.phone,
    this.image,
    this.shippingAddress,
  });

  factory OrderUserModel.fromJson(Map<String, dynamic> json) {
    return OrderUserModel(
      fullName: json['user_full_name'] as String?,
      email: json['user_email'] as String?,
      phone: json['user_phone'] as String?,
      image: json['user_image'] as String?,
      shippingAddress: json['user_shipping_address'] as String?, // ✅ FIX

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_full_name': fullName,
      'user_email': email,
      'user_phone': phone,
      'user_image': image,
      'user_shipping_address': shippingAddress, // ✅ FIX
    };
  }
}



