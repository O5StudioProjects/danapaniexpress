

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:danapaniexpress/core/common_imports.dart';

class AddressRepository {
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
    try {
      final response = await http.post(
        Uri.parse(APiEndpoints.addUserAddress), // e.g., https://yourdomain.com/add_address
        headers: apiHeaders, // include Authorization if required
        body: jsonEncode({
          'user_id': userId,
          'user_full_name': name,
          'user_phone': phone,
          'default_address_address': address,
          'default_address_nearest_place': nearestPlace,
          'default_address_city': city,
          'default_address_province': province,
          'default_address_postal_code': postalCode,
          'set_as_default': setAsDefault,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'success': false, 'message': 'Server Error: ${response.statusCode}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Exception: $e'};
    }
  }


  /// DELETE ADDRESS REPOSITORY
  Future<Map<String, dynamic>> deleteAddressApi({
    required String userId,
    required String addressId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(APiEndpoints.deleteAddress), // Your endpoint URL
        headers: apiHeaders, // Must include API-KEY
        body: jsonEncode({
          'user_id': userId,
          'address_id': addressId,
        }),
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print("Delete Address Exception: $e");
      return {
        'success': false,
        'message': 'Exception: $e',
      };
    }
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
    try {
      final response = await http.post(
        Uri.parse(APiEndpoints.updateAddress),
        headers: apiHeaders,
        body: jsonEncode({
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
        }),
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Update Address Exception: $e');
      return {
        'success': false,
        'message': 'Exception: $e',
      };
    }
  }




}