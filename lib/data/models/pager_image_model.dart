const String pagerImagesTable = 'pager_images';

class PagerImagesFields {
  static final List<String> values = [
    sliderId, type, typeId, imageUrl,
  ];

  static const String sliderId = 'pager_id';
  static const String type = 'type';
  static const String typeId = 'type_id';
  static const String imageUrl = 'image_url';
}

class PagerImagesModel {
  final String? sliderId;
  final String? type;
  final String? typeId;
  final String? imageUrl;

  const PagerImagesModel({
    required this.sliderId,
    required this.type,
    required this.typeId,
    required this.imageUrl,
  });

  Map<String, Object?> toJson() => {
    PagerImagesFields.sliderId: sliderId,
    PagerImagesFields.type: type,
    PagerImagesFields.typeId: typeId,
    PagerImagesFields.imageUrl: imageUrl,
  };

  static PagerImagesModel fromJson(Map<String, Object?> json) => PagerImagesModel(
    sliderId: json[PagerImagesFields.sliderId] as String?,
    type: json[PagerImagesFields.type] as String?,
    typeId: json[PagerImagesFields.typeId] as String?,
    imageUrl: json[PagerImagesFields.imageUrl] as String?,
  );

  PagerImagesModel copy({
    String? sliderId,
    String? type,
    String? typeId,
    String? imageUrl,
  }) =>
      PagerImagesModel(
        sliderId: sliderId ?? this.sliderId,
        type: type ?? this.type,
        typeId: typeId ?? this.typeId,
        imageUrl: imageUrl ?? this.imageUrl,
      );
}
