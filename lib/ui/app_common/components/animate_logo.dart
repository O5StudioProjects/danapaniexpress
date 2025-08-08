
import 'package:danapaniexpress/core/common_imports.dart';

class AppAnimatedLogo extends StatelessWidget {
  const AppAnimatedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background Lottie sparkles animation
        SizedBox(
          width: 200,
          height: 200,
          child: appIcon(iconType: IconType.ANIM, icon: AppAnims.animLogoBgSkin(isDark)),
        ),

        // Center logo
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent
          ),
          child: ClipOval(
            // child: appAssetImage(image: EnvImages.imgMainLogo, width: 150.0, fit: BoxFit.cover),
            child: appAssetImage(image: icFadedAdminLogo, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
