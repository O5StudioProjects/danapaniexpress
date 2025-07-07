import 'dart:convert';

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';


class AuthRepository {

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

  Future<List<UserModel>> loadUsersFromAssets() async {
    final String jsonString = await rootBundle.loadString(jsonUsers);
    final List<dynamic> jsonList = jsonDecode(jsonString);

    return jsonList.map((e) => UserModel.fromJson(e)).toList();
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