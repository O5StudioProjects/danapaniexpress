import 'package:danapaniexpress/core/common_imports.dart';

void appBottomSheet(BuildContext context, {widget}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Container(
        width: size.width,
        padding: EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING, vertical: MAIN_VERTICAL_PADDING),
        decoration: BoxDecoration(
          color: AppColors.backgroundColorSkin(isDark),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0))
        ),
        child: widget,
      );
    },
  );
}
