import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class ProfilePictureSection extends StatelessWidget {
  const ProfilePictureSection({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final account = Get.find<AccountInfoController>();
    return _profilePictureUI(auth, account);
  }

  Widget _profilePictureUI(AuthController auth, AccountInfoController account) {
    return Obx(() {
      final data = auth.currentUser.value;
      final imageUploadMenu = _imageUploadMenu();

      return Padding(
        padding: const EdgeInsets.only(
          top: MAIN_VERTICAL_PADDING * 2,
          bottom: MAIN_VERTICAL_PADDING,
        ),
        child: SizedBox(
          width: 100.0,
          height: 105.0,
          child: Stack(
            children: [
              _profileImageContainer(account, data),
              Positioned(
                bottom: 0,
                right: 0,
                child: _actionButton(account, imageUploadMenu),
              ),
            ],
          ),
        ),
      );
    });
  }

  List<ImageUploadModel> _imageUploadMenu() {
    return [
      ImageUploadModel(
        id: DEFAULT_IMAGE,
        icon: DEFAULT_IMAGE_ICON,
        title: AppLanguage.defaultImageStr(appLanguage).toString(),
      ),
      ImageUploadModel(
        id: UPLOAD_IMAGE,
        icon: UPLOAD_IMAGE_ICON,
        title: AppLanguage.uploadImageStr(appLanguage).toString(),
      ),
    ];
  }

  Widget _profileImageContainer(AccountInfoController account, dynamic data) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: whiteColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.materialButtonSkin(isDark),
          width: 2.0,
        ),
      ),
      child: ClipOval(
        child: kIsWeb
            ? (account.selectedImageBytes.value != null
            ? Image.memory(
          account.selectedImageBytes.value!,
          fit: BoxFit.cover,
          width: 100,
          height: 100,
        )
            : (data != null && data.userImage?.isNotEmpty == true)
            ? appAsyncImage(data.userImage, boxFit: BoxFit.cover)
            : appAssetImage(
          image: EnvImages.imgMainLogo,
          fit: BoxFit.cover,
        ))
            : (account.selectedImage.value != null
            ? Image.file(
          account.selectedImage.value!,
          fit: BoxFit.cover,
          width: 100,
          height: 100,
        )
            : (data != null && data.userImage?.isNotEmpty == true)
            ? appAsyncImage(data.userImage, boxFit: BoxFit.cover)
            : appAssetImage(
          image: EnvImages.imgMainLogo,
          fit: BoxFit.cover,
        )),
      ),
    );
  }


  Widget _actionButton(
      AccountInfoController account,
      List<ImageUploadModel> imageUploadMenu,
      ) {
    if (account.deleteImageStatus.value == AuthStatus.LOADING) {
      return loadingIndicator();
    }

    return AppButtonDropdownMenu(
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
      customIcon: appFloatingButton(
        icon: Icons.camera_alt,
        iconType: IconType.ICON,
      ),
      itemBuilder: (item) {
        return Row(
          children: [
            appIcon(
              iconType: IconType.ICON,
              icon: item.icon,
              width: 24.0,
            ),
            setWidth(MAIN_HORIZONTAL_PADDING),
            appText(text: item.title, textStyle: bodyTextStyle()),
          ],
        );
      },
    );
  }
}
