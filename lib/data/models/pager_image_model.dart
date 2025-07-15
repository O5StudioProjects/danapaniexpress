const String pagerImagesTable = 'pager_images';

class PagerImagesFields {
  static final List<String> values = [
    pagerId, pagerSection, type, typeId, imageUrl,
  ];

  static const String pagerId = 'pager_id';
  static const String pagerSection = 'pager_section';
  static const String type = 'type';
  static const String typeId = 'type_id';
  static const String imageUrl = 'image_url';
}

class PagerImagesModel {
  final int? pagerId;
  final String? pagerSection;
  final String? type;
  final String? typeId;
  final String? imageUrl;

  const PagerImagesModel({
    required this.pagerId,
    required this.pagerSection,
    required this.type,
    required this.typeId,
    required this.imageUrl,
  });

  Map<String, Object?> toJson() => {
    PagerImagesFields.pagerId: pagerId,
    PagerImagesFields.pagerSection: pagerSection,
    PagerImagesFields.type: type,
    PagerImagesFields.typeId: typeId,
    PagerImagesFields.imageUrl: imageUrl,
  };

  static PagerImagesModel fromJson(Map<String, Object?> json) => PagerImagesModel(
    pagerId: json[PagerImagesFields.pagerId] as int?,
    pagerSection: json[PagerImagesFields.pagerSection] as String?,
    type: json[PagerImagesFields.type] as String?,
    typeId: json[PagerImagesFields.typeId] as String?,
    imageUrl: json[PagerImagesFields.imageUrl] as String?,
  );

  PagerImagesModel copy({
    int? pagerId,
    String? pagerSection,
    String? type,
    String? typeId,
    String? imageUrl,
  }) =>
      PagerImagesModel(
        pagerId: pagerId ?? this.pagerId,
        pagerSection: pagerSection ?? this.pagerSection,
        type: type ?? this.type,
        typeId: typeId ?? this.typeId,
        imageUrl: imageUrl ?? this.imageUrl,
      );
}
