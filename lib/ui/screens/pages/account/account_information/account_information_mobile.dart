import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/ui/app_common/components/bottom_sheet.dart';
import 'package:danapaniexpress/ui/app_common/components/profile_image.dart';

class AccountInformationMobile extends StatelessWidget {
  const AccountInformationMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = Get.find<AuthController>();
    var account = Get.find<AccountController>();
    return Obx((){
      var data = auth.currentUser.value;
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(title: 'Account Information', isBackNavigation: true),

            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                    children: [
                      /// PROFILE PICTURE SECTION
                      Padding(
                        padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING, bottom: MAIN_HORIZONTAL_PADDING),
                        child: SizedBox(
                          width: 100.0,
                          height: 105.0,
                          child: Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.materialButtonSkin(isDark),
                                    width: 2.0,
                                  ),
                                ),
                                child: ClipOval(
                                  child: account.selectedImage.value != null
                                      ? Image.file(
                                    account.selectedImage.value!,
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  )
                                      : data != null && data.userImage!.isNotEmpty
                                      ? appAsyncImage(
                                    data.userImage,
                                    boxFit: BoxFit.cover,
                                  )
                                      : appAssetImage(
                                    image: EnvImages.imgMainLogo,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                      onTap: () async => await account.pickImage(),
                                      child: appFloatingButton(icon: Icons.camera_alt, iconType: IconType.ICON))),
                            ],
                          ),
                        ),
                      ),

                      /// PROFILE PICTURE UPLOAD BUTTON
                      GestureDetector(
                        onTap: ()=> account.handleUploadProfilePictureOnTap(),
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: AppColors.materialButtonSkin(isDark),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: AppColors.materialButtonSkin(isDark), width: 2.0)
                          ),
                          child: appText(text: 'Upload Profile Picture', textStyle: itemTextStyle().copyWith(color: AppColors.materialButtonTextSkin(isDark)), )
                        ),
                      ),

                      setHeight(MAIN_VERTICAL_PADDING),

                      /// Full NAME
                      Padding(
                        padding: const EdgeInsets.only(
                          top: MAIN_VERTICAL_PADDING,
                        ),
                        child: listItemInfo(
                          itemTitle: 'Full Name',
                          trailingText: data!.userFullName,
                          trailingIcon: icArrowRight,
                          onItemClick: () {
                            appBottomSheet(
                                context,
                                widget: ChangeFullNameUI()
                            );
                          },
                        ),
                      ),

                      /// CHANGE EMAIL
                      Padding(
                        padding: const EdgeInsets.only(
                          top: MAIN_HORIZONTAL_PADDING,
                        ),
                        child: listItemInfo(
                          itemTitle: 'Change Email',
                          trailingText: data.userEmail,
                          trailingIcon: icArrowRight,
                          onItemClick: () {
                            appBottomSheet(
                                context,
                                widget: ChangeEmailUI()
                            );
                          },
                        ),
                      ),

                      /// CHANGE PASSWORD
                      Padding(
                        padding: const EdgeInsets.only(
                          top: MAIN_HORIZONTAL_PADDING,
                          bottom: MAIN_HORIZONTAL_PADDING /2
                        ),
                        child: listItemInfo(
                          itemTitle: 'Change Password',
                          trailingText: '',
                          trailingIcon: icArrowRight,
                          onItemClick: () {
                            appBottomSheet(
                                context,
                                widget: ChangePasswordUI()
                            );
                          },
                        ),
                      ),
                      appDivider(),

                      /// UNCHANGE ABLE ITEMS
                      /// PHONE
                      Padding(
                        padding: const EdgeInsets.only(
                          top: MAIN_HORIZONTAL_PADDING/2,
                        ),
                        child: listItemInfo(
                          itemTitle: 'Phone',
                          trailingText: data.userPhone,
                          isTrailingIcon: false,
                        ),
                      ),

                      /// DEFAULT ADDRESS
                      if(data.userDefaultAddress != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: MAIN_HORIZONTAL_PADDING/2,
                          ),
                          child: listItemInfo(
                            itemTitle: 'Address',
                            trailingText: data.userDefaultAddress!.address,
                            isTrailingIcon: false,
                          ),
                        ),

                      /// CITY
                      if(data.userDefaultAddress != null)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: MAIN_HORIZONTAL_PADDING/2,
                        ),
                        child: listItemInfo(
                          itemTitle: 'City',
                          trailingText: data.userDefaultAddress!.city,
                          isTrailingIcon: false,
                        ),
                      ),


                      /// PROVICE
                      if(data.userDefaultAddress != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: MAIN_HORIZONTAL_PADDING/2,
                          ),
                          child: listItemInfo(
                            itemTitle: 'Province',
                            trailingText: data.userDefaultAddress!.province,
                            isTrailingIcon: false,
                          ),
                        ),

                    ]
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class ChangeFullNameUI extends StatelessWidget {
  ChangeFullNameUI({super.key});
  final _formKey = GlobalKey<FormState>(); // 🔑 Form key

  @override
  Widget build(BuildContext context) {
    var account = Get.find<AccountController>();
    return Obx(() {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + MAIN_VERTICAL_PADDING,
          left: MAIN_HORIZONTAL_PADDING,
          right: MAIN_HORIZONTAL_PADDING,
          top: MAIN_VERTICAL_PADDING,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              appText(text: 'Update Profile Name', textStyle: bigBoldHeadingTextStyle().copyWith(fontSize: SECONDARY_HEADING_FONT_SIZE)),
              setHeight(MAIN_VERTICAL_PADDING),
              AppTextFormField(
                textEditingController: account.accountNameTextController.value,
                prefixIcon: Icons.person,
                hintText: AppLanguage.fullNameStr(appLanguage),
                validator: FormValidations.fullNameValidator,
              ),
              setHeight(MAIN_VERTICAL_PADDING),
              appMaterialButton(text: 'Change Name', onTap: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  if (account.isAccountNameValid.value) {
                    print('Change Full Name'); // ✅ This will now run
                  } else {
                    // Optional: show warning if not valid by your rules
                    Get.snackbar("Error", "Name change failed. try again later.");
                  }
                }
              })
            ],
          ),
        ),
      );
    });
  }
}

class ChangeEmailUI extends StatelessWidget {
   ChangeEmailUI({super.key});
  final _formKey = GlobalKey<FormState>(); // 🔑 Form key

  @override
  Widget build(BuildContext context) {
    var account = Get.find<AccountController>();
    return Obx(() {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + MAIN_VERTICAL_PADDING,
          left: MAIN_HORIZONTAL_PADDING,
          right: MAIN_HORIZONTAL_PADDING,
          top: MAIN_VERTICAL_PADDING,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              appText(text: 'Update Email', textStyle: bigBoldHeadingTextStyle().copyWith(fontSize: SECONDARY_HEADING_FONT_SIZE)),
              setHeight(MAIN_VERTICAL_PADDING),
              AppTextFormField(
                textEditingController: account.accountEmailTextController.value,
                prefixIcon: Icons.person,
                hintText: AppLanguage.emailStr(appLanguage),
                validator: FormValidations.emailValidator,
              ),
              setHeight(MAIN_VERTICAL_PADDING),
              appMaterialButton(text: 'Change Email', onTap: () {
                if (_formKey.currentState?.validate() ?? false) {
                  if (account.isAccountEmailValid.value) {
                    print('Change Email'); // ✅ This will now run
                  } else {
                    // Optional: show warning if not valid by your rules
                    Get.snackbar("Error", "Email change failed. try again later.");
                  }
                }
              })
            ],
          ),
        ),
      );
    });
  }
}

class ChangePasswordUI extends StatelessWidget {
  ChangePasswordUI({super.key});
  final _formKey = GlobalKey<FormState>(); // 🔑 Form key

  @override
  Widget build(BuildContext context) {
    var account = Get.find<AccountController>();
    return Obx(() {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + MAIN_VERTICAL_PADDING,
          left: MAIN_HORIZONTAL_PADDING,
          right: MAIN_HORIZONTAL_PADDING,
          top: MAIN_VERTICAL_PADDING,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              appText(text: 'Change Password', textStyle: bigBoldHeadingTextStyle().copyWith(fontSize: SECONDARY_HEADING_FONT_SIZE)),
              setHeight(MAIN_VERTICAL_PADDING),
              AppTextFormField(
                textEditingController: account.accountOldPasswordTextController.value,
                prefixIcon: Icons.lock,
                hintText: 'Old Password',
                isPassword: true,
                validator: FormValidations.passwordValidator,
              ),
              setHeight(MAIN_HORIZONTAL_PADDING),
              AppTextFormField(
                textEditingController: account.accountNewPasswordTextController.value,
                prefixIcon: Icons.lock,
                hintText: 'New Password',
                isPassword: true,
                validator: FormValidations.passwordValidator,
              ),
              setHeight(MAIN_HORIZONTAL_PADDING),
              AppTextFormField(
                textEditingController: account.accountConfirmNewPasswordTextController.value,
                prefixIcon: Icons.lock,
                hintText: 'Confirm New Password',
                isPassword: true,
                validator: FormValidations.passwordValidator,
              ),
              setHeight(MAIN_VERTICAL_PADDING),
              appMaterialButton(text: 'Change Password', onTap: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  if (account.isAccountPasswordValid.value) {
                    await account.handleChangePasswordOnTap();
                  } else {
                    // Optional: show warning if not valid by your rules
                    Get.snackbar("Mismatched", "New Password and Confirm New password are not same.");
                  }
                }
              })
            ],
          ),
        ),
      );
    });
  }
}