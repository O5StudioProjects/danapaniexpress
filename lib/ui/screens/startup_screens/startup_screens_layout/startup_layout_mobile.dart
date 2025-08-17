import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/packages_import.dart';

class StartupScreenLayoutMobile extends StatelessWidget {
  const StartupScreenLayoutMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final startupController = Get.find<StartupController>();

    return Obx((){
      return _buildUI(startupController);
    });
  }

  Widget _buildUI(startupController){
    return Container(
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
                  crossAxisAlignment: !isRightLang
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: size.width,
                      height: size.height * 0.5,
                      child: Stack(
                        children: [
                          _imageSection(data),
                          _waveSection(),
                        ],
                      ),
                    ),
                    _descriptionSection(data),
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

          /// Button
          _buttonSection(startupController),

        ],
      ),
    );
  }

  Widget _imageSection(data){
    return SizedBox(
      height: size.height * 0.49,
      child: appAssetImage(
        image: data.image,
        width: size.width,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _waveSection(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: appSvgIcon(
        icon: EnvImages.imgWave,
        width: size.width,
        color: AppColors.backgroundColorSkin(isDark),
      ),
    );
  }

  Widget _descriptionSection(data){
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: !isRightLang
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            _heading(data),
            _subText(data),
          ],
        ),
      ),
    );
  }

  Widget _heading(data){
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
      child: appText(
        text: data.headingText,
        textStyle: startupHeadingTextStyle(),
      ),
    );
  }

  Widget _subText(data){
    return appText(
      text: data.subText,
      overFlow: null,
      textDirection: setTextDirection(appLanguage),
      textStyle: bodyTextStyle(),
    );
  }

  Widget _buttonSection(startupController){
    return Padding(
      padding: const EdgeInsets.only(left: MAIN_HORIZONTAL_PADDING, right: MAIN_HORIZONTAL_PADDING, bottom: 50.0, top: 30.0),
      child: appMaterialButton(
        text: startUpData[startupController.index.value].buttonText,
        onTap: startupController.onTapNext,
      ),
    );
  }

}
