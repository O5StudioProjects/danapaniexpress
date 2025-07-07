import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class ForgotPasswordMobile extends StatelessWidget {
  const ForgotPasswordMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var navigation = Get.find<NavigationController>();
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: size.height),
          child: Padding(
            padding: const EdgeInsets.all(MAIN_VERTICAL_PADDING),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                setHeight(60.0),
                appText(
                  text: AppLanguage.forgotPasswordStr(appLanguage),
                  textDirection: setTextDirection(appLanguage),
                  textStyle: bigBoldHeadingTextStyle(),
                ),
                setHeight(10.0),
                appText(
                  text: AppLanguage.recoverYourAccountStr(appLanguage),
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
                  hintText: AppLanguage.newPasswordStr(appLanguage),
                  isPassword: true,
                ),
                setHeight(20.0),

                AppTextFormField(
                  prefixIcon: Icons.lock_outline,
                  hintText: AppLanguage.reEnterPasswordStr(appLanguage),
                  isPassword: true,
                ),
                setHeight(40.0),

                appMaterialButton(
                  text: AppLanguage.confirmStr(appLanguage),
                  onTap: () {
                    /// Handle register
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
    );
  }
}
