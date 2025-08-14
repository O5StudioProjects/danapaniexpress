import 'package:danapaniexpress/core/common_imports.dart';

class CheckoutDetailStatus extends StatelessWidget {
  final String title;
  final bool isDone;
  const CheckoutDetailStatus({super.key, required this.title, this.isDone = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        appText(
          text: title,
          textStyle: itemTextStyle().copyWith(fontSize: NORMAL_TEXT_FONT_SIZE),
        ),
        setWidth(6.0),
        appIcon(
          iconType: IconType.ICON,
          icon: isDone ? Icons.verified_rounded : Icons.verified_outlined,
          color: isDone
              ? AppColors.materialButtonSkin(isDark)
              : AppColors.secondaryTextColorSkin(isDark),
          width: 16.0,
        ),
      ],
    );
  }
}
