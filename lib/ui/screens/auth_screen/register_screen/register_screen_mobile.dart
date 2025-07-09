import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class RegisterScreenMobile extends StatelessWidget {
   RegisterScreenMobile({super.key});
  final _formKey = GlobalKey<FormState>(); // 🔑 Form key

  @override
  Widget build(BuildContext context) {
    var navigation = Get.find<NavigationController>();
    var auth = Get.find<AuthController>();
    return Obx((){
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height),
            child: Padding(
              padding: const EdgeInsets.all(MAIN_VERTICAL_PADDING),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    setHeight(60.0),
                    appText(
                      text: AppLanguage.registerStr(appLanguage),
                      textDirection: setTextDirection(appLanguage),
                      textStyle: bigBoldHeadingTextStyle(),
                    ),
                    setHeight(10.0),
                    appText(
                      text: AppLanguage.createNewAccountStr(appLanguage),
                      textDirection: setTextDirection(appLanguage),
                      textStyle: secondaryTextStyle(),
                    ),
                    setHeight(20.0),

                    AppTextFormField(
                      textEditingController: auth.registerFullNameTextController.value,
                      prefixIcon: Icons.person,
                      hintText: AppLanguage.fullNameStr(appLanguage),
                      validator: FormValidations.fullNameValidator,
                    ),
                    setHeight(20.0),

                    AppTextFormField(
                      textEditingController: auth.registerEmailTextController.value,
                      prefixIcon: Icons.email,
                      hintText: AppLanguage.emailStr(appLanguage),
                      validator: FormValidations.optionalEmailValidator,
                    ),
                    setHeight(20.0),

                    AppTextFormField(
                      textEditingController: auth.registerPhoneTextController.value,
                      prefixIcon: Icons.phone,
                      hintText: AppLanguage.phoneStr(appLanguage),
                      validator: FormValidations.phoneValidator,
                    ),

                    setHeight(20.0),
                    AppTextFormField(
                      textEditingController: auth.registerPasswordTextController.value,
                      prefixIcon: Icons.lock_outline,
                      hintText: AppLanguage.passwordStr(appLanguage),
                      isPassword: true,
                      validator: FormValidations.passwordValidator,
                    ),

                    setHeight(20.0),
                    AppTextFormField(
                      textEditingController: auth.registerReEnterPasswordTextController.value,
                      prefixIcon: Icons.lock_outline,
                      hintText: AppLanguage.reEnterPasswordStr(appLanguage),
                      isPassword: true,
                      validator: FormValidations.passwordValidator,
                    ),

                    setHeight(40.0),

                    auth.authStatus == AuthStatus.LOADING
                    ? loadingIndicator()
                    : appMaterialButton(
                      isDisable: !auth.isRegisterFormValid.value,
                      text: AppLanguage.registerStr(appLanguage),
                      onTap: () async {
                        if(auth.isRegisterFormValid.value){
                          if (_formKey.currentState?.validate() ?? false) {
                            /// Handle register
                            await auth.handleRegisterUserButtonTap();
                          }
                        }
                      },
                    ),

                    setHeight(20.0),

                    // Row(
                    //   children: [
                    //     Expanded(child: appDivider()),
                    //     setWidth(10.0),
                    //     appText(
                    //       text: AppLanguage.continueWithStr(appLanguage),
                    //       textDirection: setTextDirection(appLanguage),
                    //       textStyle: secondaryTextStyle(),
                    //     ),
                    //     setWidth(10.0),
                    //     Expanded(child: appDivider()),
                    //   ],
                    // ),
                    //
                    // setHeight(20.0),
                    //
                    // SizedBox(
                    //   width: size.width,
                    //   child: appLogoTextButton(
                    //     iconType: IconType.PNG,
                    //     icon: icGoogle,
                    //     text: AppLanguage.signInWithGoogleStr(appLanguage)
                    //   )
                    // ),

                    setHeight(50.0),

                    appDetailTextButton(
                      detailText: AppLanguage.alreadyHaveAccountStr(appLanguage),
                      buttonText: AppLanguage.loginStr(appLanguage),
                      onTapButton: () => navigation.gotoSignInScreen(),
                    ),

                    setHeight(50.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

}
