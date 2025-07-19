class FavoritesFields {
  static final List<String> values = [
    userId,
    productId,
    dateTime,
  ];

  static const String userId = 'user_id';
  static const String productId = 'product_id';
  static const String dateTime = 'date_time';
}

class FavoritesModel {
  final String? userId;
  final String? productId;
  final String? dateTime;

  const FavoritesModel({
    this.userId,
    this.productId,
    this.dateTime,
  });

  Map<String, Object?> toJson() => {
    FavoritesFields.userId: userId,
    FavoritesFields.productId: productId,
    FavoritesFields.dateTime: dateTime,
  };

  static FavoritesModel fromJson(Map<String, Object?> json) => FavoritesModel(
    userId: json[FavoritesFields.userId] as String?,
    productId: json[FavoritesFields.productId] as String?,
    dateTime: json[FavoritesFields.dateTime] as String?,
  );

  FavoritesModel copy({
    String? userId,
    String? productId,
    String? dateTime,
  }) =>
      FavoritesModel(
        userId: userId ?? this.userId,
        productId: productId ?? this.productId,
        dateTime: dateTime ?? this.dateTime,
      );
}
