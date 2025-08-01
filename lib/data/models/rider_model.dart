
const String ridersTable = 'riders';

class RiderFields {
  static final List<String> values = [
    riderId,
    riderName,
    riderPhone,
    riderImage,
    riderCity,
    riderDetail,
    riderRating,
    riderCompletedOrders,
    riderCancelledOrders,
    riderZoneId,
  ];

  static const String riderId = 'rider_id';
  static const String riderName = 'rider_name';
  static const String riderPhone = 'rider_phone';
  static const String riderImage = 'rider_image';
  static const String riderCity = 'rider_city';
  static const String riderDetail = 'rider_detail';
  static const String riderRating = 'rider_rating';
  static const String riderCompletedOrders = 'rider_completed_orders';
  static const String riderCancelledOrders = 'rider_cancelled_orders';
  static const String riderZoneId = 'rider_zone_id';
}

class RiderModel {
  final String riderId;
  final String riderName;
  final String riderPhone;
  final String riderImage;
  final String riderCity;
  final String riderDetail;
  final double riderRating;
  final int riderCompletedOrders;
  final int riderCancelledOrders;
  final String riderZoneId;

  const RiderModel({
    required this.riderId,
    required this.riderName,
    required this.riderPhone,
    required this.riderImage,
    required this.riderCity,
    required this.riderDetail,
    required this.riderRating,
    required this.riderCompletedOrders,
    required this.riderCancelledOrders,
    required this.riderZoneId,
  });

  RiderModel copyWith({
    String? riderId,
    String? riderName,
    String? riderPhone,
    String? riderImage,
    String? riderCity,
    String? riderDetail,
    double? riderRating,
    int? riderCompletedOrders,
    int? riderCancelledOrders,
    String? riderZoneId,
  }) =>
      RiderModel(
        riderId: riderId ?? this.riderId,
        riderName: riderName ?? this.riderName,
        riderPhone: riderPhone ?? this.riderPhone,
        riderImage: riderImage ?? this.riderImage,
        riderCity: riderCity ?? this.riderCity,
        riderDetail: riderDetail ?? this.riderDetail,
        riderRating: riderRating ?? this.riderRating,
        riderCompletedOrders: riderCompletedOrders ?? this.riderCompletedOrders,
        riderCancelledOrders: riderCancelledOrders ?? this.riderCancelledOrders,
        riderZoneId: riderZoneId ?? this.riderZoneId,
      );

  factory RiderModel.fromJson(Map<String, dynamic> json) => RiderModel(
    riderId: json['rider_id'],
    riderName: json['rider_name'],
    riderPhone: json['rider_phone'],
    riderImage: json['rider_image'],
    riderCity: json['rider_city'],
    riderDetail: json['rider_detail'],
    riderRating: (json['rider_rating'] ?? 0).toDouble(),
    riderCompletedOrders: json['rider_completed_orders'] ?? 0,
    riderCancelledOrders: json['rider_cancelled_orders'] ?? 0,
    riderZoneId: json['rider_zone_id'],
  );

  Map<String, dynamic> toJson() => {
    'rider_id': riderId,
    'rider_name': riderName,
    'rider_phone': riderPhone,
    'rider_image': riderImage,
    'rider_city': riderCity,
    'rider_detail': riderDetail,
    'rider_rating': riderRating,
    'rider_completed_orders': riderCompletedOrders,
    'rider_cancelled_orders': riderCancelledOrders,
    'rider_zone_id': riderZoneId,
  };
}
