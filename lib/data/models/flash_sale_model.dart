import 'package:danapaniexpress/core/data_model_imports.dart';

const String flashSaleProductsTable = 'flashsale_products';

class FlashSaleProductFields {
  static final List<String> values = [
    flashsaleId,
    product,
  ];

  static const String flashsaleId = 'flashsale_id';
  static const String product = 'product';
}

class FlashSaleProductModel {
  final String flashsaleId;
  final ProductModel product;

  FlashSaleProductModel({
    required this.flashsaleId,
    required this.product,
  });

  FlashSaleProductModel copyWith({
    String? flashsaleId,
    ProductModel? product,
  }) =>
      FlashSaleProductModel(
        flashsaleId: flashsaleId ?? this.flashsaleId,
        product: product ?? this.product,
      );

  factory FlashSaleProductModel.fromJson(Map<String, dynamic> json) =>
      FlashSaleProductModel(
        flashsaleId: json['flashsale_id'],
        product: ProductModel.fromJson(json['product']),
      );

  Map<String, dynamic> toJson() => {
    'flashsale_id': flashsaleId,
    'product': product.toJson(),
  };
}
