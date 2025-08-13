const String marqueeTable = 'marquees';

class MarqueeFields {
  static final List<String> values = [
    id,
    marqueeType,
    marqueeTypeId,
    dialogImage,
    marqueeTitleEnglish,
    marqueeTitleUrdu,
    marqueeTitleArabic,
    marqueeDetailEnglish,
    marqueeDetailUrdu,
    marqueeDetailArabic,
    dateTime,
  ];

  static const String id = '_id';
  static const String marqueeType = 'marquee_type';
  static const String marqueeTypeId = 'marquee_type_id';
  static const String dialogImage = 'dialog_image';
  static const String marqueeTitleEnglish = 'marquee_title_english';
  static const String marqueeTitleUrdu = 'marquee_title_urdu';
  static const String marqueeTitleArabic = 'marquee_title_arabic';
  static const String marqueeDetailEnglish = 'marquee_detail_english';
  static const String marqueeDetailUrdu = 'marquee_detail_urdu';
  static const String marqueeDetailArabic = 'marquee_detail_arabic';
  static const String dateTime = 'date_time';
}

class MarqueeModel {
  final String id;
  final String marqueeType;
  final String marqueeTypeId;
  final String dialogImage;
  final String marqueeTitleEnglish;
  final String marqueeTitleUrdu;
  final String marqueeTitleArabic;
  final String marqueeDetailEnglish;
  final String marqueeDetailUrdu;
  final String marqueeDetailArabic;
  final String dateTime;

  const MarqueeModel({
    required this.id,
    required this.marqueeType,
    required this.marqueeTypeId,
    required this.dialogImage,
    required this.marqueeTitleEnglish,
    required this.marqueeTitleUrdu,
    required this.marqueeTitleArabic,
    required this.marqueeDetailEnglish,
    required this.marqueeDetailUrdu,
    required this.marqueeDetailArabic,
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
    marqueeTitleArabic: json[MarqueeFields.marqueeTitleArabic]?.toString() ?? '',
    marqueeDetailEnglish: json[MarqueeFields.marqueeDetailEnglish]?.toString() ?? '',
    marqueeDetailUrdu: json[MarqueeFields.marqueeDetailUrdu]?.toString() ?? '',
    marqueeDetailArabic: json[MarqueeFields.marqueeDetailArabic]?.toString() ?? '',
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
    MarqueeFields.marqueeTitleArabic: marqueeTitleArabic,
    MarqueeFields.marqueeDetailEnglish: marqueeDetailEnglish,
    MarqueeFields.marqueeDetailUrdu: marqueeDetailUrdu,
    MarqueeFields.marqueeDetailArabic: marqueeDetailArabic,
    MarqueeFields.dateTime: dateTime,
  };

  // To Firebase
  Map<String, dynamic> toJsonFb() => {
    MarqueeFields.marqueeType: marqueeType,
    MarqueeFields.marqueeTypeId: marqueeTypeId,
    MarqueeFields.dialogImage: dialogImage,
    MarqueeFields.marqueeTitleEnglish: marqueeTitleEnglish,
    MarqueeFields.marqueeTitleUrdu: marqueeTitleUrdu,
    MarqueeFields.marqueeTitleArabic: marqueeTitleArabic,
    MarqueeFields.marqueeDetailEnglish: marqueeDetailEnglish,
    MarqueeFields.marqueeDetailUrdu: marqueeDetailUrdu,
    MarqueeFields.marqueeDetailArabic: marqueeDetailArabic,
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
    String? marqueeTitleArabic,
    String? marqueeDetailEnglish,
    String? marqueeDetailUrdu,
    String? marqueeDetailArabic,
    String? dateTime,
  }) =>
      MarqueeModel(
        id: id ?? this.id,
        marqueeType: marqueeType ?? this.marqueeType,
        marqueeTypeId: marqueeTypeId ?? this.marqueeTypeId,
        dialogImage: dialogImage ?? this.dialogImage,
        marqueeTitleEnglish: marqueeTitleEnglish ?? this.marqueeTitleEnglish,
        marqueeTitleUrdu: marqueeTitleUrdu ?? this.marqueeTitleUrdu,
        marqueeTitleArabic: marqueeTitleArabic ?? this.marqueeTitleArabic,
        marqueeDetailEnglish: marqueeDetailEnglish ?? this.marqueeDetailEnglish,
        marqueeDetailUrdu: marqueeDetailUrdu ?? this.marqueeDetailUrdu,
        marqueeDetailArabic: marqueeDetailArabic ?? this.marqueeDetailArabic,
        dateTime: dateTime ?? this.dateTime,
      );
}
