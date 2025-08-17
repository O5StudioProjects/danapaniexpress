import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class AccountInformationMobile extends StatelessWidget {
  const AccountInformationMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = Get.find<AuthController>();
    var account = Get.find<AccountInfoController>();
    return _buildUI(auth, account, context);
  }

  _buildUI(auth, account, context) {
    return Obx(() {
      var data = auth.currentUser.value;
      var icArrow = isRightLang ? icArrowLeftSmall : icArrowRightSmall;

      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(
              title: AppLanguage.accountInformationStr(appLanguage),
              isBackNavigation: true,
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    /// PROFILE PICTURE SECTION
                    ProfilePictureSection(),

                    /// PROFILE PICTURE UPLOAD BUTTON
                    _uploadPictureButton(account),

                    /// Full NAME
                    _changeFullName(account, data, icArrow, context),

                    /// CHANGE EMAIL
                    _changeEmail(account, data, icArrow, context),

                    /// CHANGE PASSWORD
                    _changePassword(icArrow, context),
                    appDivider(),

                    /// UNCHANGE ABLE ITEMS
                    /// PHONE
                    _phone(data),

                    /// DEFAULT ADDRESS
                    _defaultAddress(data),

                    /// CITY
                    _city(data),

                    /// PROVINCE
                    _province(data),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _uploadPictureButton(AccountInfoController account) {
    final hasImage = kIsWeb
        ? account.selectedImageBytes.value != null
        : account.selectedImage.value != null;

    if (!hasImage) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () async => await account.uploadUserImage(),
      child: account.uploadImageStatus.value == AuthStatus.LOADING
          ? loadingIndicator()
          : Padding(
        padding: const EdgeInsets.only(bottom: MAIN_VERTICAL_PADDING),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: AppColors.materialButtonSkin(isDark),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: AppColors.materialButtonSkin(isDark),
              width: 2.0,
            ),
          ),
          child: appText(
            text: AppLanguage.uploadProfilePictureStr(appLanguage),
            textStyle: itemTextStyle().copyWith(
              color: AppColors.materialButtonTextSkin(isDark),
            ),
          ),
        ),
      ),
    );
  }


  _changeFullName(account, data, icArrow, context) {
    return Padding(
      padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING),
      child: listItemInfo(
        itemTitle: AppLanguage.fullNameStr(appLanguage),
        trailingText: data!.userFullName,
        text: data.userFullName,
        trailingIcon: icArrow,
        onItemClick: () {
          appBottomSheet(context, widget: ChangeFullNameUI());
        },
      ),
    );
  }

  _changeEmail(account, data, icArrow, context) {
    return Padding(
      padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
      child: listItemInfo(
        itemTitle: AppLanguage.changeEmailStr(appLanguage),
        trailingText: data.userEmail,
        text: data.userEmail,
        trailingIcon: icArrow,
        onItemClick: () {
          appBottomSheet(context, widget: ChangeEmailUI());
        },
      ),
    );
  }

  _changePassword(icArrow, context) {
    return Padding(
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
          appBottomSheet(context, widget: ChangePasswordUI());
        },
      ),
    );
  }

  _phone(data) {
    return Padding(
      padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING / 2),
      child: listItemInfo(
        itemTitle: AppLanguage.phoneStr(appLanguage),
        trailingText: data.userPhone,
        text: data.userPhone,
        isTrailingIcon: false,
      ),
    );
  }

  _defaultAddress(data) {
    if (data.userDefaultAddress != null) {
      return Padding(
        padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING / 2),
        child: listItemInfo(
          itemTitle: AppLanguage.addressStr(appLanguage),
          trailingText: data.userDefaultAddress!.address,
          text: data.userDefaultAddress!.address,
          isTrailingIcon: false,
        ),
      );
    }else {
      return SizedBox.shrink();
    }
  }

  _city(data) {
    if (data.userDefaultAddress != null) {
      return Padding(
        padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING / 2),
        child: listItemInfo(
          itemTitle: AppLanguage.cityStr(appLanguage),
          trailingText: data.userDefaultAddress!.city,
          text: data.userDefaultAddress!.city,
          isTrailingIcon: false,
        ),
      );
    }else {
      return SizedBox.shrink();
    }
  }

  _province(data) {
    if (data.userDefaultAddress != null) {
      return Padding(
        padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING / 2),
        child: listItemInfo(
          itemTitle: AppLanguage.provinceStr(appLanguage),
          trailingText: data.userDefaultAddress!.province,
          text: data.userDefaultAddress!.province,
          isTrailingIcon: false,
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
