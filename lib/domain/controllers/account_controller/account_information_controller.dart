import 'dart:io';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/packages_import.dart';
import 'package:danapaniexpress/data/repositories/account_repository/account_repository.dart';

class AccountInfoController extends GetxController {
  final accountRepo = AccountRepository();
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
  final RxBool isUploading = false.obs;
  final RxString uploadedImageUrl = ''.obs;

  Rx<AuthStatus> uploadImageStatus = AuthStatus.IDLE.obs;
  Rx<AuthStatus> updateProfileStatus = AuthStatus.IDLE.obs;

  @override
  void onInit() {

    setInitialTextValues();

    super.onInit();
  }

  Future<void> setInitialTextValues() async {
    /// ASSIGN INITIAL VALUES OF CURRENT USER
    accountNameTextController.value.text = auth.currentUser.value!.userFullName!;
    accountEmailTextController.value.text = auth.currentUser.value!.userEmail!;

    ///VALIDATE
    accountNameTextController.value.addListener(validateNameForm);
    accountEmailTextController.value.addListener(validateEmailForm);
    accountCurrentPasswordTextController.value.addListener(validatePasswordForm);
    accountNewPasswordTextController.value.addListener(validatePasswordForm);
    accountConfirmNewPasswordTextController.value.addListener(validatePasswordForm);
  }



  /// IMAGE PICKER FROM GALLERY
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  /// UPLOAD IMAGE API CALL
  Future<void> uploadUserImage(File file) async {
    if (auth.userId.value == null) {
      showSnackbar(
          isError: true,
          title: AppLanguage.errorStr(appLanguage).toString(),
          message: AppLanguage.userNotLoggedInStr(appLanguage).toString()
      );
      return;
    }

    uploadImageStatus.value = AuthStatus.LOADING;

    final result = await accountRepo.uploadUserImageApi(
      userId: auth.userId.value!,
      imageFile: file,
    );

    if (result['success'] == true || result['status'] == 'success') {
      showSnackbar(
          isError: false,
          title: 'Success',
          message: result['message'] ?? 'Image uploaded',
      );
      await auth.fetchUserProfile(); // Refresh image in currentUser
      selectedImage.value = null;
      uploadImageStatus.value = AuthStatus.SUCCESS;
    } else {
      showSnackbar(
          isError: true,
          title: 'Failed',
          message: result['message'] ?? result['error'] ?? 'Upload failed',

      );
      uploadImageStatus.value = AuthStatus.FAILURE;
    }
  }

  Future<void> updateUser({
    String? fullName,
    String? email,
    String? currentPassword,
    String? newPassword,
  }) async {
    if (auth.userId.value == null) {
      Get.snackbar('Error', 'User not logged in');
      return;
    }

    updateProfileStatus.value = AuthStatus.LOADING;

    final result = await accountRepo.updateUserApi(
      userId: auth.userId.value!,
      fullName: fullName,
      email: email,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    if (result['success'] == true) {
      await auth.fetchUserProfile(); // Refresh local user data
      updateProfileStatus.value = AuthStatus.SUCCESS;
      Navigator.pop(gContext);
      showSnackbar(
          isError: false,
          title: 'Success',
          message: result['message'] ?? 'Profile updated',
         position: SnackPosition.TOP
      );
    } else {
      showSnackbar(
          isError: true,
          title: 'Failed',
          message: result['message'] ?? result['error'] ?? 'Update failed',
          position: SnackPosition.TOP

      );
      updateProfileStatus.value = AuthStatus.FAILURE;
    }
  }



  /// HANDLE ONTAP EVENTS
  ///
  /// HANDLE ON TAP UPLOAD IMAGE
  Future<void> handleUploadProfilePictureOnTap() async {
    if(selectedImage.value != null){
      await uploadUserImage(selectedImage.value!);
    } else {
      showSnackbar(title: 'Image not Selected', message: 'Select Image from phone gallery');
    }
  }

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