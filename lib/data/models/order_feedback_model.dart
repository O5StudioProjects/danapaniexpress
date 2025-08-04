const String orderFeedbackTable = 'order_feedback';

class OrderFeedbackFields {
  static const String orderFeedbackId = 'order_feedback_id';
  static const String userId = 'user_id';
  static const String orderId = 'order_id';
  static const String orderNumber = 'order_number';
  static const String isPositive = 'is_positive';
  static const String isNegative = 'is_negative';
  static const String feedbackType = 'feed_back_type';
  static const String feedbackDetail = 'feed_back_detail';

  static final List<String> values = [
    orderFeedbackId,
    userId,
    orderId,
    orderNumber,
    isPositive,
    isNegative,
    feedbackType,
    feedbackDetail,
  ];
}

class OrderFeedbackModel {
  final String? orderFeedbackId;
  final String? userId;
  final String? orderId;
  final String? orderNumber;
  final bool? isPositive;
  final bool? isNegative;
  final String? feedbackType;
  final String? feedbackDetail;

  OrderFeedbackModel({
    this.orderFeedbackId,
    this.userId,
    this.orderId,
    this.orderNumber,
    this.isPositive,
    this.isNegative,
    this.feedbackType,
    this.feedbackDetail,
  });

  OrderFeedbackModel copyWith({
    String? orderFeedbackId,
    String? userId,
    String? orderId,
    String? orderNumber,
    bool? isPositive,
    bool? isNegative,
    String? feedbackType,
    String? feedbackDetail,
  }) {
    return OrderFeedbackModel(
      orderFeedbackId: orderFeedbackId ?? this.orderFeedbackId,
      userId: userId ?? this.userId,
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      isPositive: isPositive ?? this.isPositive,
      isNegative: isNegative ?? this.isNegative,
      feedbackType: feedbackType ?? this.feedbackType,
      feedbackDetail: feedbackDetail ?? this.feedbackDetail,
    );
  }

  factory OrderFeedbackModel.fromJson(Map<String, dynamic> json) {
    return OrderFeedbackModel(
      orderFeedbackId: json['order_feedback_id'],
      userId: json['user_id'],
      orderId: json['order_id'],
      orderNumber: json['order_number'],
      isPositive: json['is_positive'] == true,
      isNegative: json['is_negative'] == true,
      feedbackType: json['feed_back_type'],
      feedbackDetail: json['feed_back_detail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_feedback_id': orderFeedbackId,
      'user_id': userId,
      'order_id': orderId,
      'order_number': orderNumber,
      'is_positive': isPositive,
      'is_negative': isNegative,
      'feed_back_type': feedbackType,
      'feed_back_detail': feedbackDetail,
    };
  }
}
