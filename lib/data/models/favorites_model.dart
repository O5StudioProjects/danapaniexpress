const String favoritesTable = 'favorites';

class FavoritesFields {
  static final List<String> values = [
    userId,
    productId,
  ];

  static const String userId = 'user_id';
  static const String productId = 'product_id';
}

class FavoritesModel {
  final String? userId;
  final String? productId;

  const FavoritesModel({
    this.userId,
    this.productId,
  });

  Map<String, Object?> toJson() => {
    FavoritesFields.userId: userId,
    FavoritesFields.productId: productId,
  };

  static FavoritesModel fromJson(Map<String, Object?> json) => FavoritesModel(
    userId: json[FavoritesFields.userId] as String?,
    productId: json[FavoritesFields.productId] as String?,
  );

  FavoritesModel copy({
    String? userId,
    String? productId,
  }) =>
      FavoritesModel(
        userId: userId ?? this.userId,
        productId: productId ?? this.productId,
      );
}
