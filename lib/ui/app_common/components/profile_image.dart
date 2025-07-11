import 'package:danapaniexpress/core/common_imports.dart';

class ProfileImage extends StatelessWidget {
  final String? profileImage;
  const ProfileImage({super.key, required this.profileImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(100.0),
          border: Border.all(color: AppColors.backgroundColorSkin(isDark), width: 1.0)
      ),
      child:
      profileImage != null && profileImage!.isNotEmpty
          ? appAsyncImage(
        profileImage,
        boxFit: BoxFit.cover,
      )
          : appAssetImage(image: EnvImages.imgMainLogo, fit: BoxFit.cover),
    );
  }
}
