import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/packages_import.dart';

class StartupScreenLayoutMobile extends StatelessWidget {
  const StartupScreenLayoutMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final startupController = Get.find<StartupController>();

    return Obx(() => Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: startupController.pageController,
              onPageChanged: startupController.onPageChanged,
              itemCount: startUpData.length,
              itemBuilder: (context, i) {
                final data = startUpData[i];
                return Column(
                  crossAxisAlignment: appLanguage == !isRightLang
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: size.width,
                      height: size.height * 0.5,
                      child: Stack(
                        children: [
                          appAssetImage(
                            image: data.image,
                            width: size.width,
                            height: size.height,
                            fit: BoxFit.cover,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: appSvgIcon(
                              icon: EnvImages.imgWave,
                              width: size.width,
                              color: AppColors.backgroundColorSkin(isDark),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: appLanguage == !isRightLang
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.end,
                          children: [
                            setHeight(30.0),
                            appText(
                              text: data.headingText,
                              textStyle: startupHeadingTextStyle(),
                            ),
                            setHeight(20.0),
                            appText(
                              text: data.subText,
                              overFlow: null,
                              textDirection: setTextDirection(appLanguage),
                              textStyle: bodyTextStyle(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          /// Smooth Page Indicator
          SmoothPageIndicator(
            controller: startupController.pageController,
            count: startUpData.length,
            effect: WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: AppColors.materialButtonSkin(isDark),
              dotColor: Colors.grey.shade400,
            ),
          ),

          setHeight(30.0),

          /// Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: appMaterialButton(
              text: startUpData[startupController.index.value].buttonText,
              onTap: startupController.onTapNext,
            ),
          ),

          /// Skip Button
          setHeight(10.0),
          // startupController.index.value == startUpData.length -1
          // ? SizedBox()
          // : Center(
          //   child: appTextButton(
          //     text: AppLanguage.skipStr(appLanguage),
          //     onTap: startupController.onSkip,
          //   ),
          // ),
          setHeight(40.0),
        ],
      ),
    ));
  }
}
