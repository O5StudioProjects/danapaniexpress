import 'package:danapaniexpress/core/data_model_imports.dart';
const String categoriesTable = 'categories';

class CategoryFields {
  static final List<String> values = [
    categoryId,
    categoryNameEnglish,
    categoryNameUrdu,
    categoryImage,
    categoryCoverImage,
    categoryIsFeatured,
    subCategories,
  ];

  static const String categoryId = 'category_id';
  static const String categoryNameEnglish = 'category_name_english';
  static const String categoryNameUrdu = 'category_name_urdu';
  static const String categoryImage = 'category_image';
  static const String categoryCoverImage = 'category_cover_image';
  static const String categoryIsFeatured = 'category_is_featured';
  static const String subCategories = 'sub_categories';
}

class CategoryModel {
  final String? categoryId;
  final String? categoryNameEnglish;
  final String? categoryNameUrdu;
  final String? categoryImage;
  final String? categoryCoverImage;
  final bool? categoryIsFeatured;
  final List<SubCategoriesModel>? subCategories;

  const CategoryModel({
    this.categoryId,
    this.categoryNameEnglish,
    this.categoryNameUrdu,
    this.categoryImage,
    this.categoryCoverImage,
    this.categoryIsFeatured,
    this.subCategories,
  });

  Map<String, Object?> toJson() => {
    CategoryFields.categoryId: categoryId,
    CategoryFields.categoryNameEnglish: categoryNameEnglish,
    CategoryFields.categoryNameUrdu: categoryNameUrdu,
    CategoryFields.categoryImage: categoryImage,
    CategoryFields.categoryCoverImage: categoryCoverImage,
    CategoryFields.categoryIsFeatured: categoryIsFeatured,
    CategoryFields.subCategories: subCategories?.map((e) => e.toJson()).toList(),
  };

  static CategoryModel fromJson(Map<String, Object?> json) => CategoryModel(
    categoryId: json[CategoryFields.categoryId] as String?,
    categoryNameEnglish: json[CategoryFields.categoryNameEnglish] as String?,
    categoryNameUrdu: json[CategoryFields.categoryNameUrdu] as String?,
    categoryImage: json[CategoryFields.categoryImage] as String?,
    categoryCoverImage: json[CategoryFields.categoryCoverImage] as String?,
    categoryIsFeatured: json[CategoryFields.categoryIsFeatured] as bool?,
    subCategories: (json[CategoryFields.subCategories] as List<dynamic>?)
        ?.map((e) => SubCategoriesModel.fromJson(e))
        .toList(),
  );

  CategoryModel copy({
    String? categoryId,
    String? categoryNameEnglish,
    String? categoryNameUrdu,
    String? categoryImage,
    String? categoryCoverImage,
    bool? categoryIsFeatured,
    List<SubCategoriesModel>? subCategories,
  }) =>
      CategoryModel(
        categoryId: categoryId ?? this.categoryId,
        categoryNameEnglish: categoryNameEnglish ?? this.categoryNameEnglish,
        categoryNameUrdu: categoryNameUrdu ?? this.categoryNameUrdu,
        categoryImage: categoryImage ?? this.categoryImage,
        categoryCoverImage: categoryCoverImage ?? this.categoryCoverImage,
        categoryIsFeatured: categoryIsFeatured ?? this.categoryIsFeatured,
        subCategories: subCategories ?? this.subCategories,
      );
}
