import 'dart:convert';

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

import 'package:http/http.dart' as http;

import '../../models/address_model.dart';


class AuthRepository {

  /// REGISTER USER -API
  Future<Map<String, dynamic>> registerUserApi({
    required String fullName,
    String? email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(APiEndpoints.registerUser),
        headers: apiHeaders,
        body: jsonEncode({
          UserFields.userFullName: fullName,
          UserFields.userEmail: email, // Nullable
          UserFields.userPhone: phone,
          UserFields.userPassword: password,
        }),
      );

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        return data; // 🔁 Pass raw to controller to handle success/failure, store token/user, etc.
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Register Exception: $e');
      return {
        'success': false,
        'message': 'Exception: $e',
      };
    }
  }

  /// LOGIN USER -API
  Future<Map<String, dynamic>> loginUserApi({
    required String identifier,
    required String password,
  }) async {
    final url = Uri.parse(APiEndpoints.loginUser);
    try {
      final response = await http.post(
        url,
        headers: apiHeaders,
        body: jsonEncode({
          'user_identifier': identifier,
          'user_password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data[SUCCESS] == true) {
        return {
          SUCCESS: true,
          TOKEN: data['token'],
          'user': UserModel.fromJson(Map<String, dynamic>.from(data['user'])),
        };
      } else {
        return {SUCCESS: false, MESSAGE: data[MESSAGE] ?? 'Login failed'};
      }
    } catch (e) {
      return {SUCCESS: false, MESSAGE: 'Exception: $e'};
    }
  }

  /// Get user profile using token
  Future<Map<String, dynamic>> getProfile(String token) async {
    final url = Uri.parse(APiEndpoints.getUserProfile);
    try {
      final response = await http.get(
        url,
        headers: tokenHeaders(token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data[SUCCESS] == true) {
        return {
          SUCCESS: true,
          'user': UserModel.fromJson(Map<String, dynamic>.from(data['user'])),
        };
      } else {
        return {SUCCESS: false, MESSAGE: data[ERROR] ?? 'Failed to fetch'};
      }
    } catch (e) {
      return {SUCCESS: false, MESSAGE: 'Exception: $e'};
    }
  }

  /// LOGOUT UDER -API
  Future<Map<String, dynamic>> logoutUserApi(String token) async {
    try {
      final response = await http.post(
        Uri.parse(APiEndpoints.logoutUser),
        headers: {
          'Content-Type': 'application/json',
          AppConfig.apiKeyHeader: AppConfig.apiKey, // your static API key
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Logout failed: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Exception: $e',
      };
    }
  }




  /// METHODS FOR ASSETS
  Future<List<UserModel>> loadUsersFromAssets() async {
    final String jsonString = await rootBundle.loadString(jsonUsers);
    final List<dynamic> jsonList = jsonDecode(jsonString);

    return jsonList.map((e) => UserModel.fromJson(e)).toList();
  }

  String normalizePhone(String input) {
    final trimmed = input.trim();

    if (trimmed.startsWith('+92')) {
      return trimmed; // Already in correct format
    } else if (trimmed.startsWith('0') && trimmed.length == 11) {
      return '+92${trimmed.substring(1)}'; // Replace 0 with +92
    } else if (trimmed.length == 10) {
      return '+92$trimmed'; // Prepend +92
    }

    return trimmed; // Fallback (shouldn't happen if validator is used)
  }


  Future<UserModel?> authenticateUser(String emailOrPhone, String password) async {
    final users = await loadUsersFromAssets();

    final isNumeric = RegExp(r'^\d+$').hasMatch(emailOrPhone) || emailOrPhone.startsWith('0') || emailOrPhone.startsWith('+92');
    final input = isNumeric ? normalizePhone(emailOrPhone) : emailOrPhone.toLowerCase();

    return users.firstWhereOrNull((user) {
      final isMatchEmail = user.userEmail?.toLowerCase() == input;
      final isMatchPhone = user.userPhone?.trim() == input;
      final isPasswordMatch = user.userPassword == password;

      return (isMatchEmail || isMatchPhone) && isPasswordMatch;
    });
  }

}