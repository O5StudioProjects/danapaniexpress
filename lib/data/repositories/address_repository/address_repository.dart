

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:danapaniexpress/core/common_imports.dart';

class AddressRepository extends BaseRepository{

  ///ADD USER ADDRESS
  Future<Map<String, dynamic>> addAddressApi({
    required String userId,
    required String name,
    required String phone,
    required String address,
    required String nearestPlace,
    required String city,
    required String province,
    required String postalCode,
    bool setAsDefault = true,
  }) async {
    return await postRequest(
      Uri.parse(APiEndpoints.addUserAddress),
      headers: apiHeaders,
      body: {
        'user_id': userId,
        'user_full_name': name,
        'user_phone': phone,
        'default_address_address': address,
        'default_address_nearest_place': nearestPlace,
        'default_address_city': city,
        'default_address_province': province,
        'default_address_postal_code': postalCode,
        'set_as_default': setAsDefault,
      },
    );
  }

  /// DELETE ADDRESS REPOSITORY
  Future<Map<String, dynamic>> deleteAddressApi({
    required String userId,
    required String addressId,
  }) async {
    return await postRequest(
      Uri.parse(APiEndpoints.deleteAddress),
      headers: apiHeaders,
      body: {
        'user_id': userId,
        'address_id': addressId,
      },
    );
  }

  /// UPDATE ADDRESS RESPOSITORY
  Future<Map<String, dynamic>> updateAddressApi({
    required String userId,
    required String addressId,
    required String name,
    required String phone,
    required String address,
    required String nearestPlace,
    required String city,
    required String province,
    required String postalCode,
    bool setAsDefault = false,
  }) async {
    return await postRequest(
      Uri.parse(APiEndpoints.updateAddress),
      headers: apiHeaders,
      body: {
        'user_id': userId,
        'address_id': addressId,
        'name': name,
        'phone': phone,
        'address': address,
        'nearest_place': nearestPlace,
        'city': city,
        'province': province,
        'postal_code': postalCode,
        'set_as_default': setAsDefault,
      },
    );
  }




}