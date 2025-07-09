import 'dart:convert';

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:http/http.dart' as http;

import '../../../core/packages_import.dart';


class AuthController extends GetxController{
  final AuthRepository authRepo;
  AuthController({required this.authRepo});
  final navigation = Get.find<NavigationController>();

  /// FORM VALIDATION
  final RxBool isSignInFormValid = false.obs;
  final RxBool isRegisterFormValid = false.obs;

  final Rx<AuthStatus> authStatus = AuthStatus.IDLE.obs;

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null); // holds logged-in user
  final RxString authToken = ''.obs;

  RxnString userId = RxnString();


  /// REGISTER USER
  final String baseUrl = 'http://10.0.2.2/danapani-api';

  // RxString authToken = ''.obs;
  RxBool isLoading = false.obs;


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
    registerReEnterPasswordTextController.value.addListener(validateRegisterForm);

  }

  ///REGISTER USER - API
  Future<void> registerUser({
    required String fullName,
    required String email, // optional, but still passed here
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    authStatus.value = AuthStatus.LOADING;

    if (fullName.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      authStatus.value = AuthStatus.FAILURE;
      Get.snackbar('Missing Fields', 'Please fill all required fields');
      return;
    }

    if (password != confirmPassword) {
      authStatus.value = AuthStatus.FAILURE;
      Get.snackbar('Password Mismatch', 'Passwords do not match');
      return;
    }

    final formattedPhone = PhoneUtils.normalizePhone(phone);
    if (formattedPhone == null) {
      authStatus.value = AuthStatus.FAILURE;
      Get.snackbar('Invalid Phone', 'Please enter a valid phone number');
      return;
    }

    final result = await authRepo.registerUserApi(
      fullName: fullName,
      email: email.isEmpty ? null : email,
      phone: formattedPhone,
      password: password,
    );

    if (result[SUCCESS] == true) {
      final token = result[TOKEN];
      final userMap = result['user'];

      // Save token + user ID
      saveSession(userMap['user_id'], token);

      // Update globals
      authToken.value = token;
      userId.value = userMap['user_id'];
      currentUser.value = UserModel.fromJson(userMap);

      authStatus.value = AuthStatus.SUCCESS;
      Get.snackbar('Success', 'Registered & Logged in!');
      await clearRegisterForm();

      navigation.gotoDashboardScreen();
    } else {
      authStatus.value = AuthStatus.FAILURE;
      Get.snackbar('Registration Failed', result[MESSAGE] ?? 'Unknown error');
    }
  }



  ///LOGIN USER - API

  Future<void> loginUser(String identifier, String password) async {
    authStatus.value = AuthStatus.LOADING;

      final normalizedInput = PhoneUtils.normalizeLoginInput(identifier);
      if (normalizedInput == null) {
        authStatus.value = AuthStatus.FAILURE;
        Get.snackbar('Invalid Input', 'Please enter a valid email or phone number');
        return;
      }

    final res = await authRepo.loginUserApi(identifier: normalizedInput, password: password);

    if (res[SUCCESS]) {
      currentUser.value = res['user'];
      authToken.value = res[TOKEN];
      userId.value = res['user']?.userId; // ✅ Set userId here
      await saveSession(res['user']?.userId, res[TOKEN]);
      await fetchUserProfile();
      authStatus.value = AuthStatus.SUCCESS;
      Get.snackbar("Login Successful", "Logged in successfully!");
      navigation.gotoDashboardScreen();
      clearSignInForm();
    } else {
      authStatus.value = AuthStatus.FAILURE;
      Get.snackbar("Login Failed", res['message'] ?? 'Error');
    }
  }

  ///FETCH USER PROFILE COMPLETE OBJECT - API
  Future<void> fetchUserProfile() async {
    if (authToken.isEmpty) return;

    final res = await authRepo.getProfile(authToken.value);
    if (res[SUCCESS]) {
      currentUser.value = res['user'];
      if (kDebugMode) {
        print("===== Profile Fetched");
      }
    } else {
      Get.snackbar("Profile", res[MESSAGE] ?? 'Error fetching profile');
    }
  }


  /// UI HANDLING OF ON TAP REGISTER USER
  Future<void> handleRegisterUserButtonTap() async {
    if(registerPasswordTextController.value.text == registerReEnterPasswordTextController.value.text){
     await registerUser(
        fullName: registerFullNameTextController.value.text.trim(),
        email: registerEmailTextController.value.text.trim().isEmpty ? '' : registerEmailTextController.value.text.trim(),
        phone: registerPhoneTextController.value.text.trim(),
        password: registerPasswordTextController.value.text,
        confirmPassword: registerReEnterPasswordTextController.value.text,
      );
    } else {
      Get.snackbar('Password Mismatched', 'Your password and confirm password is not same.');
    }

  }
  void handleLoginButtonTap() async {
    final rawInput = signInEmailPhoneTextController.value.text.trim();
    final password = signInPasswordTextController.value.text;

    if (rawInput.isEmpty || password.isEmpty) {
      Get.snackbar('Missing Fields', 'Please enter your email/phone and password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE57373),
        colorText: const Color(0xFFFFFFFF),
      );
      return;
    }

    // Detect email vs phone
    final formattedInput = PhoneUtils.normalizeLoginInput(rawInput);
    if (formattedInput == null) {
      Get.snackbar(
        'Invalid Input',
        'Please enter a valid email or phone number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE57373),
        colorText: const Color(0xFFFFFFFF),
      );
      return;
    }
    await loginUser(formattedInput, password);

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

  Future<void> logout() async {
    await SharedPrefs.logout();
    userId.value = null;
    authToken.value = '';
    navigation.gotoSignInScreen();
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
    isRegisterFormValid.value = fullName.isNotEmpty && phone.isNotEmpty && pass.isNotEmpty && reEnterPass.isNotEmpty;
  }


  @override
  void onClose() {
    signInEmailPhoneTextController.value.dispose();
    signInPasswordTextController.value.dispose();
    super.onClose();
  }

}