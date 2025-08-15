import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class ChangePasswordUI extends StatelessWidget {
  const ChangePasswordUI({super.key});

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final account = Get.find<AccountInfoController>();
    return _buildUI(context, account);
  }

  Widget _buildUI(BuildContext context, AccountInfoController account) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom + MAIN_VERTICAL_PADDING;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        MAIN_HORIZONTAL_PADDING,
        MAIN_VERTICAL_PADDING,
        MAIN_HORIZONTAL_PADDING,
        bottomPadding,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _title(),
            setHeight(MAIN_VERTICAL_PADDING),
            _passwordField(
              controller: account.accountCurrentPasswordTextController.value,
              hint: AppLanguage.currentPasswordStr(appLanguage).toString(),
            ),
            setHeight(MAIN_HORIZONTAL_PADDING),
            _passwordField(
              controller: account.accountNewPasswordTextController.value,
              hint: AppLanguage.newPasswordStr(appLanguage).toString(),
            ),
            setHeight(MAIN_HORIZONTAL_PADDING),
            _passwordField(
              controller: account.accountConfirmNewPasswordTextController.value,
              hint: AppLanguage.confirmNewPasswordStr(appLanguage).toString(),
            ),
            setHeight(MAIN_VERTICAL_PADDING),
            _actionButton(account),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return appText(
      text: AppLanguage.changePasswordStr(appLanguage),
      textStyle: bigBoldHeadingTextStyle().copyWith(
        fontSize: SECONDARY_HEADING_FONT_SIZE,
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
  }) {
    return AppTextFormField(
      textEditingController: controller,
      prefixIcon: Icons.lock,
      hintText: hint,
      isPassword: true,
      validator: FormValidations.passwordValidator,
    );
  }

  Widget _actionButton(AccountInfoController account) {
    return Obx(() {
      if (account.updateProfileStatus.value == AuthStatus.LOADING) {
        return loadingIndicator();
      }
      return appMaterialButton(
        text: AppLanguage.changePasswordStr(appLanguage),
        onTap: () async {
          if (_formKey.currentState?.validate() ?? false) {
            if (account.isAccountPasswordValid.value) {
              await account.handleChangePasswordOnTap();
            }
          }
        },
      );
    });
  }
}
