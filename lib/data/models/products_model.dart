import 'package:danapaniexpress/core/data_model_imports.dart';

const String productsTable = 'products';

class ProductsFields {
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
    productQuantityLimit,
    isSelected,
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
  static const String productQuantityLimit = 'prodcut_quantity_limit';
  static const String isSelected = 'is_selected';
  static const String dateTime = 'date_time';
}

class ProductsModel {
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
  final List<FavoritesModel>? productFavoriteList;
  final bool? productAvailability;
  final int? productQuantityLimit;
  final bool? isSelected;
  final String? dateTime;


  const ProductsModel({
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
    this.productQuantityLimit,
    this.isSelected,
    this.dateTime,
  });

  Map<String, Object?> toJson() => {
    ProductsFields.productId: productId,
    ProductsFields.productCode: productCode,
    ProductsFields.productImage: productImage,
    ProductsFields.productNameEng: productNameEng,
    ProductsFields.productNameUrdu: productNameUrdu,
    ProductsFields.productDetailEng: productDetailEng,
    ProductsFields.productDetailUrdu: productDetailUrdu,
    ProductsFields.productCategory: productCategory,
    ProductsFields.productSubCategory: productSubCategory,
    ProductsFields.productCutPrice: productCutPrice,
    ProductsFields.productSellingPrice: productSellingPrice,
    ProductsFields.productBuyingPrice: productBuyingPrice,
    ProductsFields.productSize: productSize,
    ProductsFields.productWeightGrams: productWeightGrams,
    ProductsFields.productBrand: productBrand,
    ProductsFields.productTotalSold: productTotalSold,
    ProductsFields.productRating: productRating,
    ProductsFields.productIsFeatured: productIsFeatured,
    ProductsFields.productFeaturedId: productFeaturedId,
    ProductsFields.productIsFlashsale: productIsFlashsale,
    ProductsFields.productFlashsaleId: productFlashsaleId,
    ProductsFields.productFavoriteList: productFavoriteList?.map((e) => e.toJson()).toList(),
    ProductsFields.productAvailability: productAvailability,
    ProductsFields.productQuantityLimit: productQuantityLimit,
    ProductsFields.isSelected: isSelected,
    ProductsFields.dateTime: dateTime,
  };

  static ProductsModel fromJson(Map<String, Object?> json) => ProductsModel(
    productId: json[ProductsFields.productId] as String?,
    productCode: json[ProductsFields.productCode] as String?,
    productImage: json[ProductsFields.productImage] as String?,
    productNameEng: json[ProductsFields.productNameEng] as String?,
    productNameUrdu: json[ProductsFields.productNameUrdu] as String?,
    productDetailEng: json[ProductsFields.productDetailEng] as String?,
    productDetailUrdu: json[ProductsFields.productDetailUrdu] as String?,
    productCategory: json[ProductsFields.productCategory] as String?,
    productSubCategory: json[ProductsFields.productSubCategory] as String?,
    productCutPrice: (json[ProductsFields.productCutPrice] as num?)?.toDouble(),
    productSellingPrice: (json[ProductsFields.productSellingPrice] as num?)?.toDouble(),
    productBuyingPrice: (json[ProductsFields.productBuyingPrice] as num?)?.toDouble(),
    productSize: json[ProductsFields.productSize] as String?,
    productWeightGrams: (json[ProductsFields.productWeightGrams] as num?)?.toDouble(),
    productBrand: json[ProductsFields.productBrand] as String?,
    productTotalSold: json[ProductsFields.productTotalSold] as int?,
    productRating: (json[ProductsFields.productRating] as num?)?.toDouble(),
    productIsFeatured: json[ProductsFields.productIsFeatured] as bool?,
    productFeaturedId: json[ProductsFields.productFeaturedId] as String?,
    productIsFlashsale: json[ProductsFields.productIsFlashsale] as bool?,
    productFlashsaleId: json[ProductsFields.productFlashsaleId] as String?,
    productFavoriteList: (json[ProductsFields.productFavoriteList] as List<dynamic>?)
        ?.map((e) => FavoritesModel.fromJson(e as Map<String, Object?>))
        .toList(),
    productAvailability: json[ProductsFields.productAvailability] as bool?,
    productQuantityLimit: json[ProductsFields.productQuantityLimit] as int?,
    isSelected: json[ProductsFields.isSelected] as bool?,
    dateTime: json[ProductsFields.dateTime] as String?,
  );

  ProductsModel copy({
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
    List<FavoritesModel>? productFavoriteList,
    bool? productAvailability,
    int? productQuantityLimit,
    bool? isSelected,
    String? dateTime,
  }) =>
      ProductsModel(
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
        productQuantityLimit: productQuantityLimit ?? this.productQuantityLimit,
        isSelected: isSelected ?? this.isSelected,
        dateTime: dateTime ?? this.dateTime,
      );
}

