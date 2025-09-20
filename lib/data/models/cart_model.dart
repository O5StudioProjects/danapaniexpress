import 'package:danapaniexpress/core/data_model_imports.dart';

class CartModel {
  final String userId;
  final double totalSellingPrice;
  final double totalCutPrice;
  final List<ProductModel> products;

  CartModel({
    required this.userId,
    required this.totalSellingPrice,
    required this.totalCutPrice,
    required this.products,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      userId: json['user_id'] ?? '',
      totalSellingPrice: (json['total_selling_price'] ?? 0).toDouble(),
      totalCutPrice: (json['total_cut_price'] ?? 0).toDouble(),
      products: (json['products'] as List<dynamic>? ?? [])
          .map((p) {
        final product = ProductModel.fromJson(p as Map<String, dynamic>);
        // Force productQuantity from "product_qty" field in cart API
        return product.copy(
          productQuantity: int.tryParse(p['product_qty']?.toString() ?? '0'),
          productQuantityLimit: int.tryParse(p['product_quantity_limit']?.toString() ?? '0'),
        );
      })
          .toList(),
    );
  }
}

