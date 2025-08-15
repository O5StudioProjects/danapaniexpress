
import 'package:danapaniexpress/core/data_model_imports.dart';

const String orderedProductTable = 'ordered_products';

class OrderedProductFields {
  static const String userId = 'user_id';
  static const String orderId = 'order_id';
  static const String orderNumber = 'order_number';
  static const String productId = 'product_id';
  static const String productNameEng = 'product_name_eng';
  static const String productNameUrdu = 'product_name_urdu';
  static const String productNameArabic = 'product_name_arabic';
  static const String productDetailEng = 'product_detail_eng';
  static const String productDetailUrdu = 'product_detail_urdu';
  static const String productDetailArabic = 'product_detail_arabic';
  static const String productImage = 'product_image';
  static const String productSellingPrice = 'product_selling_price';
  static const String productCutPrice = 'product_cut_price';
  static const String productQty = 'product_qty';
  static const String productWeightGrams = 'product_weight_grams';
  static const String productSize = 'product_size';
  static const String productBrand = 'product_brand';
  static const String vendor = 'Vendor';

  static final List<String> values = [
    userId,
    orderId,
    orderNumber,
    productId,
    productNameEng,
    productNameUrdu,
    productNameArabic,
    productDetailEng,
    productDetailUrdu,
    productDetailArabic,
    productImage,
    productSellingPrice,
    productCutPrice,
    productQty,
    productWeightGrams,
    productSize,
    productBrand,
    vendor,
  ];
}

class OrderedProductModel {
  final String? userId;
  final String? orderId;
  final String? orderNumber;
  final String? productId;
  final String? productNameEng;
  final String? productNameUrdu;
  final String? productNameArabic;
  final String? productDetailEng;
  final String? productDetailUrdu;
  final String? productDetailArabic;
  final String? productImage;
  final double? productSellingPrice;
  final double? productCutPrice;
  final int? productQty;
  final int? productWeightGrams;
  final String? productSize;
  final String? productBrand;
  final VendorModel? vendor;

  const OrderedProductModel({
    this.userId,
    this.orderId,
    this.orderNumber,
    this.productId,
    this.productNameEng,
    this.productNameUrdu,
    this.productNameArabic,
    this.productDetailEng,
    this.productDetailUrdu,
    this.productDetailArabic,
    this.productImage,
    this.productSellingPrice,
    this.productCutPrice,
    this.productQty,
    this.productWeightGrams,
    this.productSize,
    this.productBrand,
    this.vendor,
  });

  factory OrderedProductModel.fromJson(Map<String, dynamic> json) {
    return OrderedProductModel(
      userId: json['user_id'],
      orderId: json['order_id'],
      orderNumber: json['order_number'],
      productId: json['product_id'],
      productNameEng: json['product_name_eng'],
      productNameUrdu: json['product_name_urdu'],
      productNameArabic: json['product_name_arabic'],
      productDetailEng: json['product_detail_eng'],
      productDetailUrdu: json['product_detail_urdu'],
      productDetailArabic: json['product_detail_arabic'],
      productImage: json['product_image'],
      productSellingPrice: (json['product_selling_price'] as num?)?.toDouble(),
      productCutPrice: (json['product_cut_price'] as num?)?.toDouble(),
      productQty: json['product_qty'],
      productWeightGrams: json['product_weight_grams'],
      productSize: json['product_size'],
      productBrand: json['product_brand'],
      vendor: json['Vendor'] != null ? VendorModel.fromJson(json['Vendor']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'order_id': orderId,
      'order_number': orderNumber,
      'product_id': productId,
      'product_name_eng': productNameEng,
      'product_name_urdu': productNameUrdu,
      'product_name_arabic': productNameArabic,
      'product_detail_eng': productDetailEng,
      'product_detail_urdu': productDetailUrdu,
      'product_detail_arabic': productDetailArabic,
      'product_image': productImage,
      'product_selling_price': productSellingPrice,
      'product_cut_price': productCutPrice,
      'product_qty': productQty,
      'product_weight_grams': productWeightGrams,
      'product_size': productSize,
      'product_brand': productBrand,
      'Vendor': vendor?.toJson(),
    };
  }
}
