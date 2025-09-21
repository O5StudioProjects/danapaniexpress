import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class AuthDatasource extends BaseRepository{


  /// REGISTER USER -API
  Future<Map<String, dynamic>> registerUserApi({
    required String fullName,
    String? email,
    required String phone,
    required String password,
  }) async {
    return await postRequest(
      Uri.parse(APiEndpoints.registerUser),
      headers: apiHeaders,
      body: {
        UserFields.userFullName: fullName,
        UserFields.userEmail: email,
        UserFields.userPhone: phone,
        UserFields.userPassword: password,
      },
    );
  }

  /// FORGOT PASSWORD - API
  Future<Map<String, dynamic>> forgotPasswordApi({
    required String phone,
    required String newPassword,
  }) async {
    return await postRequest(
      Uri.parse(APiEndpoints.forgotPassword),
      headers: apiHeaders,
      body: {
        "user_phone": phone,
        "new_password": newPassword,
      },
    );
  }


  /// LOGIN USER -API
  Future<Map<String, dynamic>> loginUserApi({
    required String identifier,
    required String password,
  }) async {
    try {
      final data = await postRequest(
        Uri.parse(APiEndpoints.loginUser),
        headers: apiHeaders,
        body: {
          'user_identifier': identifier,
          'user_password': password,
        },
      );

      if (data['success'] == true && data.containsKey('user')) {
        return {
          SUCCESS: true,
          'token': data['token'],
          'user': UserModel.fromJson(Map<String, dynamic>.from(data['user'])),
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? data['error'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  /// Get user profile using token
  Future<Map<String, dynamic>> getProfileApi(String token) async {
    try {
      final data = await getRequest(
        Uri.parse(APiEndpoints.getUserProfile),
        headers: tokenHeaders(token),
      );

      if (data['success'] == true && data['user'] != null) {
        return {
          'success': true,
          'user': UserModel.fromJson(Map<String, dynamic>.from(data['user'])),
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? data['error'] ?? 'Failed to fetch profile',
        };
      }
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  /// LOGOUT UDER -API
  Future<Map<String, dynamic>> logoutUserApi(String token) async {
    return await postRequest(
      Uri.parse(APiEndpoints.logoutUser),
      headers: tokenHeaders(token),
      body: {}, // If your backend doesn't require a body for logout
    );
  }


}