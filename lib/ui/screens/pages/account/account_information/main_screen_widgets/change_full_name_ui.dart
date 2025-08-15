import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class ChangeFullNameUI extends StatelessWidget {
  const ChangeFullNameUI({super.key});

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
            _fullNameField(account),
            setHeight(MAIN_VERTICAL_PADDING),
            _actionButton(account),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return appText(
      text: AppLanguage.updateProfileNameStr(appLanguage),
      textStyle: bigBoldHeadingTextStyle().copyWith(
        fontSize: SECONDARY_HEADING_FONT_SIZE,
      ),
    );
  }

  Widget _fullNameField(AccountInfoController account) {
    return AppTextFormField(
      textEditingController: account.accountNameTextController.value,
      prefixIcon: Icons.person,
      hintText: AppLanguage.fullNameStr(appLanguage),
      validator: FormValidations.fullNameValidator,
    );
  }

  Widget _actionButton(AccountInfoController account) {
    return Obx(() {
      if (account.updateProfileStatus.value == AuthStatus.LOADING) {
        return loadingIndicator();
      }
      return appMaterialButton(
        text: AppLanguage.updateNameStr(appLanguage),
        onTap: () async {
          if (_formKey.currentState?.validate() ?? false) {
            if (account.isAccountNameValid.value) {
              await account.handleChangeNameOnTap();
            }
          }
        },
      );
    });
  }
}
