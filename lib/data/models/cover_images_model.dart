const String coverImagesTable = 'cover_images';

class CoverImagesFields {
  static final List<String> values = [
    featured,
    flashSale,
    popular,
  ];

  static const String featured = 'featured';
  static const String flashSale = 'flash_sale';
  static const String popular = 'popular';
}

class CoverImagesModel {
  final String? featured;
  final String? flashSale;
  final String? popular;

  const CoverImagesModel({
    this.featured,
    this.flashSale,
    this.popular,
  });

  Map<String, Object?> toJson() => {
    CoverImagesFields.featured: featured,
    CoverImagesFields.flashSale: flashSale,
    CoverImagesFields.popular: popular,
  };

  static CoverImagesModel fromJson(Map<String, Object?> json) => CoverImagesModel(
    featured: json[CoverImagesFields.featured] as String?,
    flashSale: json[CoverImagesFields.flashSale] as String?,
    popular: json[CoverImagesFields.popular] as String?,
  );

  CoverImagesModel copy({
    String? featured,
    String? flashSale,
    String? popular,
  }) =>
      CoverImagesModel(
        featured: featured ?? this.featured,
        flashSale: flashSale ?? this.flashSale,
        popular: popular ?? this.popular,
      );
}