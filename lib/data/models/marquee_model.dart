const String marqueeTable = 'marquees';

class MarqueeFields {
  static final List<String> values = [
    id,
    marqueeType,
    marqueeTypeId,
    dialogImage,
    marqueeTitleEnglish,
    marqueeTitleUrdu,
    marqueeDetailEnglish,
    marqueeDetailUrdu,
    dateTime,
  ];

  static const String id = '_id';
  static const String marqueeType = 'marquee_type';
  static const String marqueeTypeId = 'marquee_type_id';
  static const String dialogImage = 'dialog_image';
  static const String marqueeTitleEnglish = 'marquee_title_english';
  static const String marqueeTitleUrdu = 'marquee_title_urdu';
  static const String marqueeDetailEnglish = 'marquee_detail_english';
  static const String marqueeDetailUrdu = 'marquee_detail_urdu';
  static const String dateTime = 'date_time';
}

class MarqueeModel {
  final String id;
  final String marqueeType;
  final String marqueeTypeId;
  final String dialogImage;
  final String marqueeTitleEnglish;
  final String marqueeTitleUrdu;
  final String marqueeDetailEnglish;
  final String marqueeDetailUrdu;
  final String dateTime;

  const MarqueeModel({
    required this.id,
    required this.marqueeType,
    required this.marqueeTypeId,
    required this.dialogImage,
    required this.marqueeTitleEnglish,
    required this.marqueeTitleUrdu,
    required this.marqueeDetailEnglish,
    required this.marqueeDetailUrdu,
    required this.dateTime,
  });

  // From local JSON/map
  static MarqueeModel fromJson(Map<String, Object?> json) => MarqueeModel(
    id: json[MarqueeFields.id]?.toString() ?? '',
    marqueeType: json[MarqueeFields.marqueeType]?.toString() ?? '',
    marqueeTypeId: json[MarqueeFields.marqueeTypeId]?.toString() ?? '',
    dialogImage: json[MarqueeFields.dialogImage]?.toString() ?? '',
    marqueeTitleEnglish: json[MarqueeFields.marqueeTitleEnglish]?.toString() ?? '',
    marqueeTitleUrdu: json[MarqueeFields.marqueeTitleUrdu]?.toString() ?? '',
    marqueeDetailEnglish: json[MarqueeFields.marqueeDetailEnglish]?.toString() ?? '',
    marqueeDetailUrdu: json[MarqueeFields.marqueeDetailUrdu]?.toString() ?? '',
    dateTime: json[MarqueeFields.dateTime]?.toString() ?? '',
  );

  // To local JSON/map
  Map<String, Object?> toJson() => {
    MarqueeFields.id: id,
    MarqueeFields.marqueeType: marqueeType,
    MarqueeFields.marqueeTypeId: marqueeTypeId,
    MarqueeFields.dialogImage: dialogImage,
    MarqueeFields.marqueeTitleEnglish: marqueeTitleEnglish,
    MarqueeFields.marqueeTitleUrdu: marqueeTitleUrdu,
    MarqueeFields.marqueeDetailEnglish: marqueeDetailEnglish,
    MarqueeFields.marqueeDetailUrdu: marqueeDetailUrdu,
    MarqueeFields.dateTime: dateTime,
  };

  // To Firebase
  Map<String, dynamic> toJsonFb() => {
    MarqueeFields.marqueeType: marqueeType,
    MarqueeFields.marqueeTypeId: marqueeTypeId,
    MarqueeFields.dialogImage: dialogImage,
    MarqueeFields.marqueeTitleEnglish: marqueeTitleEnglish,
    MarqueeFields.marqueeTitleUrdu: marqueeTitleUrdu,
    MarqueeFields.marqueeDetailEnglish: marqueeDetailEnglish,
    MarqueeFields.marqueeDetailUrdu: marqueeDetailUrdu,
    MarqueeFields.dateTime: dateTime,
  };

  // Copy method
  MarqueeModel copy({
    String? id,
    String? marqueeType,
    String? marqueeTypeId,
    String? dialogImage,
    String? marqueeTitleEnglish,
    String? marqueeTitleUrdu,
    String? marqueeDetailEnglish,
    String? marqueeDetailUrdu,
    String? dateTime,
  }) =>
      MarqueeModel(
        id: id ?? this.id,
        marqueeType: marqueeType ?? this.marqueeType,
        marqueeTypeId: marqueeTypeId ?? this.marqueeTypeId,
        dialogImage: dialogImage ?? this.dialogImage,
        marqueeTitleEnglish: marqueeTitleEnglish ?? this.marqueeTitleEnglish,
        marqueeTitleUrdu: marqueeTitleUrdu ?? this.marqueeTitleUrdu,
        marqueeDetailEnglish: marqueeDetailEnglish ?? this.marqueeDetailEnglish,
        marqueeDetailUrdu: marqueeDetailUrdu ?? this.marqueeDetailUrdu,
        dateTime: dateTime ?? this.dateTime,
      );
}
