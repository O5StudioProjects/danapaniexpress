import 'package:danapaniexpress/core/common_imports.dart';

class SplashScreenMobile extends StatelessWidget {
  const SplashScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI(){
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(color: EnvColors.backgroundColorLight),
      child: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
            child: appAssetImage(image: EnvImages.imgMainLogo, width: size.width, fit: BoxFit.fitWidth),
          ),

          SizedBox(
            width: size.width,
            height: size.height,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  appText(
                      text: AppLanguage.developedByStr(appLanguage),
                      textStyle: splashBodyTextStyle()),
                  setHeight(10.0),
                  appText(
                      text: EnvStrings.appVersion,
                      textStyle: splashBodyTextStyle()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
