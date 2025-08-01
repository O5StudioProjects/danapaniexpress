import 'package:danapaniexpress/core/data_model_imports.dart';

class OrderModel {
  final String? userId;
  final String? orderId;
  final String? orderNumber;
  final String? riderId;
  final String? orderFeedbackId;

  final String? orderPlacedDateTime;
  final String? orderConfirmedDateTime;
  final String? orderCompletedDateTime;
  final String? orderCancelledDateTime;

  final String? orderStatus;
  final String? paymentMethod;
  final String? shippingMethod;

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

  final RiderModel? rider;
  final OrderFeedbackModel? orderFeedback;
  final UserModel? user;
  final List<OrderedProductModel>? orderedProducts;

  const OrderModel({
    this.userId,
    this.orderId,
    this.orderNumber,
    this.riderId,
    this.orderFeedbackId,
    this.orderPlacedDateTime,
    this.orderConfirmedDateTime,
    this.orderCompletedDateTime,
    this.orderCancelledDateTime,
    this.orderStatus,
    this.paymentMethod,
    this.shippingMethod,
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
      orderFeedbackId: json['order_feedback_id'],
      orderPlacedDateTime: json['order_placed_date_time'],
      orderConfirmedDateTime: json['order_confirmed_date_time'],
      orderCompletedDateTime: json['order_completed_date_time'],
      orderCancelledDateTime: json['order_cancelled_date_time'],
      orderStatus: json['order_status'],
      paymentMethod: json['payment_method'],
      shippingMethod: json['shipping_method'],
      totalSellingAmount: (json['total_selling_amount'] as num?)?.toDouble(),
      totalCutPriceAmount: (json['total_cut_price_amount'] as num?)?.toDouble(),
      totalDiscount: (json['total_discount'] as num?)?.toDouble(),
      deliveryCharges: (json['delivery_charges'] as num?)?.toDouble(),
      salesTax: (json['sales_tax'] as num?)?.toDouble(),
      isFlashDelivery: json['is_flash_delivery'],
      flashDeliveryDateTime: json['flash_delivery_date_time'],
      isSlotDelivery: json['is_slot_delivery'],
      slotDate: json['slot_date'],
      slotId: json['slot_id'],
      slotLabel: json['slot_label'],
      specialNoteForRider: json['special_note_for_rider'],
      rider: json['rider'] != null ? RiderModel.fromJson(json['rider']) : null,
      orderFeedback: json['order_feedback'] != null
          ? OrderFeedbackModel.fromJson(json['order_feedback'])
          : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
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
      'order_feedback_id': orderFeedbackId,
      'order_placed_date_time': orderPlacedDateTime,
      'order_confirmed_date_time': orderConfirmedDateTime,
      'order_completed_date_time': orderCompletedDateTime,
      'order_cancelled_date_time': orderCancelledDateTime,
      'order_status': orderStatus,
      'payment_method': paymentMethod,
      'shipping_method': shippingMethod,
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
      'rider': rider?.toJson(),
      'order_feedback': orderFeedback?.toJson(),
      'user': user?.toJson(),
      'ordered_products': orderedProducts?.map((e) => e.toJson()).toList(),
    };
  }
}
