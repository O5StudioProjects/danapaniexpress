import 'package:danapaniexpress/core/common_imports.dart';

class ProfileImage extends StatelessWidget {
  final String? profileImage;
  const ProfileImage({super.key, required this.profileImage});

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
          color: whiteColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.cardColorSkin(isDark),
            width: 2.0,
          ),
        ),
        child: ClipOval(
          child: profileImage != null && profileImage!.isNotEmpty
              ? appAsyncImage(
            profileImage,
            boxFit: BoxFit.cover,
          )
              : appAssetImage(image: EnvImages.imgMainLogo, fit: BoxFit.cover),
        ),
      );
  }
}
