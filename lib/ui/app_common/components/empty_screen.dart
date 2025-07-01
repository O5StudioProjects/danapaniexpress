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
                appIcon(icon: icon, iconType: IconType.PNG, width: size.width * 0.15, color: AppColors.materialButtonSkin(isDark)),
                setHeight(20.0),
                appText(text: text, textStyle: bodyTextStyle().copyWith(
                    color: AppColors.materialButtonSkin(isDark)
                ))
              ],
            ),
          ),
        ));
  }
}
