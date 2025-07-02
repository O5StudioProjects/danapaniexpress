const String subCategoriesTable = 'sub_categories';

class SubCategoryFields {
  static final List<String> values = [
    categoryId,
    subCategoryId,
    subCategoryNameEnglish,
    subCategoryNameUrdu,
    subCategoryImage,
    subCategoryIsFeatured,
  ];

  static const String categoryId = 'category_id';
  static const String subCategoryId = 'sub_category_id';
  static const String subCategoryNameEnglish = 'sub_category_name_english';
  static const String subCategoryNameUrdu = 'sub_category_name_urdu';
  static const String subCategoryImage = 'sub_category_image';
  static const String subCategoryIsFeatured = 'sub_category_is_featured';
}

class SubCategoriesModel {
  final String? categoryId;
  final String? subCategoryId;
  final String? subCategoryNameEnglish;
  final String? subCategoryNameUrdu;
  final String? subCategoryImage;
  final bool? subCategoryIsFeatured;

  const SubCategoriesModel({
    this.categoryId,
    this.subCategoryId,
    this.subCategoryNameEnglish,
    this.subCategoryNameUrdu,
    this.subCategoryImage,
    this.subCategoryIsFeatured,
  });

  Map<String, Object?> toJson() => {
    SubCategoryFields.categoryId: categoryId,
    SubCategoryFields.subCategoryId: subCategoryId,
    SubCategoryFields.subCategoryNameEnglish: subCategoryNameEnglish,
    SubCategoryFields.subCategoryNameUrdu: subCategoryNameUrdu,
    SubCategoryFields.subCategoryImage: subCategoryImage,
    SubCategoryFields.subCategoryIsFeatured: subCategoryIsFeatured,
  };

  static SubCategoriesModel fromJson(Map<String, Object?> json) => SubCategoriesModel(
    categoryId: json[SubCategoryFields.categoryId] as String?,
    subCategoryId: json[SubCategoryFields.subCategoryId] as String?,
    subCategoryNameEnglish: json[SubCategoryFields.subCategoryNameEnglish] as String?,
    subCategoryNameUrdu: json[SubCategoryFields.subCategoryNameUrdu] as String?,
    subCategoryImage: json[SubCategoryFields.subCategoryImage] as String?,
    subCategoryIsFeatured: json[SubCategoryFields.subCategoryIsFeatured] as bool?,
  );

  SubCategoriesModel copy({
    String? categoryId,
    String? subCategoryId,
    String? subCategoryNameEnglish,
    String? subCategoryNameUrdu,
    String? subCategoryImage,
    bool? subCategoryIsFeatured,
  }) =>
      SubCategoriesModel(
        categoryId: categoryId ?? this.categoryId,
        subCategoryId: subCategoryId ?? this.subCategoryId,
        subCategoryNameEnglish: subCategoryNameEnglish ?? this.subCategoryNameEnglish,
        subCategoryNameUrdu: subCategoryNameUrdu ?? this.subCategoryNameUrdu,
        subCategoryImage: subCategoryImage ?? this.subCategoryImage,
        subCategoryIsFeatured: subCategoryIsFeatured ?? this.subCategoryIsFeatured,
      );
}
