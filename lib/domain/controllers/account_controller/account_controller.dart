import 'dart:io';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/packages_import.dart';

class AccountController extends GetxController {

  final auth = Get.find<AuthController>();

  final RxString profileImage = ''.obs;
  final RxBool isAccountNameValid = false.obs;
  final RxBool isAccountEmailValid = false.obs;
  final RxBool isAccountPasswordValid = false.obs;

  var accountNameTextController = TextEditingController().obs;
  var accountEmailTextController = TextEditingController().obs;
  var accountOldPasswordTextController = TextEditingController().obs;
  var accountNewPasswordTextController = TextEditingController().obs;
  var accountConfirmNewPasswordTextController = TextEditingController().obs;

  /// IMAGE UPLOADING
  final Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker picker = ImagePicker();
  final RxBool isUploading = false.obs;
  final RxString uploadedImageUrl = ''.obs;

  @override
  void onInit() {

    setInitialTextValues();

    super.onInit();
  }

  /// IMAGE PICKER FROM GALLERY
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> setInitialTextValues() async {
    /// ASSIGN INITIAL VALUES OF CURRENT USER
    accountNameTextController.value.text = auth.currentUser.value!.userFullName!;
    accountEmailTextController.value.text = auth.currentUser.value!.userEmail!;

    ///VALIDATE
    accountNameTextController.value.addListener(validateNameForm);
    accountEmailTextController.value.addListener(validateEmailForm);
    accountOldPasswordTextController.value.addListener(validatePasswordForm);
    accountNewPasswordTextController.value.addListener(validatePasswordForm);
    accountConfirmNewPasswordTextController.value.addListener(validatePasswordForm);
  }

  /// HANDLE ONTAP EVENTS
  ///
  /// HANDLE ON TAP UPLOAD IMAGE
  Future<void> handleUploadProfilePictureOnTap() async {
    if(selectedImage.value != null){
      showToast('Image Will upload');
    } else {
      showSnackbar(title: 'Image not Selected', message: 'Select Image from phone gallery');
    }
  }

  /// HANDLE ON TAP NAME CHANGED
  Future<void> handleChangeNameOnTap() async {

  }
  /// HANDLE ON TAP Email CHANGED
  Future<void> handleChangeEmailOnTap() async {

  }
  /// HANDLE ON TAP PASSWORD CHANGED
  Future<void> handleChangePasswordOnTap() async {
    if(auth.currentUser.value!.userPassword! != accountOldPasswordTextController.value.text){
      Get.snackbar('Old Password', 'Old password is incorrect');
    } else if(accountNewPasswordTextController.value.text.trim() != accountConfirmNewPasswordTextController.value.text.trim()){
      Get.snackbar('Mismatched', 'New Password and Confirm password are not same.');
    } else {
      print('Password Changed');
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
    final oldPassword = accountOldPasswordTextController.value.text.trim();
    final newPassword = accountNewPasswordTextController.value.text.trim();
    final confirmNewPassword = accountConfirmNewPasswordTextController.value.text.trim();
    isAccountPasswordValid.value = oldPassword.isNotEmpty && newPassword.isNotEmpty  && confirmNewPassword.isNotEmpty ;
  }

}