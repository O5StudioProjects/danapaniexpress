import 'dart:io';

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class AccountInfoRepository extends AccountInfoDatasource{
  var auth = Get.find<AuthController>();
  /// UPLOAD IMAGE API CALL
  Future<Map<String, dynamic>> uploadUserImage(
      {
    required File file,
    userId,
    required Rx<AuthStatus> uploadImageStatus,
  }) async {

    uploadImageStatus.value = AuthStatus.LOADING;

    final result = await uploadUserImageApi(
      userId: userId,
      imageFile: file,
    );

    if (result['success'] == true || result['status'] == 'success') {
      return result;
    } else {
      uploadImageStatus.value = AuthStatus.FAILURE;
      return result;
    }
  }


  /// UPDATE USER /NAME/EMAIL/CHANGE PASSWORD
  Future<Map<String, dynamic>> updateUser({
    String? fullName,
    String? email,
    String? currentPassword,
    String? newPassword,
    required Rx<AuthStatus> updateProfileStatus
  }) async {
    updateProfileStatus.value = AuthStatus.LOADING;

    final result = await updateUserApi(
      userId: auth.userId.value!,
      fullName: fullName,
      email: email,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    if (result['success'] == true) {
      await auth.fetchUserProfile(); // Refresh local user data
      updateProfileStatus.value = AuthStatus.SUCCESS;
      return result;
    } else {
      updateProfileStatus.value = AuthStatus.FAILURE;
      return result;
    }
  }

  /// DELETE PROFILE IMAGE
  Future<Map<String, dynamic>> deleteUserImage({required String userId}) async {
    final result = await deleteUserImageApi(userId: userId);
    return result;
  }


}