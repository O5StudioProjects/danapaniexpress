import 'dart:io';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:http/http.dart' as http;

class AccountRepository extends BaseRepository {


  /// UPLOAD IMAGE IN USER INFO -API
  Future<Map<String, dynamic>> uploadUserImageApi({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final uri = Uri.parse(APiEndpoints.updateUserImage);
      final request = http.MultipartRequest('POST', uri)
        ..fields['user_id'] = userId
        ..headers.addAll({
          AppConfig.apiKeyHeader: AppConfig.apiKey,
        })
        ..files.add(await http.MultipartFile.fromPath(
          'user_image',
          imageFile.path,
          contentType: AccountUtils.getMediaType(imageFile.path), // or image/png
        ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return handleApiResponse(response);
    } catch (e) {
      return handleException(e as Exception);
    }
  }


  /// UPDATE USER DATA AS REQUIRED - API

  Future<Map<String, dynamic>> updateUserApi({
    required String userId,
    String? fullName,
    String? email,
    String? currentPassword,
    String? newPassword,
  }) async {
    return await postRequest(
      Uri.parse(APiEndpoints.updateUserInfo),
      headers: apiHeaders,
      body: {
        'user_id': userId,
        if (fullName != null && fullName.isNotEmpty) 'user_full_name': fullName,
        if (email != null && email.isNotEmpty) 'user_email': email,
        if (currentPassword != null && currentPassword.isNotEmpty) 'current_password': currentPassword,
        if (newPassword != null && newPassword.isNotEmpty) 'new_password': newPassword,
      },
    );
  }




}