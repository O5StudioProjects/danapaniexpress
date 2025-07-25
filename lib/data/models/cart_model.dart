const String cartTable = 'cart';

class CartFields {
  static final List<String> values = [
    cartId,
    userId,
    productId,
    productQty,
    dateTime,
  ];

  static const String cartId = 'cart_id';
  static const String userId = 'user_id';
  static const String productId = 'product_id';
  static const String productQty = 'product_qty';
  static const String dateTime = 'date_time';
}

class CartModel {
  final String? cartId;
  final String? userId;
  final String? productId;
  final int? productQty;
  final String? dateTime;

  const CartModel({
    this.cartId,
    this.userId,
    this.productId,
    this.productQty,
    this.dateTime,
  });

  CartModel copy({
    String? cartId,
    String? userId,
    String? productId,
    int? productQty,
    String? dateTime,
  }) =>
      CartModel(
        cartId: cartId ?? this.cartId,
        userId: userId ?? this.userId,
        productId: productId ?? this.productId,
        productQty: productQty ?? this.productQty,
        dateTime: dateTime ?? this.dateTime,
      );

  static CartModel fromJson(Map<String, dynamic> json) => CartModel(
    cartId: json[CartFields.cartId] as String?,
    userId: json[CartFields.userId] as String?,
    productId: json[CartFields.productId] as String?,
    productQty: json[CartFields.productQty] as int?,
    dateTime: json[CartFields.dateTime] as String?,
  );

  Map<String, dynamic> toJson() => {
    CartFields.cartId: cartId,
    CartFields.userId: userId,
    CartFields.productId: productId,
    CartFields.productQty: productQty,
    CartFields.dateTime: dateTime,
  };
}
