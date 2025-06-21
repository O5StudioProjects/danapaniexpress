import 'package:danapaniexpress/core/common_imports.dart';

class StartupScreenLayoutMobile extends StatelessWidget {
  final String image;
  final String headingText;
  final String subText;
  final String buttonText;
  final Function onTap ;

  const StartupScreenLayoutMobile({super.key, required this.image, required this.headingText, required this.subText, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        mainAxisAlignment: appLanguage == ENGLISH_LANGUAGE ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: appLanguage == ENGLISH_LANGUAGE ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: size.width,
            height: size.height * 0.5,
            child: Stack(
              children: [
                SizedBox(
                  child: appAssetImage(image: image, width: size.width,height: size.height, fit: BoxFit.cover),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: size.width,
                    child: appSvgIcon(icon: EnvImages.imgWaveLight, width: size.width, color: AppColors.backgroundColorSkin(isDark)),
                  ),
                ),

              ],
            ),
          ),
          setHeight(30.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: appLanguage == ENGLISH_LANGUAGE ? MainAxisAlignment.start : MainAxisAlignment.end,
              crossAxisAlignment: appLanguage == ENGLISH_LANGUAGE ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                appText(text: headingText, textStyle: startupHeadingTextStyle()),
                setHeight(20.0),
                appText(text: subText,overFlow: null, textDirection: setTextDirection(appLanguage) , textStyle: bodyTextStyle()),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: appMaterialButton(text: buttonText, onTap: onTap),
          ),
          setHeight(10.0),
          Center(child: appTextButton(text: AppLanguage.skipStr(appLanguage),
            onTap: ()=> JumpTo.gotoSignInScreen(),
          )),
          setHeight(60.0)


        ],
      ),
    );
  }
}
