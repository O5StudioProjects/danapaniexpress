const String sliderImagesTable = 'slider_images';

class SliderImagesFields {
  static final List<String> values = [
    sliderId, type, typeId, imageUrl,
  ];

  static const String sliderId = 'slider_id';
  static const String type = 'type';
  static const String typeId = 'type_id';
  static const String imageUrl = 'image_url';
}

class SliderImagesModel {
  final String? sliderId;
  final String? type;
  final String? typeId;
  final String? imageUrl;

  const SliderImagesModel({
    required this.sliderId,
    required this.type,
    required this.typeId,
    required this.imageUrl,
  });

  Map<String, Object?> toJson() => {
    SliderImagesFields.sliderId: sliderId,
    SliderImagesFields.type: type,
    SliderImagesFields.typeId: typeId,
    SliderImagesFields.imageUrl: imageUrl,
  };

  static SliderImagesModel fromJson(Map<String, Object?> json) => SliderImagesModel(
    sliderId: json[SliderImagesFields.sliderId] as String?,
    type: json[SliderImagesFields.type] as String?,
    typeId: json[SliderImagesFields.typeId] as String?,
    imageUrl: json[SliderImagesFields.imageUrl] as String?,
  );

  SliderImagesModel copy({
    String? sliderId,
    String? type,
    String? typeId,
    String? imageUrl,
  }) =>
      SliderImagesModel(
        sliderId: sliderId ?? this.sliderId,
        type: type ?? this.type,
        typeId: typeId ?? this.typeId,
        imageUrl: imageUrl ?? this.imageUrl,
      );
}
