import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/ui/app_common/components/dropdown_menu.dart';

import 'account_info_utils.dart';

class AccountInformationMobile extends StatelessWidget {
  const AccountInformationMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = Get.find<AuthController>();
    var account = Get.find<AccountInfoController>();
    return Obx((){
      var data = auth.currentUser.value;
      var icArrow = appLanguage == URDU_LANGUAGE ? icArrowLeftSmall : icArrowRightSmall;
      var imageUploadMenu = [
        ImageUploadModel(
            id: DEFAULT_IMAGE,
            icon: DEFAULT_IMAGE_ICON,
            title: AppLanguage.defaultImageStr(appLanguage).toString()),
        ImageUploadModel(
            id: UPLOAD_IMAGE,
            icon: UPLOAD_IMAGE_ICON,
            title: AppLanguage.uploadImageStr(appLanguage).toString()),
      ];
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(title: AppLanguage.accountInformationStr(appLanguage), isBackNavigation: true),

            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                    children: [
                      /// PROFILE PICTURE SECTION
                      Padding(
                        padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING *2, bottom: MAIN_VERTICAL_PADDING),
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
                                  child: account.deleteImageStatus.value == AuthStatus.LOADING
                                  ? loadingIndicator()
                                  : AppButtonDropdownMenu(
                                      options: imageUploadMenu,
                                    onSelected: (item) async {
                                      switch (item.id) {
                                        case DEFAULT_IMAGE:
                                          await account.deleteUserImage();
                                          break;
                                        case UPLOAD_IMAGE:
                                          await account.pickImage();
                                          break;
                                      }
                                    },
                                    customIcon: appFloatingButton(icon: Icons.camera_alt, iconType: IconType.ICON),
                                    itemBuilder: (item) {
                                        return Row(
                                          children: [
                                            appIcon(iconType: IconType.ICON, icon: item.icon, width: 24.0),
                                            setWidth(MAIN_HORIZONTAL_PADDING),
                                            appText(text: item.title, textStyle: bodyTextStyle())
                                          ],
                                        );
                                    },)


                                  // GestureDetector(
                                  //     onTap: () async => await account.pickImage(),
                                  //     child: appFloatingButton(icon: Icons.camera_alt, iconType: IconType.ICON))

            ),
                            ],
                          ),
                        ),
                      ),

                      /// PROFILE PICTURE UPLOAD BUTTON
                      if(account.selectedImage.value != null)
                      GestureDetector(
                        onTap: () async => await account.updateUser(),
                        child:
                        account.uploadImageStatus.value == AuthStatus.LOADING
                          ? loadingIndicator()
                          : Padding(
                            padding: const EdgeInsets.only(bottom: MAIN_VERTICAL_PADDING),
                            child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: AppColors.materialButtonSkin(isDark),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(color: AppColors.materialButtonSkin(isDark), width: 2.0)
                            ),
                            child: appText(text: AppLanguage.uploadProfilePictureStr(appLanguage), textStyle: itemTextStyle().copyWith(color: AppColors.materialButtonTextSkin(isDark)), )
                                                    ),
                          ),
                      ),

                    //  setHeight(MAIN_VERTICAL_PADDING),

                      /// Full NAME
                      Padding(
                        padding: const EdgeInsets.only(
                          top: MAIN_VERTICAL_PADDING,
                        ),
                        child: listItemInfo(
                          itemTitle: AppLanguage.fullNameStr(appLanguage),
                          trailingText: data!.userFullName,
                          text: data.userFullName,
                          trailingIcon: icArrow,
                          onItemClick: () {
                            appBottomSheet(
                              context,
                              widget: ChangeFullNameUI(),
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
                          itemTitle: AppLanguage.changeEmailStr(appLanguage),
                          trailingText: data.userEmail,
                          text: data.userEmail,
                          trailingIcon: icArrow,
                          onItemClick: () {
                            appBottomSheet(
                              context,
                              widget: ChangeEmailUI(),
                            );
                          },
                        ),
                      ),

                      /// CHANGE PASSWORD
                      Padding(
                        padding: const EdgeInsets.only(
                          top: MAIN_HORIZONTAL_PADDING,
                          bottom: MAIN_HORIZONTAL_PADDING / 2,
                        ),
                        child: listItemInfo(
                          itemTitle: AppLanguage.changePasswordStr(appLanguage),
                          trailingText: '',
                          text: '',
                          trailingIcon: icArrow,
                          onItemClick: () {
                            appBottomSheet(
                              context,
                              widget: ChangePasswordUI(),
                            );
                          },
                        ),
                      ),
                      appDivider(),

                      /// UNCHANGE ABLE ITEMS
                      /// PHONE
                      Padding(
                        padding: const EdgeInsets.only(
                          top: MAIN_HORIZONTAL_PADDING / 2,
                        ),
                        child: listItemInfo(
                          itemTitle: AppLanguage.phoneStr(appLanguage),
                          trailingText: data.userPhone,
                          text: data.userPhone,
                          isTrailingIcon: false,
                        ),
                      ),

                      /// DEFAULT ADDRESS
                      if (data.userDefaultAddress != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: MAIN_HORIZONTAL_PADDING / 2,
                          ),
                          child: listItemInfo(
                            itemTitle: AppLanguage.addressStr(appLanguage),
                            trailingText: data.userDefaultAddress!.address,
                            text: data.userDefaultAddress!.address,
                            isTrailingIcon: false,
                          ),
                        ),

                      /// CITY
                      if (data.userDefaultAddress != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: MAIN_HORIZONTAL_PADDING / 2,
                          ),
                          child: listItemInfo(
                            itemTitle: AppLanguage.cityStr(appLanguage),
                            trailingText: data.userDefaultAddress!.city,
                            text: data.userDefaultAddress!.city,
                            isTrailingIcon: false,
                          ),
                        ),

                      /// PROVINCE
                      if (data.userDefaultAddress != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: MAIN_HORIZONTAL_PADDING / 2,
                          ),
                          child: listItemInfo(
                            itemTitle: AppLanguage.provinceStr(appLanguage),
                              trailingText: data.userDefaultAddress!.province,
                              text: data.userDefaultAddress!.province,
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
    var account = Get.find<AccountInfoController>();
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
              appText(
                text: AppLanguage.updateProfileNameStr(appLanguage),
                textStyle: bigBoldHeadingTextStyle().copyWith(fontSize: SECONDARY_HEADING_FONT_SIZE),
              ),
              setHeight(MAIN_VERTICAL_PADDING),
              AppTextFormField(
                textEditingController: account.accountNameTextController.value,
                prefixIcon: Icons.person,
                hintText: AppLanguage.fullNameStr(appLanguage),
               validator: FormValidations.fullNameValidator,
              ),
              setHeight(MAIN_VERTICAL_PADDING),
              account.updateProfileStatus.value == AuthStatus.LOADING
                  ? loadingIndicator()
                  : appMaterialButton(
                text: AppLanguage.updateNameStr(appLanguage),
                onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (account.isAccountNameValid.value) {
                      await account.handleChangeNameOnTap();
                    }
                  }
                },
              ),
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
    var account = Get.find<AccountInfoController>();
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
              appText(
                text: AppLanguage.updateEmailStr(appLanguage),
                textStyle: bigBoldHeadingTextStyle().copyWith(fontSize: SECONDARY_HEADING_FONT_SIZE),
              ),
              setHeight(MAIN_VERTICAL_PADDING),
              AppTextFormField(
                textEditingController: account.accountEmailTextController.value,
                prefixIcon: Icons.person,
                hintText: AppLanguage.emailStr(appLanguage),
                validator: FormValidations.emailValidator,
              ),
              setHeight(MAIN_VERTICAL_PADDING),
              account.updateProfileStatus.value == AuthStatus.LOADING
                  ? loadingIndicator()
                  : appMaterialButton(
                text: AppLanguage.changeEmailStr(appLanguage),
                onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (account.isAccountEmailValid.value) {
                      await account.handleChangeEmailOnTap();
                    }
                  }
                },
              ),
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
    var account = Get.find<AccountInfoController>();
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
              appText(
                text: AppLanguage.changePasswordStr(appLanguage),
                textStyle: bigBoldHeadingTextStyle().copyWith(fontSize: SECONDARY_HEADING_FONT_SIZE),
              ),
              setHeight(MAIN_VERTICAL_PADDING),
              AppTextFormField(
                textEditingController: account.accountCurrentPasswordTextController.value,
                prefixIcon: Icons.lock,
                hintText: AppLanguage.currentPasswordStr(appLanguage),
                isPassword: true,
                validator: FormValidations.passwordValidator,
              ),
              setHeight(MAIN_HORIZONTAL_PADDING),
              AppTextFormField(
                textEditingController: account.accountNewPasswordTextController.value,
                prefixIcon: Icons.lock,
                hintText: AppLanguage.newPasswordStr(appLanguage),
                isPassword: true,
                validator: FormValidations.passwordValidator,
              ),
              setHeight(MAIN_HORIZONTAL_PADDING),
              AppTextFormField(
                textEditingController: account.accountConfirmNewPasswordTextController.value,
                prefixIcon: Icons.lock,
                hintText: AppLanguage.confirmNewPasswordStr(appLanguage),
                isPassword: true,
                validator: FormValidations.passwordValidator,
              ),
              setHeight(MAIN_VERTICAL_PADDING),
              account.updateProfileStatus.value == AuthStatus.LOADING
                  ? loadingIndicator()
                  : appMaterialButton(
                text: AppLanguage.changePasswordStr(appLanguage),
                onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (account.isAccountPasswordValid.value) {
                      await account.handleChangePasswordOnTap();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
