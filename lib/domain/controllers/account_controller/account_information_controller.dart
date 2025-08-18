import 'dart:io';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/packages_import.dart';
import 'package:danapaniexpress/data/repositories/account_repository/account_repository.dart';

class AccountInfoController extends GetxController {
  final accountRepo = AccountRepository();
  final accountInfoRepo = AccountInfoRepository();
  final auth = Get.find<AuthController>();

  final RxString profileImage = ''.obs;
  final RxBool isAccountNameValid = false.obs;
  final RxBool isAccountEmailValid = false.obs;
  final RxBool isAccountPasswordValid = false.obs;

  var accountNameTextController = TextEditingController().obs;
  var accountEmailTextController = TextEditingController().obs;
  var accountCurrentPasswordTextController = TextEditingController().obs;
  var accountNewPasswordTextController = TextEditingController().obs;
  var accountConfirmNewPasswordTextController = TextEditingController().obs;

  /// IMAGE UPLOADING
  final Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker picker = ImagePicker();
  final RxString uploadedImageUrl = ''.obs;

  Rx<Uint8List?> selectedImageBytes = Rx<Uint8List?>(null);
  RxString selectedImageName = ''.obs;

  Rx<AuthStatus> uploadImageStatus = AuthStatus.IDLE.obs;
  Rx<AuthStatus> deleteImageStatus = AuthStatus.IDLE.obs;
  Rx<AuthStatus> updateProfileStatus = AuthStatus.IDLE.obs;

  @override
  void onInit() {

    setInitialTextValues();

    super.onInit();
  }

  Future<void> setInitialTextValues() async {
    ///VALIDATE
    accountNameTextController.value.addListener(validateNameForm);
    accountEmailTextController.value.addListener(validateEmailForm);
    accountCurrentPasswordTextController.value.addListener(validatePasswordForm);
    accountNewPasswordTextController.value.addListener(validatePasswordForm);
    accountConfirmNewPasswordTextController.value.addListener(validatePasswordForm);

    /// ASSIGN INITIAL VALUES OF CURRENT USER
    accountNameTextController.value.text = auth.currentUser.value!.userFullName!;
    accountEmailTextController.value.text = auth.currentUser.value!.userEmail!;


  }



  /// IMAGE PICKER FROM GALLERY

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        // On web, store bytes instead of a File
        selectedImageBytes.value = await pickedFile.readAsBytes();
        selectedImageName.value = pickedFile.name; // Store original file name
      } else {
        // On mobile, use File
        selectedImage.value = File(pickedFile.path);
      }
    }
  }

  // /// UPLOAD IMAGE API CALL
  // Future<void> uploadUserImage() async {
  //   uploadImageStatus.value = AuthStatus.LOADING;
  //
  //   if (auth.userId.value == null) {
  //     uploadImageStatus.value = AuthStatus.FAILURE;
  //     showSnackbar(
  //         isError: true,
  //         title: AppLanguage.errorStr(appLanguage).toString(),
  //         message: AppLanguage.userNotLoggedInStr(appLanguage).toString()
  //     );
  //     return;
  //   }
  //
  //   if(selectedImage.value == null){
  //     uploadImageStatus.value = AuthStatus.FAILURE;
  //     showSnackbar(title: AppLanguage.imageNotSelectedStr(appLanguage).toString(), message: AppLanguage.imageNotSelectedDetailStr(appLanguage).toString());
  //     return;
  //   }
  //
  //   final result = await accountInfoRepo.uploadUserImage(
  //     file: selectedImage.value!,
  //     userId: auth.userId.value!,
  //   );
  //
  //   if (result['success'] == true || result['status'] == 'success') {
  //     await auth.fetchUserProfile(); // Refresh image in currentUser
  //     selectedImage.value = null;
  //     uploadImageStatus.value = AuthStatus.SUCCESS;
  //     showSnackbar(
  //         isError: false,
  //         title: 'Success',
  //         message: result['message'] ?? 'Image uploaded',
  //     );
  //
  //   } else {
  //     uploadImageStatus.value = AuthStatus.FAILURE;
  //     showSnackbar(
  //         isError: true,
  //         title: 'Failed',
  //         message: result['message'] ?? result['error'] ?? 'Upload failed',
  //     );
  //   }
  // }

  /// UPLOAD IMAGE (Web + Mobile)
  Future<void> uploadUserImage() async {
    uploadImageStatus.value = AuthStatus.LOADING;

    // 1️⃣ Check if user is logged in
    if (auth.currentUser.value == null) {
      uploadImageStatus.value = AuthStatus.FAILURE;
      showSnackbar(
        isError: true,
        title: AppLanguage.errorStr(appLanguage).toString(),
        message: AppLanguage.userNotLoggedInStr(appLanguage).toString(),
      );
      return;
    }

    // 2️⃣ Validate image selection
    if ((!kIsWeb && selectedImage.value == null) ||
        (kIsWeb && (selectedImageBytes.value == null || selectedImageName.value == ''))) {
      uploadImageStatus.value = AuthStatus.FAILURE;
      showSnackbar(
        title: AppLanguage.imageNotSelectedStr(appLanguage).toString(),
        message: AppLanguage.imageNotSelectedDetailStr(appLanguage).toString(),
      );
      return;
    }

    // 3️⃣ Call repository with platform-specific parameters
    final result = await accountInfoRepo.uploadUserImage(
      userId: auth.currentUser.value!.userId!,
      file: !kIsWeb ? selectedImage.value : null,
      imageBytes: kIsWeb ? selectedImageBytes.value : null,
      imageName: kIsWeb ? selectedImageName.value : null,
    );

    // 4️⃣ Handle API response
    if (result['success'] == true || result['status'] == 'success') {
      await auth.fetchUserProfile(); // Refresh profile image

      // Reset selection
      if (kIsWeb) {
        selectedImageBytes.value = null;
        selectedImageName.value = '';
      } else {
        selectedImage.value = null;
      }

      uploadImageStatus.value = AuthStatus.SUCCESS;
      showSnackbar(
        isError: false,
        title: AppLanguage.imageUploadedStr(appLanguage).toString(),
        message: AppLanguage.imageUploadedSuccessStr(appLanguage).toString(),
        // message: result['message'] ?? 'Image uploaded successfully!',
      );
    } else {
      uploadImageStatus.value = AuthStatus.FAILURE;
      showSnackbar(
        isError: true,
        title: '${AppLanguage.failedStr(appLanguage)}',
        message: result['message'] ?? result['error'] ?? '${AppLanguage.imageUploadFailedStr(appLanguage)}',
      );
      if (kDebugMode) {
        print('IMAGE UPLOAD: ${result['message'] ?? result['error'] ?? 'Upload failed'}');
      }
    }
  }


  /// UPDATE USER
  Future<void> updateUser({
    String? fullName,
    String? email,
    String? currentPassword,
    String? newPassword,
  }) async {
    updateProfileStatus.value = AuthStatus.LOADING;
    if (auth.userId.value == null) {
      showToast('${AppLanguage.userNotLoggedInStr(appLanguage)}');
      return;
    }

    final result = await accountInfoRepo.updateUser(
      fullName: fullName,
      email: email,
      currentPassword: currentPassword,
      newPassword: newPassword
    );

    if (result['success'] == true) {
      await auth.fetchUserProfile(); // Refresh local user data
      updateProfileStatus.value = AuthStatus.SUCCESS;
      Navigator.pop(gContext);
      showSnackbar(
          isError: false,
          title: '${AppLanguage.profileUpdatedStr(appLanguage)}',
        message: '${AppLanguage.profileUpdatedSuccessfullyStr(appLanguage)}',
        // message: result['message'] ?? 'Profile updated',
      );
    } else {
      updateProfileStatus.value = AuthStatus.FAILURE;
      showSnackbar(
          isError: true,
          title: '${AppLanguage.errorStr(appLanguage)}',
          message: result['message'] ?? result['error'] ?? '${AppLanguage.profileUpdatedFailedStr(appLanguage)}',
      );
      if (kDebugMode) {
        print('PROFILE UPDATED: ${result['message'] ?? result['error'] ?? 'Profile Updated Failed'}');
      }
    }
  }


  /// DELETE USER IMAGE
  Future<void> deleteUserImage() async {
    deleteImageStatus.value = AuthStatus.LOADING;
    if (auth.userId.value == null) {
      deleteImageStatus.value = AuthStatus.FAILURE;
      showSnackbar(
        isError: true,
        title: AppLanguage.errorStr(appLanguage).toString(),
        message: AppLanguage.userNotLoggedInStr(appLanguage).toString(),
      );
      return;
    }

    final result = await accountInfoRepo.deleteUserImage(userId: auth.userId.value!);

    if (result['success'] == true || result['status'] == 'success') {
      await auth.fetchUserProfile(); // Refresh updated image
      deleteImageStatus.value = AuthStatus.SUCCESS;
      showSnackbar(
        isError: false,
        title: '${AppLanguage.defaultImageStr(appLanguage)}',
        message: '${AppLanguage.defaultImageSelectedStr(appLanguage)}',
      );
    } else {
      deleteImageStatus.value = AuthStatus.FAILURE;
      showSnackbar(
        isError: true,
        title: '${AppLanguage.failedStr(appLanguage)}',
        message: result['message'] ?? result['error'] ?? '${AppLanguage.failedToSetDefaultImageStr(appLanguage)}',
      );
      if (kDebugMode) {
        print('DELETE IMAGE: ${result['message'] ?? result['error'] ?? 'Failed to set default image'}');
      }
    }
  }




  /// HANDLE ONTAP EVENTS

  /// HANDLE ON TAP NAME CHANGED
  Future<void> handleChangeNameOnTap() async {
    await updateUser(fullName: accountNameTextController.value.text.trim());
  }
  /// HANDLE ON TAP Email CHANGED
  Future<void> handleChangeEmailOnTap() async {
    await updateUser(email: accountEmailTextController.value.text.trim());
  }
  /// HANDLE ON TAP PASSWORD CHANGED
  Future<void> handleChangePasswordOnTap() async {
    if(accountNewPasswordTextController.value.text.trim() != accountConfirmNewPasswordTextController.value.text.trim()){
      showSnackbar(
        isError: true,
          title: AppLanguage.passwordMismatchStr(appLanguage).toString(),
          message: AppLanguage.passwordMismatchDetailStr(appLanguage).toString());
    } else {
      await updateUser(
          currentPassword: accountCurrentPasswordTextController.value.text.trim(),
          newPassword: accountNewPasswordTextController.value.text.trim()
      );
    }

  }

  void validateNameForm() {
    final fullName = accountNameTextController.value.text.trim();
    isAccountNameValid.value = fullName.isNotEmpty;
  }

  void validateEmailForm() {
    final email = accountEmailTextController.value.text.trim();
    isAccountEmailValid.value = email.isNotEmpty;
  }

  void validatePasswordForm() {
    final oldPassword = accountCurrentPasswordTextController.value.text.trim();
    final newPassword = accountNewPasswordTextController.value.text.trim();
    final confirmNewPassword = accountConfirmNewPasswordTextController.value.text.trim();
    isAccountPasswordValid.value = oldPassword.isNotEmpty && newPassword.isNotEmpty  && confirmNewPassword.isNotEmpty ;
  }

}