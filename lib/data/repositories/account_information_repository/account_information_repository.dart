import 'dart:io';

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class AccountInfoRepository extends AccountInfoDatasource{
  var auth = Get.find<AuthController>();
  // /// UPLOAD IMAGE API CALL
  // Future<Map<String, dynamic>> uploadUserImage(
  //     {
  //   required File file,
  //   userId,
  // }) async {
  //
  //   final result = await uploadUserImageApi(
  //     userId: userId,
  //     imageFile: file,
  //   );
  //
  //   return result;
  //
  // }

  /// Upload profile image (supports Mobile & Web)
  Future<Map<String, dynamic>> uploadUserImage({
    required String userId,
    File? file,                // For mobile
    Uint8List? imageBytes,     // For web
    String? imageName,         // For web
  }) async {
    final result = await uploadUserImageApi(
      userId: userId,
      imageFile: file,
      imageBytes: imageBytes,
      imageName: imageName,
    );

    return result;
  }

  /// UPDATE USER /NAME/EMAIL/CHANGE PASSWORD
  Future<Map<String, dynamic>> updateUser({
    String? fullName,
    String? email,
    String? currentPassword,
    String? newPassword,
  }) async {

    final result = await updateUserApi(
      userId: auth.userId.value!,
      fullName: fullName,
      email: email,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    return result;

  }

  /// DELETE PROFILE IMAGE
  Future<Map<String, dynamic>> deleteUserImage({required String userId}) async {
    final result = await deleteUserImageApi(userId: userId);
    return result;
  }


}