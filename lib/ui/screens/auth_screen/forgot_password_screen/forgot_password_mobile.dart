import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class ForgotPasswordMobile extends StatelessWidget {
  const ForgotPasswordMobile({super.key});

  @override
  Widget build(BuildContext context) {

    return _buildUI(context);
  }
  
  Widget _buildUI(BuildContext context){
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: _mainContent(),
    );
  }
  
  _mainContent(){
    var auth = Get.find<AuthController>();
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: size.height),
        child: Padding(
          padding: const EdgeInsets.all(MAIN_VERTICAL_PADDING),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              _titleSection(),
              
              _tagTitle(),
              
              _phone(auth),
              
              _newPassword(auth),
              
              _confirmPassword(auth),
              
              _button(auth),

              _loginButton(),

              setHeight(50.0),
            ],
          ),
        ),
      ),
    );
  }
  
  _titleSection(){
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: appText(
        text: AppLanguage.forgotPasswordStr(appLanguage),
        textDirection: setTextDirection(appLanguage),
        textStyle: bigBoldHeadingTextStyle(),
      ),
    );
  }
  
  _tagTitle(){
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: appText(
        text: AppLanguage.recoverYourAccountStr(appLanguage),
        textDirection: setTextDirection(appLanguage),
        textStyle: secondaryTextStyle(),
      ),
    );
  }

  _phone(AuthController auth){
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: AppTextFormField(
        textEditingController: auth.forgotPhoneController.value,
        prefixIcon: Icons.person,
        hintText: AppLanguage.phoneStr(appLanguage),
      ),
    );
  }
  
  _newPassword(AuthController auth){
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: AppTextFormField(
        textEditingController: auth.forgotNewPasswordController.value,
        prefixIcon: Icons.lock_outline,
        hintText: AppLanguage.newPasswordStr(appLanguage),
        isPassword: true,
      ),
    );
  }
  
  _confirmPassword(AuthController auth){
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: AppTextFormField(
        textEditingController: auth.forgotConfirmNewPasswordController.value,
        prefixIcon: Icons.lock_outline,
        hintText: AppLanguage.reEnterPasswordStr(appLanguage),
        isPassword: true,
      ),
    );
  }
  
  _button(AuthController auth){
    return Obx((){
      return Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child:
          auth.forgotPasswordStatus.value == Status.LOADING
              ? loadingIndicator()
              : appMaterialButton(
            text: AppLanguage.confirmStr(appLanguage),
            onTap: () async {
              await auth.forgotPassword();
            },
          )
      );
    });
  }
  
  _loginButton(){
    var nav = Get.find<NavigationController>();
    return Padding(
      padding: const EdgeInsets.only(top: 70.0),
      child: appDetailTextButton(
        detailText: AppLanguage.alreadyHaveAccountStr(appLanguage),
        buttonText: AppLanguage.loginStr(appLanguage),
        onTapButton: () => nav.gotoSignInScreen(),
      ),
    );
  }
  
}
