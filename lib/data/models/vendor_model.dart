import 'package:danapaniexpress/core/data_model_imports.dart';

const String vendorsTable = 'vendors';

class VendorFields {
  static final List<String> values = [
    vendorId,
    vendorLogo,
    vendorCoverImage,
    vendorShopAddress,
    vendorShopDescription,
    vendorMobile,
    vendorEmail,
    vendorName,
    vendorWebsite,
    vendorPassword,
    followers,
  ];

  static const String vendorId = 'vendor_id';
  static const String vendorLogo = 'vendor_logo';
  static const String vendorCoverImage = 'vendor_cover_image';
  static const String vendorShopAddress = 'vendor_shop_address';
  static const String vendorShopDescription = 'vendor_shop_description';
  static const String vendorMobile = 'vendor_mobile';
  static const String vendorEmail = 'vendor_email';
  static const String vendorName = 'vendor_name';
  static const String vendorWebsite = 'vendor_website';
  static const String vendorPassword = 'vendor_password';
  static const String followers = 'followers';
}

class VendorModel {
  final String? vendorId;
  final String? vendorLogo;
  final String? vendorCoverImage;
  final String? vendorShopAddress;
  final String? vendorShopDescription;
  final String? vendorMobile;
  final String? vendorEmail;
  final String? vendorName;
  final String? vendorWebsite;
  final String? vendorPassword;
  final List<UserIdModel>? followers;

  const VendorModel({
    this.vendorId,
    this.vendorLogo,
    this.vendorCoverImage,
    this.vendorShopAddress,
    this.vendorShopDescription,
    this.vendorMobile,
    this.vendorEmail,
    this.vendorName,
    this.vendorWebsite,
    this.vendorPassword,
    this.followers,
  });

  Map<String, Object?> toJson() => {
    VendorFields.vendorId: vendorId,
    VendorFields.vendorLogo: vendorLogo,
    VendorFields.vendorCoverImage: vendorCoverImage,
    VendorFields.vendorShopAddress: vendorShopAddress,
    VendorFields.vendorShopDescription: vendorShopDescription,
    VendorFields.vendorMobile: vendorMobile,
    VendorFields.vendorEmail: vendorEmail,
    VendorFields.vendorName: vendorName,
    VendorFields.vendorWebsite: vendorWebsite,
    VendorFields.vendorPassword: vendorPassword,
    VendorFields.followers: followers?.map((e) => e.toJson()).toList(),
  };

  static VendorModel fromJson(Map<String, dynamic> json) => VendorModel(
    vendorId: json[VendorFields.vendorId]?.toString(),
    vendorLogo: json[VendorFields.vendorLogo]?.toString(),
    vendorCoverImage: json[VendorFields.vendorCoverImage]?.toString(),
    vendorShopAddress: json[VendorFields.vendorShopAddress]?.toString(),
    vendorShopDescription: json[VendorFields.vendorShopDescription]?.toString(),
    vendorMobile: json[VendorFields.vendorMobile]?.toString(),
    vendorEmail: json[VendorFields.vendorEmail]?.toString(),
    vendorName: json[VendorFields.vendorName]?.toString(),
    vendorWebsite: json[VendorFields.vendorWebsite]?.toString(),
    vendorPassword: json[VendorFields.vendorPassword]?.toString(),
    followers: (json[VendorFields.followers] as List<dynamic>?)
        ?.map((e) => UserIdModel.fromJson(e)).toList(),
  );

  VendorModel copy({
    String? vendorId,
    String? vendorLogo,
    String? vendorCoverImage,
    String? vendorShopAddress,
    String? vendorShopDescription,
    String? vendorMobile,
    String? vendorEmail,
    String? vendorName,
    String? vendorWebsite,
    String? vendorPassword,
    List<UserIdModel>? followers,
  }) =>
      VendorModel(
        vendorId: vendorId ?? this.vendorId,
        vendorLogo: vendorLogo ?? this.vendorLogo,
        vendorCoverImage: vendorCoverImage ?? this.vendorCoverImage,
        vendorShopAddress: vendorShopAddress ?? this.vendorShopAddress,
        vendorShopDescription: vendorShopDescription ?? this.vendorShopDescription,
        vendorMobile: vendorMobile ?? this.vendorMobile,
        vendorEmail: vendorEmail ?? this.vendorEmail,
        vendorName: vendorName ?? this.vendorName,
        vendorWebsite: vendorWebsite ?? this.vendorWebsite,
        vendorPassword: vendorPassword ?? this.vendorPassword,
        followers: followers ?? this.followers,
      );
}
