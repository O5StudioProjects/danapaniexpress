import 'package:danapaniexpress/core/common_imports.dart';

class EmptyScreen extends StatelessWidget {
  final String icon;
  final String text;
  const EmptyScreen({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Obx(
          ()=> Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.5,
                  height: size.width * 0.4,
                  color: Colors.transparent,
                  child: appIcon(icon: icon, iconType: IconType.ANIM),
                ),

                setHeight(MAIN_VERTICAL_PADDING),
                appText(text: text, textStyle: bodyTextStyle().copyWith(
                    color: AppColors.materialButtonSkin(isDark),
                  fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE
                ))
              ],
            ),
          ),
        ));
  }
}


class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Obx(
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
        ));
  }
}