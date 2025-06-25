
const String notificationTable = 'notifications';

class NotificationFields {
  static final List<String> values = [
    id,
    notificationType,
    notificationTitleEnglish,
    notificationTitleUrdu,
    notificationDetailEnglish,
    notificationDetailUrdu,
    dateTime,
  ];

  static const String id = '_id';
  static const String notificationType = 'notification_type';
  static const String notificationTitleEnglish = 'notification_title_english';
  static const String notificationTitleUrdu = 'notification_title_urdu';
  static const String notificationDetailEnglish = 'notification_detail_english';
  static const String notificationDetailUrdu = 'notification_detail_urdu';
  static const String dateTime = 'date_time';
}

class NotificationModel {
  final String id;
  final String notificationType;
  final String notificationTitleEnglish;
  final String notificationTitleUrdu;
  final String notificationDetailEnglish;
  final String notificationDetailUrdu;
  final String dateTime;

  const NotificationModel({
    required this.id,
    required this.notificationType,
    required this.notificationTitleEnglish,
    required this.notificationTitleUrdu,
    required this.notificationDetailEnglish,
    required this.notificationDetailUrdu,
    required this.dateTime,
  });

  // // From Firebase (QueryDocumentSnapshot)
  // static NotificationModel fromJsonFb(QueryDocumentSnapshot<Map<String, dynamic>> json) => NotificationModel(
  //   id: json.id,
  //   notificationType: json[NotificationFields.notificationType] as String,
  //   notificationTitleEnglish: json[NotificationFields.notificationTitleEnglish] as String,
  //   notificationTitleUrdu: json[NotificationFields.notificationTitleUrdu] as String,
  //   notificationDetailEnglish: json[NotificationFields.notificationDetailEnglish] as String,
  //   notificationDetailUrdu: json[NotificationFields.notificationDetailUrdu] as String,
  //   dateTime: json[NotificationFields.dateTime] as String,
  // );
  //
  // // From Firebase (DocumentSnapshot)
  // static NotificationModel fromJsonFbStore(DocumentSnapshot<Map<String, dynamic>> json) => NotificationModel(
  //   id: json.id,
  //   notificationType: json[NotificationFields.notificationType] as String,
  //   notificationTitleEnglish: json[NotificationFields.notificationTitleEnglish] as String,
  //   notificationTitleUrdu: json[NotificationFields.notificationTitleUrdu] as String,
  //   notificationDetailEnglish: json[NotificationFields.notificationDetailEnglish] as String,
  //   notificationDetailUrdu: json[NotificationFields.notificationDetailUrdu] as String,
  //   dateTime: json[NotificationFields.dateTime] as String,
  // );

  // To Firebase
  Map<String, dynamic> toJsonFb() => {
    NotificationFields.notificationType: notificationType,
    NotificationFields.notificationTitleEnglish: notificationTitleEnglish,
    NotificationFields.notificationTitleUrdu: notificationTitleUrdu,
    NotificationFields.notificationDetailEnglish: notificationDetailEnglish,
    NotificationFields.notificationDetailUrdu: notificationDetailUrdu,
    NotificationFields.dateTime: dateTime,
  };

  // From local JSON/map
  static NotificationModel fromJson(Map<String, Object?> json) => NotificationModel(
    id: json[NotificationFields.id] as String,
    notificationType: json[NotificationFields.notificationType] as String,
    notificationTitleEnglish: json[NotificationFields.notificationTitleEnglish] as String,
    notificationTitleUrdu: json[NotificationFields.notificationTitleUrdu] as String,
    notificationDetailEnglish: json[NotificationFields.notificationDetailEnglish] as String,
    notificationDetailUrdu: json[NotificationFields.notificationDetailUrdu] as String,
    dateTime: json[NotificationFields.dateTime] as String,
  );

  // To local JSON/map
  Map<String, Object?> toJson() => {
    NotificationFields.id: id,
    NotificationFields.notificationType: notificationType,
    NotificationFields.notificationTitleEnglish: notificationTitleEnglish,
    NotificationFields.notificationTitleUrdu: notificationTitleUrdu,
    NotificationFields.notificationDetailEnglish: notificationDetailEnglish,
    NotificationFields.notificationDetailUrdu: notificationDetailUrdu,
    NotificationFields.dateTime: dateTime,
  };

  // Copy method
  NotificationModel copy({
    String? id,
    String? notificationType,
    String? notificationTitleEnglish,
    String? notificationTitleUrdu,
    String? notificationDetailEnglish,
    String? notificationDetailUrdu,
    String? dateTime,
  }) =>
      NotificationModel(
        id: id ?? this.id,
        notificationType: notificationType ?? this.notificationType,
        notificationTitleEnglish: notificationTitleEnglish ?? this.notificationTitleEnglish,
        notificationTitleUrdu: notificationTitleUrdu ?? this.notificationTitleUrdu,
        notificationDetailEnglish: notificationDetailEnglish ?? this.notificationDetailEnglish,
        notificationDetailUrdu: notificationDetailUrdu ?? this.notificationDetailUrdu,
        dateTime: dateTime ?? this.dateTime,
      );
}
