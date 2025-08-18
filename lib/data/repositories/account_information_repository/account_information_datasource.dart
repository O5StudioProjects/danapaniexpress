import 'dart:io';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:http/http.dart' as http;
import 'account_info_utils.dart';

class AccountInfoDatasource extends BaseRepository{

  /// UPLOAD IMAGE IN USER INFO -API
  // Future<Map<String, dynamic>> uploadUserImageApi({
  //   required String userId,
  //   required File imageFile,
  // }) async {
  //   try {
  //     final uri = Uri.parse(APiEndpoints.updateUserImage);
  //     final request = http.MultipartRequest('POST', uri)
  //       ..fields['user_id'] = userId
  //       ..headers.addAll({
  //         AppConfig.apiKeyHeader: AppConfig.apiKey,
  //       })
  //       ..files.add(await http.MultipartFile.fromPath(
  //         'user_image',
  //         imageFile.path,
  //         contentType: AccountUtils.getMediaType(imageFile.path), // or image/png
  //       ));
  //
  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //
  //     return handleApiResponseAsMap(response);
  //   } catch (e) {
  //     return handleException(e as Exception);
  //   }
  // }
  Future<Map<String, dynamic>> uploadUserImageApi({
    required String userId,
    File? imageFile,               // For mobile
    Uint8List? imageBytes,         // For web
    String? imageName,             // For web
  }) async {
    try {
      final uri = Uri.parse(APiEndpoints.updateUserImage);
      final request = http.MultipartRequest('POST', uri)
        ..fields['user_id'] = userId
        ..headers.addAll({
          AppConfig.apiKeyHeader: AppConfig.apiKey,
        });

      if (kIsWeb && imageBytes != null && imageName != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'user_image',
          imageBytes,
          filename: imageName,
          contentType: AccountUtils.getMediaType(imageName),
        ));
      } else if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'user_image',
          imageFile.path,
          contentType: AccountUtils.getMediaType(imageFile.path),
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return handleApiResponseAsMap(response);
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


  Future<Map<String, dynamic>> deleteUserImageApi({required String userId}) async {
    return await postRequest(
      Uri.parse(APiEndpoints.deleteUserImage),
      headers: apiHeaders,
      body: {
        'user_id': userId,
      },
    );
  }


}