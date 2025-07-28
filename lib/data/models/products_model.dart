import 'package:danapaniexpress/core/data_model_imports.dart';

const String productsTable = 'products';

class ProductFields {
  static final List<String> values = [
    productId,
    productCode,
    productImage,
    productNameEng,
    productNameUrdu,
    productDetailEng,
    productDetailUrdu,
    productCategory,
    productSubCategory,
    productCutPrice,
    productSellingPrice,
    productBuyingPrice,
    productSize,
    productWeightGrams,
    productBrand,
    productTotalSold,
    productRating,
    productIsFeatured,
    productFeaturedId,
    productIsFlashsale,
    productFlashsaleId,
    productFavoriteList,
    productAvailability,
    vendor,
    isSelected,
    productQuantityLimit,
    productQuantity,
    dateTime,
  ];

  static const String productId = 'product_id';
  static const String productCode = 'product_code';
  static const String productImage = 'product_image';
  static const String productNameEng = 'product_name_eng';
  static const String productNameUrdu = 'product_name_urdu';
  static const String productDetailEng = 'product_detail_eng';
  static const String productDetailUrdu = 'product_detail_urdu';
  static const String productCategory = 'product_category';
  static const String productSubCategory = 'product_sub_category';
  static const String productCutPrice = 'product_cut_price';
  static const String productSellingPrice = 'product_selling_price';
  static const String productBuyingPrice = 'product_buying_price';
  static const String productSize = 'product_size';
  static const String productWeightGrams = 'product_weight_grams';
  static const String productBrand = 'product_brand';
  static const String productTotalSold = 'product_total_sold';
  static const String productRating = 'product_rating';
  static const String productIsFeatured = 'product_is_featured';
  static const String productFeaturedId = 'product_featured_id';
  static const String productIsFlashsale = 'product_is_flashsale';
  static const String productFlashsaleId = 'product_flashsale_id';
  static const String productFavoriteList = 'product_favorite_list';
  static const String productAvailability = 'product_availability';
  static const String vendor = 'Vendor';
  static const String isSelected = 'is_selected';
  static const String productQuantityLimit = 'product_quantity_limit'; // API typo preserved
  static const String productQuantity = 'product_qty'; // API typo preserved
  static const String dateTime = 'date_time';
}

class ProductModel {
  final String? productId;
  final String? productCode;
  final String? productImage;
  final String? productNameEng;
  final String? productNameUrdu;
  final String? productDetailEng;
  final String? productDetailUrdu;
  final String? productCategory;
  final String? productSubCategory;
  final double? productCutPrice;
  final double? productSellingPrice;
  final double? productBuyingPrice;
  final String? productSize;
  final double? productWeightGrams;
  final String? productBrand;
  final int? productTotalSold;
  final double? productRating;
  final bool? productIsFeatured;
  final String? productFeaturedId;
  final bool? productIsFlashsale;
  final String? productFlashsaleId;
  final List<String>? productFavoriteList;
  final bool? productAvailability;
  final VendorModel? vendor;
  final bool? isSelected;
  final int? productQuantityLimit;
  final int? productQuantity;
  final String? dateTime;

  const ProductModel({
    this.productId,
    this.productCode,
    this.productImage,
    this.productNameEng,
    this.productNameUrdu,
    this.productDetailEng,
    this.productDetailUrdu,
    this.productCategory,
    this.productSubCategory,
    this.productCutPrice,
    this.productSellingPrice,
    this.productBuyingPrice,
    this.productSize,
    this.productWeightGrams,
    this.productBrand,
    this.productTotalSold,
    this.productRating,
    this.productIsFeatured,
    this.productFeaturedId,
    this.productIsFlashsale,
    this.productFlashsaleId,
    this.productFavoriteList,
    this.productAvailability,
    this.vendor,
    this.isSelected,
    this.productQuantityLimit,
    this.productQuantity,
    this.dateTime,
  });

  /// Check if this product is favorited by a specific user
  bool isFavoriteBy(String userId) {
    return productFavoriteList?.contains(userId) ?? false;
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    productId: json[ProductFields.productId]?.toString(),
    productCode: json[ProductFields.productCode]?.toString(),
    productImage: json[ProductFields.productImage]?.toString(),
    productNameEng: json[ProductFields.productNameEng]?.toString(),
    productNameUrdu: json[ProductFields.productNameUrdu]?.toString(),
    productDetailEng: json[ProductFields.productDetailEng]?.toString(),
    productDetailUrdu: json[ProductFields.productDetailUrdu]?.toString(),
    productCategory: json[ProductFields.productCategory]?.toString(),
    productSubCategory: json[ProductFields.productSubCategory]?.toString(),
    productCutPrice: double.tryParse(json[ProductFields.productCutPrice]?.toString() ?? ''),
    productSellingPrice: double.tryParse(json[ProductFields.productSellingPrice]?.toString() ?? ''),
    productBuyingPrice: double.tryParse(json[ProductFields.productBuyingPrice]?.toString() ?? ''),
    productSize: json[ProductFields.productSize]?.toString(),
    productWeightGrams: double.tryParse(json[ProductFields.productWeightGrams]?.toString() ?? ''),
    productBrand: json[ProductFields.productBrand]?.toString(),
    productTotalSold: int.tryParse(json[ProductFields.productTotalSold]?.toString() ?? ''),
    productRating: double.tryParse(json[ProductFields.productRating]?.toString() ?? ''),
    productIsFeatured: json[ProductFields.productIsFeatured] == true || json[ProductFields.productIsFeatured]?.toString() == '1',
    productFeaturedId: json[ProductFields.productFeaturedId]?.toString(),
    productIsFlashsale: json[ProductFields.productIsFlashsale] == true || json[ProductFields.productIsFlashsale]?.toString() == '1',
    productFlashsaleId: json[ProductFields.productFlashsaleId]?.toString(),
    productFavoriteList: (json[ProductFields.productFavoriteList] as List<dynamic>?)
        ?.map((e) => e['user_id'].toString())
        .toList(),
    productAvailability: json[ProductFields.productAvailability] == true || json[ProductFields.productAvailability]?.toString() == '1',
    vendor: json[ProductFields.vendor] != null ? VendorModel.fromJson(json[ProductFields.vendor]) : null,
    isSelected: json[ProductFields.isSelected] == true,
    productQuantityLimit: int.tryParse(json[ProductFields.productQuantityLimit]?.toString() ?? ''),
    productQuantity: int.tryParse(json[ProductFields.productQuantity]?.toString() ?? ''),
    dateTime: json[ProductFields.dateTime]?.toString(),
  );

  Map<String, dynamic> toJson() =>
      {
        ProductFields.productId: productId,
        ProductFields.productCode: productCode,
        ProductFields.productImage: productImage,
        ProductFields.productNameEng: productNameEng,
        ProductFields.productNameUrdu: productNameUrdu,
        ProductFields.productDetailEng: productDetailEng,
        ProductFields.productDetailUrdu: productDetailUrdu,
        ProductFields.productCategory: productCategory,
        ProductFields.productSubCategory: productSubCategory,
        ProductFields.productCutPrice: productCutPrice,
        ProductFields.productSellingPrice: productSellingPrice,
        ProductFields.productBuyingPrice: productBuyingPrice,
        ProductFields.productSize: productSize,
        ProductFields.productWeightGrams: productWeightGrams,
        ProductFields.productBrand: productBrand,
        ProductFields.productTotalSold: productTotalSold,
        ProductFields.productRating: productRating,
        ProductFields.productIsFeatured: productIsFeatured,
        ProductFields.productFeaturedId: productFeaturedId,
        ProductFields.productIsFlashsale: productIsFlashsale,
        ProductFields.productFlashsaleId: productFlashsaleId,
        ProductFields.productFavoriteList: productFavoriteList?.map((id) =>
        {
          'user_id': id
        }).toList(),
        ProductFields.productAvailability: productAvailability,
        ProductFields.vendor: vendor?.toJson(),
        ProductFields.isSelected: isSelected,
        ProductFields.productQuantityLimit: productQuantityLimit,
        ProductFields.productQuantity: productQuantity,
        ProductFields.dateTime: dateTime,
      };

  ProductModel copy({
    String? productId,
    String? productCode,
    String? productImage,
    String? productNameEng,
    String? productNameUrdu,
    String? productDetailEng,
    String? productDetailUrdu,
    String? productCategory,
    String? productSubCategory,
    double? productCutPrice,
    double? productSellingPrice,
    double? productBuyingPrice,
    String? productSize,
    double? productWeightGrams,
    String? productBrand,
    int? productTotalSold,
    double? productRating,
    bool? productIsFeatured,
    String? productFeaturedId,
    bool? productIsFlashsale,
    String? productFlashsaleId,
    List<String>? productFavoriteList,
    bool? productAvailability,
    VendorModel? vendor,
    bool? isSelected,
    int? productQuantityLimit,
    int? productQuantity,
    String? dateTime,
  }) =>
      ProductModel(
        productId: productId ?? this.productId,
        productCode: productCode ?? this.productCode,
        productImage: productImage ?? this.productImage,
        productNameEng: productNameEng ?? this.productNameEng,
        productNameUrdu: productNameUrdu ?? this.productNameUrdu,
        productDetailEng: productDetailEng ?? this.productDetailEng,
        productDetailUrdu: productDetailUrdu ?? this.productDetailUrdu,
        productCategory: productCategory ?? this.productCategory,
        productSubCategory: productSubCategory ?? this.productSubCategory,
        productCutPrice: productCutPrice ?? this.productCutPrice,
        productSellingPrice: productSellingPrice ?? this.productSellingPrice,
        productBuyingPrice: productBuyingPrice ?? this.productBuyingPrice,
        productSize: productSize ?? this.productSize,
        productWeightGrams: productWeightGrams ?? this.productWeightGrams,
        productBrand: productBrand ?? this.productBrand,
        productTotalSold: productTotalSold ?? this.productTotalSold,
        productRating: productRating ?? this.productRating,
        productIsFeatured: productIsFeatured ?? this.productIsFeatured,
        productFeaturedId: productFeaturedId ?? this.productFeaturedId,
        productIsFlashsale: productIsFlashsale ?? this.productIsFlashsale,
        productFlashsaleId: productFlashsaleId ?? this.productFlashsaleId,
        productFavoriteList: productFavoriteList ?? this.productFavoriteList,
        productAvailability: productAvailability ?? this.productAvailability,
        vendor: vendor ?? this.vendor,
        isSelected: isSelected ?? this.isSelected,
        productQuantityLimit: productQuantityLimit ?? this.productQuantityLimit,
        productQuantity: productQuantity ?? this.productQuantity,
        dateTime: dateTime ?? this.dateTime,
      );
}
