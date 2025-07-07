import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';


class SignInMobile extends StatelessWidget {
  SignInMobile({super.key});

  final _formKey = GlobalKey<FormState>(); // 🔑 Form key

  @override
  Widget build(BuildContext context) {
    var navigation = Get.find<NavigationController>();
    // var textController = Get.find<TextControllers>();
    var auth = Get.find<AuthController>();

    return Container(
      color: AppColors.backgroundColorSkin(isDark),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: size.height),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Top Image Section
                SizedBox(
                  width: size.width,
                  height: size.height * 0.38,
                  child: Stack(
                    children: [
                      appAssetImage(
                        image: EnvImages.imgLoginScreen,
                        width: size.width,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: -2,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: appSvgIcon(
                            icon: EnvImages.imgWave,
                            width: size.width,
                            color: AppColors.backgroundColorSkin(isDark),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Form Area
                Obx(
                  ()=> Padding(
                    padding: const EdgeInsets.symmetric(horizontal: MAIN_VERTICAL_PADDING),
                    child: Form(
                      key: _formKey, // ✅ attach form key
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          setHeight(10.0),
                          appText(
                            text: AppLanguage.welcomeBackStr(appLanguage),
                            textDirection: setTextDirection(appLanguage),
                            textStyle: bigBoldHeadingTextStyle(),
                          ),
                          setHeight(10.0),
                          appText(
                            text: AppLanguage.loginToAccountStr(appLanguage),
                            textDirection: setTextDirection(appLanguage),
                            textStyle: secondaryTextStyle(),
                          ),
                          setHeight(20.0),

                          /// Email or Phone
                          AppTextFormField(
                            textEditingController: auth.signInEmailPhoneTextController.value,
                            prefixIcon: Icons.person,
                            hintText: AppLanguage.emailPhoneStr(appLanguage),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Please enter email or phone number";
                                }

                                final trimmed = value.trim();
                                final isNumeric = RegExp(r'^\d+$').hasMatch(trimmed);
                                final isPhoneWithCode = trimmed.startsWith('+92') && trimmed.length == 13;
                                final isPhoneWithLeadingZero = trimmed.length == 11 && trimmed.startsWith('0');
                                final isPhoneWithoutCodeOrZero = trimmed.length == 10 && isNumeric;

                                if (isNumeric || isPhoneWithCode) {
                                  if (isPhoneWithCode || isPhoneWithLeadingZero || isPhoneWithoutCodeOrZero) {
                                    return null;
                                  }
                                  return "Invalid phone number format";
                                }

                                final isEmail = RegExp(
                                  r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                                ).hasMatch(trimmed);

                                if (!isEmail) {
                                  return "Invalid email format";
                                }

                                return null;
                              }

                          ),

                          setHeight(20.0),

                          /// Password
                          AppTextFormField(
                            textEditingController: auth.signInPasswordTextController.value,
                            prefixIcon: Icons.lock_outline,
                            hintText: AppLanguage.passwordStr(appLanguage),
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter your password";
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),

                          setHeight(10.0),
                          Align(
                            alignment: appLanguage == ENGLISH_LANGUAGE
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => navigation.gotoForgotPasswordScreen(),
                              child: appText(
                                text: AppLanguage.forgotPasswordStr(appLanguage),
                                textDirection: setTextDirection(appLanguage),
                                textStyle: appTextButtonStyle(
                                  color: AppColors.materialButtonSkin(isDark),
                                ),
                              ),
                            ),
                          ),
                          setHeight(20.0),

                          /// Login Button
                          Obx((){
                            if (auth.authStatus.value == AuthStatus.LOADING) {
                              return loadingIndicator(); // or custom loading widget
                            }
                            return appMaterialButton(
                              isDisable: !auth.isSignInFormValid.value,
                              text: AppLanguage.loginStr(appLanguage),
                              onTap: () async {
                                if(auth.isSignInFormValid.value){
                                  if (_formKey.currentState?.validate() ?? false) {
                                    // Proceed with login
                                    final success = await auth.login();
                                    if (success) {
                                      showToast('Login Success');
                                     // ToastUtil.showToast(context, "Login Success");

                                      navigation.gotoDashboardScreen();
                                    } else {
                                     // ToastUtil.showToast(context, "Invalid credentials");
                                      showToast('Invalid credentials');
                                     // showSnackbar(title: 'Invalid Credentials', message: 'Your credentials are not correct');
                                    }
                                  }
                                }

                              },
                            );
                          }),

                          setHeight(60.0),
                          appDetailTextButton(
                            detailText: AppLanguage.dontHaveAccountStr(appLanguage),
                            buttonText: AppLanguage.signUpStr(appLanguage),
                            onTapButton: () => navigation.gotoRegisterScreen(),
                          ),
                          setHeight(10.0),
                          GestureDetector(
                            onTap: () => navigation.gotoDashboardScreen(),
                            child: appText(
                              text: AppLanguage.continueAsGuestStr(appLanguage),
                              textStyle: appTextButtonStyle(
                                color: AppColors.materialButtonSkin(isDark),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

