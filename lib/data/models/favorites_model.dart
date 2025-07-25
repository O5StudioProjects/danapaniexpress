import 'package:danapaniexpress/core/data_model_imports.dart';

const String favoritesTable = 'favorites';

class FavoritesFields {
  static const String userId = 'user_id';
  static const String products = 'products';

  static final List<String> values = [
    userId,
    products,
  ];
}

class FavoritesModel {
  final String? userId;
  final List<ProductModel>? products;

  const FavoritesModel({
    this.userId,
    this.products,
  });

  FavoritesModel copy({
    String? userId,
    List<ProductModel>? products,
  }) =>
      FavoritesModel(
        userId: userId ?? this.userId,
        products: products ?? this.products,
      );

  static FavoritesModel fromJson(Map<String, dynamic> json) => FavoritesModel(
    userId: json[FavoritesFields.userId],
    products: json[FavoritesFields.products] == null
        ? []
        : List<ProductModel>.from(
        json[FavoritesFields.products].map((x) => ProductModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    FavoritesFields.userId: userId,
    FavoritesFields.products: products?.map((x) => x.toJson()).toList(),
  };
}
