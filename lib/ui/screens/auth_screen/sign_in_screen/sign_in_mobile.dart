import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class SignInMobile extends StatelessWidget {
  const SignInMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var navigation = Get.find<NavigationController>();
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: MAIN_VERTICAL_PADDING,
                  ),
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
                      AppTextFormField(
                        prefixIcon: Icons.person,
                        hintText: AppLanguage.emailPhoneStr(appLanguage),
                      ),
                      setHeight(20.0),
                      AppTextFormField(
                        prefixIcon: Icons.lock_outline,
                        hintText: AppLanguage.passwordStr(appLanguage),
                        isPassword: true,
                      ),
                      setHeight(10.0),
                      Align(
                        alignment: appLanguage == ENGLISH_LANGUAGE
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: ()=> navigation.gotoForgotPasswordScreen(),
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
                      appMaterialButton(
                        text: AppLanguage.loginStr(appLanguage),
                        onTap: () {
                          // Handle login
                        },
                      ),
                      // setHeight(10.0),
                      // SizedBox(
                      //     width: size.width,
                      //     child: appLogoTextButton(
                      //         iconType: IconType.PNG,
                      //         icon: icGoogle,
                      //         text: AppLanguage.signInWithGoogleStr(appLanguage)
                      //     )
                      // ),

                      setHeight(60.0),

                      appDetailTextButton(
                        detailText: AppLanguage.dontHaveAccountStr(appLanguage),
                        buttonText: AppLanguage.signUpStr(appLanguage),
                        onTapButton: ()=> navigation.gotoRegisterScreen()
                      ),
                      setHeight(10.0),

                      GestureDetector(
                        onTap: ()=> navigation.gotoDashboardScreen(),
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

                // Optional Spacer
                // Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
