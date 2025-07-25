import 'package:danapaniexpress/data/models/products_model.dart';

class PaginatedProducts {
  final List<ProductModel> products;
  final int totalCount;

  PaginatedProducts({
    required this.products,
    required this.totalCount,
  });

  factory PaginatedProducts.fromJson(Map<String, dynamic> json) {
    return PaginatedProducts(
      products: (json['products'] as List).map((e) => ProductModel.fromJson(e)).toList(),
      totalCount: int.parse(json['total_count'].toString()),
    );
  }
}