import 'package:danapaniexpress/data/models/address_model.dart';

const String usersTable = 'users';

class UserFields {
  static final List<String> values = [
    userId,
    userFullName,
    userEmail,
    userPhone,
    userPassword,
    userImage,
    userDefaultAddress,
    userRegisterDateTime,
    userCartCount,
    userFavoritesCount,
    userOrdersCount,
    addressBook,
  ];

  static const String userId = 'user_id';
  static const String userFullName = 'user_full_name';
  static const String userEmail = 'user_email';
  static const String userPhone = 'user_phone';
  static const String userPassword = 'user_password';
  static const String userImage = 'user_image';
  static const String userDefaultAddress = 'user_default_address';
  static const String userRegisterDateTime = 'user_register_date_time';
  static const String userCartCount = 'user_cart_count';
  static const String userFavoritesCount = 'user_favorites_count';
  static const String userOrdersCount = 'user_orders_count';
  static const String addressBook = 'user_address_book';
}

class UserModel {
  final String? userId;
  final String? userFullName;
  final String? userEmail;
  final String? userPhone;
  final String? userPassword;
  final String? userImage;
  final AddressModel? userDefaultAddress;
  final String? userRegisterDateTime;
  final int? userCartCount;
  final int? userFavoritesCount;
  final int? userOrdersCount;
  final List<AddressModel>? addressBook;

  const UserModel({
    this.userId,
    this.userFullName,
    this.userEmail,
    this.userPhone,
    this.userPassword,
    this.userImage,
    this.userDefaultAddress,
    this.userRegisterDateTime,
    this.userCartCount,
    this.userFavoritesCount,
    this.userOrdersCount,
    this.addressBook,
  });

  Map<String, Object?> toJson() => {
    UserFields.userId: userId,
    UserFields.userFullName: userFullName,
    UserFields.userEmail: userEmail,
    UserFields.userPhone: userPhone,
    UserFields.userPassword: userPassword,
    UserFields.userImage: userImage,
    UserFields.userDefaultAddress:
    userDefaultAddress?.toJson(), // ✅ updated
    UserFields.userRegisterDateTime: userRegisterDateTime,
    UserFields.userCartCount: userCartCount,
    UserFields.userFavoritesCount: userFavoritesCount,
    UserFields.userOrdersCount: userOrdersCount,
    UserFields.addressBook:
    addressBook?.map((e) => e.toJson()).toList(), // ✅ updated
  };

  static UserModel fromJson(Map<String, Object?> json) => UserModel(
    userId: json[UserFields.userId] as String?,
    userFullName: json[UserFields.userFullName] as String?,
    userEmail: json[UserFields.userEmail] as String?,
    userPhone: json[UserFields.userPhone] as String?,
    userPassword: json[UserFields.userPassword] as String?,
    userImage: json[UserFields.userImage] as String?,
    userDefaultAddress: json[UserFields.userDefaultAddress] != null
        ? AddressModel.fromJson(
        json[UserFields.userDefaultAddress]
        as Map<String, Object?>) // ✅ updated
        : null,
    userRegisterDateTime:
    json[UserFields.userRegisterDateTime] as String?,
    userCartCount: json[UserFields.userCartCount] as int?,
    userFavoritesCount: json[UserFields.userFavoritesCount] as int?,
    userOrdersCount: json[UserFields.userOrdersCount] as int?,
    addressBook: (json[UserFields.addressBook] as List<dynamic>?)
        ?.map((e) => AddressModel.fromJson(e as Map<String, Object?>))
        .toList(), // ✅ updated
  );

  UserModel copy({
    String? userId,
    String? userFullName,
    String? userEmail,
    String? userPhone,
    String? userPassword,
    String? userImage,
    AddressModel? userDefaultAddress, // ✅ updated
    String? userRegisterDateTime,
    int? userCartCount,
    int? userFavoritesCount,
    int? userOrdersCount,
    List<AddressModel>? addressBook,
  }) =>
      UserModel(
        userId: userId ?? this.userId,
        userFullName: userFullName ?? this.userFullName,
        userEmail: userEmail ?? this.userEmail,
        userPhone: userPhone ?? this.userPhone,
        userPassword: userPassword ?? this.userPassword,
        userImage: userImage ?? this.userImage,
        userDefaultAddress: userDefaultAddress ?? this.userDefaultAddress,
        userRegisterDateTime:
        userRegisterDateTime ?? this.userRegisterDateTime,
        userCartCount: userCartCount ?? this.userCartCount,
        userFavoritesCount: userFavoritesCount ?? this.userFavoritesCount,
        userOrdersCount: userOrdersCount ?? this.userOrdersCount,
        addressBook: addressBook ?? this.addressBook,
      );
}
