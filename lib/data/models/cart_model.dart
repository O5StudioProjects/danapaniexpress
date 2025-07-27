import 'package:danapaniexpress/core/data_model_imports.dart';

const String cartTable = 'cart';

class CartFields {
  static const String userId = 'user_id';
  static const String products = 'products';

  static final List<String> values = [
    userId,
    products,
  ];
}

class CartModel {
  final String? userId;
  final List<ProductModel>? products;

  const CartModel({
    this.userId,
    this.products,
  });

  CartModel copy({
    String? userId,
    List<ProductModel>? products,
  }) =>
      CartModel(
        userId: userId ?? this.userId,
        products: products ?? this.products,
      );

  static CartModel fromJson(Map<String, dynamic> json) => CartModel(
    userId: json[CartFields.userId],
    products: json[CartFields.products] == null
        ? []
        : List<ProductModel>.from(
        json[CartFields.products]
            .map((x) => ProductModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    CartFields.userId: userId,
    CartFields.products:
    products?.map((x) => x.toJson()).toList(),
  };
}
