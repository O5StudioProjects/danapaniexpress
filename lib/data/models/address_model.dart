const String addressesTable = 'addresses';

class AddressFields {
  static final List<String> values = [
    addressId,
    userId,
    name,
    phone,
    address,
    nearestPlace,
    city,
    province,
    postalCode,
  ];

  static const String addressId = 'address_id';
  static const String userId = 'user_id';
  static const String name = 'name';
  static const String phone = 'phone';
  static const String address = 'address';
  static const String nearestPlace = 'nearest_place';
  static const String city = 'city';
  static const String province = 'province';
  static const String postalCode = 'postal_code';
}

class AddressModel {
  final String? addressId;
  final String? userId;
  final String? name;
  final String? phone;
  final String? address;
  final String? nearestPlace;
  final String? city;
  final String? province;
  final String? postalCode;

  const AddressModel({
    this.addressId,
    this.userId,
    this.name,
    this.phone,
    this.address,
    this.nearestPlace,
    this.city,
    this.province,
    this.postalCode,
  });

  Map<String, Object?> toJson() => {
    AddressFields.addressId: addressId,
    AddressFields.userId: userId,
    AddressFields.name: name,
    AddressFields.phone: phone,
    AddressFields.address: address,
    AddressFields.nearestPlace: nearestPlace,
    AddressFields.city: city,
    AddressFields.province: province,
    AddressFields.postalCode: postalCode,
  };

  static AddressModel fromJson(Map<String, Object?> json) => AddressModel(
    addressId: json[AddressFields.addressId] as String?,
    userId: json[AddressFields.userId] as String?,
    name: json[AddressFields.name] as String?,
    phone: json[AddressFields.phone] as String?,
    address: json[AddressFields.address] as String?,
    nearestPlace: json[AddressFields.nearestPlace] as String?,
    city: json[AddressFields.city] as String?,
    province: json[AddressFields.province] as String?,
    postalCode: json[AddressFields.postalCode] as String?,
  );

  AddressModel copy({
    String? addressId,
    String? userId,
    String? name,
    String? phone,
    String? address,
    String? nearestPlace,
    String? city,
    String? province,
    String? postalCode,
  }) =>
      AddressModel(
        addressId: addressId ?? this.addressId,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        nearestPlace: nearestPlace ?? this.nearestPlace,
        city: city ?? this.city,
        province: province ?? this.province,
        postalCode: postalCode ?? this.postalCode,
      );
}
