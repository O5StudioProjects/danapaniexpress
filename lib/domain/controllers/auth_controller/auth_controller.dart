import 'dart:convert';

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/domain/controllers/orders_controller/orders_controller.dart';
import 'package:http/http.dart' as http;

import '../../../core/packages_import.dart';
import '../../../data/models/address_model.dart';

class AuthController extends GetxController {
  final AuthRepository authRepo;

  AuthController({required this.authRepo});

  final navigation = Get.find<NavigationController>();

  /// FORM VALIDATION
  final RxBool isSignInFormValid = false.obs;
  final RxBool isRegisterFormValid = false.obs;

  final Rx<AuthStatus> authStatus = AuthStatus.IDLE.obs;
  final Rx<AuthStatus> getProfileStatus = AuthStatus.IDLE.obs;

  final Rx<UserModel?> currentUser = Rx<UserModel?>(
    null,
  ); // holds logged-in user
  final RxString authToken = ''.obs;

  RxnString userId = RxnString();

  /// AUTH TEXT CONTROLLERS - SIGNIN SCREEN
  var signInEmailPhoneTextController = TextEditingController().obs;
  var signInPasswordTextController = TextEditingController().obs;

  /// AUTH TEXT CONTROLLERS - REGISTER SCREEN
  var registerFullNameTextController = TextEditingController().obs;
  var registerEmailTextController = TextEditingController().obs;
  var registerPhoneTextController = TextEditingController().obs;
  var registerPasswordTextController = TextEditingController().obs;
  var registerReEnterPasswordTextController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();

    ///LOGIN
    signInEmailPhoneTextController.value.addListener(validateSignInForm);
    signInPasswordTextController.value.addListener(validateSignInForm);

    ///REGISTER
    registerFullNameTextController.value.addListener(validateRegisterForm);
    registerEmailTextController.value.addListener(validateRegisterForm);
    registerPhoneTextController.value.addListener(validateRegisterForm);
    registerPasswordTextController.value.addListener(validateRegisterForm);
    registerReEnterPasswordTextController.value.addListener(
      validateRegisterForm,
    );
  }


  /// REGISTER NEW USER
  Future<void> registerUser() async {
    authStatus.value = AuthStatus.LOADING;
    var fullName = registerFullNameTextController.value.text.trim();
    var phone = registerPhoneTextController.value.text.trim();
    var email = registerEmailTextController.value.text.trim();
    var password = registerPasswordTextController.value.text.trim();
    var confirmPassword = registerReEnterPasswordTextController.value.text.trim();
    if (fullName.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      authStatus.value = AuthStatus.FAILURE;
      showSnackbar(
        title: AppLanguage.missingFieldsStr(appLanguage).toString(),
        message: AppLanguage.missingFieldsDetailStr(appLanguage).toString(),
      );
      return;
    }

    if (password != confirmPassword) {
      authStatus.value = AuthStatus.FAILURE;
      showSnackbar(
        isError: true,
        title: AppLanguage.passwordMismatchStr(appLanguage).toString(),
        message: AppLanguage.passwordMismatchDetailStr(appLanguage).toString(),
      );
      return;
    }

    final formattedPhone = PhoneUtils.normalizePhone(phone);
    if (formattedPhone == null) {
      authStatus.value = AuthStatus.FAILURE;
      showSnackbar(
        isError: true,
        title: AppLanguage.invalidPhoneStr(appLanguage).toString(),
        message: AppLanguage.invalidPhoneDetailStr(appLanguage).toString(),
      );
      return;
    }

    var result = await authRepo.registerUser(fullName: fullName, email: email, phone: phone, password: password, confirmPassword: confirmPassword);

    if(result['success'] == true){
      final token = result['token'];
      final userMap = result['user'];

      print('Token : $token');
      print('userMap : $userMap');
      // Save token + user ID
      saveSession(userMap['user_id'], token);

      // Update globals
      authToken.value = token;
      userId.value = userMap['user_id'];
      currentUser.value = UserModel.fromJson(userMap);
      await clearRegisterForm();
      authStatus.value = AuthStatus.SUCCESS;
      showSnackbar(
        isError: false,
        title: AppLanguage.registrationSuccessStr(appLanguage).toString(),
        message: AppLanguage.registrationSuccessDetailStr(
          appLanguage,
        ).toString(),
      );
      navigation.gotoDashboardScreen();

    } else {
      authStatus.value = AuthStatus.FAILURE;
      showSnackbar(
        isError: true,
        title: 'Registration Failed',
        message: result['message'] ?? result['error'] ?? 'Unknown error',
      );

      if (kDebugMode) {
        print('${result['message'] ?? result['error']}');
      }

    }

  }

  /// LOGIN USER
  Future<void> loginUser() async{
    authStatus.value = AuthStatus.LOADING;

    final rawInput = signInEmailPhoneTextController.value.text.trim();
    final password = signInPasswordTextController.value.text.trim();
    if (rawInput.isEmpty || password.isEmpty) {
      authStatus.value = AuthStatus.FAILURE;
      showSnackbar(
          title: AppLanguage.missingFieldsStr(appLanguage).toString(),
          message: AppLanguage.missingFieldsDetailStr(appLanguage).toString());
      return;
    }

    final normalizedInput = PhoneUtils.normalizeLoginInput(rawInput);
    if (normalizedInput == null) {
      authStatus.value = AuthStatus.FAILURE;
      showSnackbar(
          isError: true,
          title: AppLanguage.invalidInputStr(appLanguage).toString(),
          message: AppLanguage.invalidInputDetailStr(appLanguage).toString()
      );
      return;
    }

    var res  = await authRepo.loginUser(identifier: normalizedInput, password: password);

    if(res['SUCCESS'] == true){
      currentUser.value = res['user'];
      authToken.value = res['token'];
      userId.value = res['user']?.userId; // ✅ Set userId here
      await fetchUserProfile();
      await saveSession(res['user']?.userId, res['token']);

      authStatus.value = AuthStatus.SUCCESS;
      showSnackbar(
          isError: false,
          title: AppLanguage.loginSuccessStr(appLanguage).toString(),
          message: AppLanguage.loginSuccessDetailStr(appLanguage).toString()
      );
      clearSignInForm();
      navigation.gotoDashboardScreen();
    } else {
      authStatus.value = AuthStatus.FAILURE;
      showSnackbar(
          isError: true,
          title: 'Login Failed',
          message: res['message'] ?? res['error'] ?? res['MESSAGE'] ?? 'Unknown error');
      if (kDebugMode) {
        print('${res['message'] ?? res['error'] ?? res['MESSAGE']}');
      }
    }
  }

  /// LOGOUT USER
  Future<void> logoutUser() async {
    authStatus.value = AuthStatus.LOADING;
    var result = await authRepo.logoutUser(authToken: authToken);
    if(result['success'] == true){
      await SharedPrefs.clearUserSessions();
      currentUser.value = null;
      authToken.value = '';
      userId.value = null;
      authStatus.value = AuthStatus.SUCCESS;
      navigation.gotoSignInScreen();
    } else {
      authStatus.value = AuthStatus.FAILURE;
      showSnackbar(
        isError: true,
        title: "Logout",
        message: result['message'] ?? result['error'] ?? 'Unknown error',
      );
      if (kDebugMode) {
        print('${result['message'] ?? result['error']}');
      }
    }
  }

  ///FETCH USER PROFILE COMPLETE OBJECT - API
  Future<void> fetchUserProfile() async {
    getProfileStatus.value = AuthStatus.LOADING;

    if (authToken.isEmpty) return;

    var res = await authRepo.fetchUserProfile(authToken: authToken);

    if (res['success'] == true) {
      currentUser.value = res['user'];
      getProfileStatus.value = AuthStatus.SUCCESS;

      if (kDebugMode) {
        print("===== Profile Fetched =====");
        print("User Address:::::: ${currentUser.value!.userDefaultAddress?.address}");
        print("User Name:::::: ${currentUser.value!.userFullName}");
        print("User EMAIL:::::: ${currentUser.value!.userEmail}");
        print("User phone:::::: ${currentUser.value!.userPhone}");
      }
    } else {
      getProfileStatus.value = AuthStatus.FAILURE;
      // showSnackbar(
      //   isError: true,
      //   title: "Profile",
      //   message: res['message'] ?? res['error'] ?? 'Error fetching profile',
      // );

      print('PROFILE FETCH: ${res['message'] ?? res['error']}');

    }
  }


  /// CLEAR FORMS
  Future<void> clearRegisterForm() async {
    registerFullNameTextController.value.clear();
    registerEmailTextController.value.clear();
    registerPhoneTextController.value.clear();
    registerPasswordTextController.value.clear();
    registerReEnterPasswordTextController.value.clear();
  }

  Future<void> clearSignInForm() async {
    signInEmailPhoneTextController.value.clear();
    signInPasswordTextController.value.clear();
  }

  /// SHARED PREFERENCES USER SESSIONS
  Future<void> saveSession(String id, String authToken) async {
    await SharedPrefs.saveUser(id, authToken);
  }

  /// USED IN SPLASH TO LOAD USER SESSION
  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AUTH_TOKEN);
    final storedUserId = prefs.getString(USER_ID);

    if (token != null && storedUserId != null) {
      authToken.value = token;
      userId.value = storedUserId;
      await fetchUserProfile(); // Optional
      navigation.gotoDashboardScreen(); // ✅ Go to dashboard
    } else {
      navigation.gotoSignInScreen(); // 🚪 No session, go to login
    }
  }

  /// FORM VALIDATIONS
  void validateSignInForm() {
    final email = signInEmailPhoneTextController.value.text.trim();
    final pass = signInPasswordTextController.value.text.trim();
    isSignInFormValid.value = email.isNotEmpty && pass.isNotEmpty;
  }

  void validateRegisterForm() {
    final fullName = registerFullNameTextController.value.text.trim();
    final phone = registerPhoneTextController.value.text.trim();
    final pass = registerPasswordTextController.value.text.trim();
    final reEnterPass = registerReEnterPasswordTextController.value.text.trim();
    isRegisterFormValid.value =
        fullName.isNotEmpty &&
        phone.isNotEmpty &&
        pass.isNotEmpty &&
        reEnterPass.isNotEmpty;
  }

  @override
  void onClose() {
    signInEmailPhoneTextController.value.dispose();
    signInPasswordTextController.value.dispose();

    registerFullNameTextController.value.dispose();
    registerEmailTextController.value.dispose();
    registerPhoneTextController.value.dispose();
    registerPasswordTextController.value.dispose();
    registerReEnterPasswordTextController.value.dispose();

    super.onClose();
  }
}
