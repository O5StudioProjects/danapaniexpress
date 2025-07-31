class DeliverySlotsResponse {
  final bool status;
  final List<DeliveryDay> data;

  DeliverySlotsResponse({
    required this.status,
    required this.data,
  });

  factory DeliverySlotsResponse.fromJson(Map<String, dynamic> json) {
    return DeliverySlotsResponse(
      status: json['status'] ?? false,
      data: (json['data'] as List<dynamic>)
          .map((e) => DeliveryDay.fromJson(e))
          .toList(),
    );
  }
}


class DeliveryDay {
  final String date;
  final String dayName;
  final List<DeliverySlot> slots;

  DeliveryDay({
    required this.date,
    required this.dayName,
    required this.slots,
  });

  factory DeliveryDay.fromJson(Map<String, dynamic> json) {
    return DeliveryDay(
      date: json['date'] ?? '',
      dayName: json['day_name'] ?? '',
      slots: (json['slots'] as List<dynamic>)
          .map((e) => DeliverySlot.fromJson(e))
          .toList(),
    );
  }
}

class DeliverySlot {
  final int slotId;
  final String slotLabel;
  final String startTime;
  final String endTime;
  final int totalLimit;
  final int bookedCount;
  final bool isActive;
  bool isAvailable;

  DeliverySlot({
    required this.slotId,
    required this.slotLabel,
    required this.startTime,
    required this.endTime,
    required this.totalLimit,
    required this.bookedCount,
    required this.isActive,
    required this.isAvailable,
  });

  factory DeliverySlot.fromJson(Map<String, dynamic> json) {
    return DeliverySlot(
      slotId: json['slot_id'] ?? 0,
      slotLabel: json['slot_label'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      totalLimit: json['total_limit'] ?? 0,
      bookedCount: json['booked_count'] ?? 0,
      isActive: json['is_active'] ?? false,
      isAvailable: json['is_available'] ?? false,
    );
  }
}
