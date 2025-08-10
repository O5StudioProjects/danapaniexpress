import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class EmptyScreen extends StatelessWidget {
  final dynamic icon;
  final IconType iconType;
  final String text;
  final dynamic color;
  const EmptyScreen({super.key, required this.icon, required this.text, this.iconType = IconType.ANIM, this.color});

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size.width * 0.5,
              height: size.width * 0.4,
              color: Colors.transparent,
              child: appIcon(icon: icon, iconType: iconType, color: color),
            ),

            setHeight(MAIN_VERTICAL_PADDING),
            appText(text: text, textStyle: bodyTextStyle().copyWith(
                color: AppColors.materialButtonSkin(isDark),
              fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE
            ))
          ],
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          ()=> Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            appIcon(icon: AppAnims.animErrorSkin(isDark), iconType: IconType.ANIM, width: size.width * 0.5),
            setHeight(MAIN_VERTICAL_PADDING),
            appText(text: 'Server Error', textStyle: bodyTextStyle().copyWith(
                color: AppColors.materialButtonSkin(isDark),
                fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE
            ))
          ],
        ),
      ),
    );
  }
}

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    var navigation = Get.find<NavigationController>();
    return Obx((){
      var isStart = Get.arguments[IS_START] as bool;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            appIcon(icon: animNoInternet, iconType: IconType.ANIM, width: size.width * 0.5),
            setHeight(MAIN_VERTICAL_PADDING),
            appText(text: internet ? 'Internet Connection Restored' : 'Check your internet connection', textStyle: bodyTextStyle().copyWith(
                color: AppColors.materialButtonSkin(isDark),
                fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE
            )),

            internet
                ? Padding(
              padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING, right: MAIN_HORIZONTAL_PADDING, left: MAIN_HORIZONTAL_PADDING),
              child:
            appMaterialButton(text: 'Go Back', onTap: (){
                if(isStart){
                  navigation.gotoDashboardScreen();
                } else {
                  Get.back();
                }
              }),
            )
                : SizedBox.shrink()
          ],
        ),
      );
    });
  }
}

