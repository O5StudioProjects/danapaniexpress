import 'package:danapaniexpress/core/data_model_imports.dart';

const String featuredProductTable = 'featured_product';

class FeaturedProductFields {
  static final List<String> values = [
    featuredId,
    product,
  ];

  static const String featuredId = 'featured_id';
  static const String product = 'product';
}

class FeaturedProductModel {
  final String? featuredId;
  final ProductModel? product;

  const FeaturedProductModel({
    this.featuredId,
    this.product,
  });

  factory FeaturedProductModel.fromJson(Map<String, dynamic> json) => FeaturedProductModel(
    featuredId: json[FeaturedProductFields.featuredId] as String?,
    product: json[FeaturedProductFields.product] != null
        ? ProductModel.fromJson(json[FeaturedProductFields.product] as Map<String, dynamic>)
        : null,
  );

  Map<String, dynamic> toJson() => {
    FeaturedProductFields.featuredId: featuredId,
    FeaturedProductFields.product: product?.toJson(),
  };
}
