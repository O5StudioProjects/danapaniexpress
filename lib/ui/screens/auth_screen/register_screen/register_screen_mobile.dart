import 'package:danapaniexpress/core/common_imports.dart';

class RegisterScreenMobile extends StatelessWidget {
  const RegisterScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
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
                  text: AppLanguage.registerStr(appLanguage),
                  textDirection: setTextDirection(appLanguage),
                  textStyle: loginHeadingTextStyle(),
                ),
                setHeight(10.0),
                appText(
                  text: AppLanguage.createNewAccountStr(appLanguage),
                  textDirection: setTextDirection(appLanguage),
                  textStyle: secondaryTextStyle(),
                ),
                setHeight(20.0),

                AppTextFormField(
                  prefixIcon: Icons.person,
                  hintText: AppLanguage.fullNameStr(appLanguage),
                ),
                setHeight(20.0),

                AppTextFormField(
                  prefixIcon: Icons.email,
                  hintText: AppLanguage.emailStr(appLanguage),
                ),
                setHeight(20.0),

                AppTextFormField(
                  prefixIcon: Icons.phone,
                  hintText: AppLanguage.phoneStr(appLanguage),
                ),

                setHeight(20.0),
                AppTextFormField(
                  prefixIcon: Icons.lock_outline,
                  hintText: AppLanguage.passwordStr(appLanguage),
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
                  text: AppLanguage.registerStr(appLanguage),
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
                  onTapButton: () => JumpTo.gotoSignInScreen(),
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
