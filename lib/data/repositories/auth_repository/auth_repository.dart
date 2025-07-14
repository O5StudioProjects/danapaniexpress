import 'dart:convert';

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/data/repositories/auth_repository/auth_datasource.dart';

import 'package:http/http.dart' as http;


class AuthRepository extends AuthDatasource{

  ///REGISTER USER - API
  Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String email, // optional, but still passed here
    required String phone,
    required String password,
    required String confirmPassword,
    required Rx<AuthStatus> authStatus,
  }) async {
    authStatus.value = AuthStatus.LOADING;

    final result = await registerUserApi(
      fullName: fullName,
      email: email.isEmpty ? null : email,
      phone: phone,
      password: password,
    );

    if (result['success'] == true) {
      authStatus.value = AuthStatus.SUCCESS;
      return result;
    } else {
      authStatus.value = AuthStatus.FAILURE;
      return result;

    }
  }

  ///LOGIN USER - API
  Future<Map<String, dynamic>> loginUser({
        required String identifier,
    required String password,
    required Rx<AuthStatus> status,

  }) async {
    status.value = AuthStatus.LOADING;

    final res = await loginUserApi(identifier: identifier, password: password);
    print("Login response: $res");

    if (res['SUCCESS'] == true) {
      status.value = AuthStatus.SUCCESS;
      return res;
    } else {
      status.value = AuthStatus.FAILURE;
      return res;
    }
  }

  ///LOGOUT USER - API
  Future<Map<String, dynamic>> logoutUser({
    required Rx<AuthStatus> status,
    required RxString authToken,
}) async {
    status.value = AuthStatus.LOADING;

    final result = await logoutUserApi(authToken.value ?? '');

    if (result['success'] == true) {
      // Clear local storage/session
      await SharedPrefs.clearUserSessions();

      status.value = AuthStatus.SUCCESS;
      return result;

    } else {
      status.value = AuthStatus.FAILURE;
      return result;


    }
  }

  ///FETCH USER PROFILE COMPLETE OBJECT - API
  Future<Map<String, dynamic>> fetchUserProfile({
    required RxString authToken,
    required Rx<AuthStatus> getProfileStatus,

  }) async {

    getProfileStatus.value = AuthStatus.LOADING;

    final res = await getProfileApi(authToken.value);

    if (res['success'] == true) {
      getProfileStatus.value = AuthStatus.SUCCESS;

      if (kDebugMode) {
        print("===== Profile Fetched =====");
      }
      return res;

    } else {
      getProfileStatus.value = AuthStatus.FAILURE;
      return res;
    }
  }


  ///==========================================================













  //
  // /// METHODS FOR ASSETS
  // Future<List<UserModel>> loadUsersFromAssets() async {
  //   final String jsonString = await rootBundle.loadString(jsonUsers);
  //   final List<dynamic> jsonList = jsonDecode(jsonString);
  //
  //   return jsonList.map((e) => UserModel.fromJson(e)).toList();
  // }
  //
  // String normalizePhone(String input) {
  //   final trimmed = input.trim();
  //
  //   if (trimmed.startsWith('+92')) {
  //     return trimmed; // Already in correct format
  //   } else if (trimmed.startsWith('0') && trimmed.length == 11) {
  //     return '+92${trimmed.substring(1)}'; // Replace 0 with +92
  //   } else if (trimmed.length == 10) {
  //     return '+92$trimmed'; // Prepend +92
  //   }
  //
  //   return trimmed; // Fallback (shouldn't happen if validator is used)
  // }
  //
  // Future<UserModel?> authenticateUser(String emailOrPhone, String password) async {
  //   final users = await loadUsersFromAssets();
  //
  //   final isNumeric = RegExp(r'^\d+$').hasMatch(emailOrPhone) || emailOrPhone.startsWith('0') || emailOrPhone.startsWith('+92');
  //   final input = isNumeric ? normalizePhone(emailOrPhone) : emailOrPhone.toLowerCase();
  //
  //   return users.firstWhereOrNull((user) {
  //     final isMatchEmail = user.userEmail?.toLowerCase() == input;
  //     final isMatchPhone = user.userPhone?.trim() == input;
  //     final isPasswordMatch = user.userPassword == password;
  //
  //     return (isMatchEmail || isMatchPhone) && isPasswordMatch;
  //   });
  // }

}