import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';


class AuthController extends GetxController{
  final authRepo = AuthRepository();

  final RxBool isSignInFormValid = false.obs;

  /// AUTH TEXT CONTROLLERS - SIGNIN SCREEN
  var signInEmailPhoneTextController = TextEditingController().obs;
  var signInPasswordTextController = TextEditingController().obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null); // holds logged-in user
  final Rx<AuthStatus> authStatus = AuthStatus.IDLE.obs;

  @override
  void onInit() {
    super.onInit();

    signInEmailPhoneTextController.value.addListener(validateSignInForm);
    signInPasswordTextController.value.addListener(validateSignInForm);
  }

  void validateSignInForm() {
    final email = signInEmailPhoneTextController.value.text.trim();
    final pass = signInPasswordTextController.value.text.trim();
    isSignInFormValid.value = email.isNotEmpty && pass.isNotEmpty;
  }

  Future<bool> login() async {
    authStatus.value = AuthStatus.LOADING;

    try {
      final emailOrPhone = signInEmailPhoneTextController.value.text.trim();
      final password = signInPasswordTextController.value.text.trim();

      final user = await authRepo.authenticateUser(emailOrPhone, password);

      if (user != null) {
        currentUser.value = user;
        // Save login state
        await SharedPrefs.saveUser(user);
        await Future.delayed(Duration(seconds: 2));
        authStatus.value = AuthStatus.SUCCESS;
        return true;
      } else {
        authStatus.value = AuthStatus.FAILURE;
        return false;
      }
    } catch (e) {
      authStatus.value = AuthStatus.FAILURE;
      return false;
    }
  }

  @override
  void onClose() {
    signInEmailPhoneTextController.value.dispose();
    signInPasswordTextController.value.dispose();
    super.onClose();
  }

}