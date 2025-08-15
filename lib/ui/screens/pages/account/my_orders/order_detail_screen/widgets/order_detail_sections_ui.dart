import 'package:danapaniexpress/core/common_imports.dart';

Widget orderDetailSectionsUI({titleText, column}) {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          width: size.width,
          padding: EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
          decoration: BoxDecoration(
            color: AppColors.backgroundColorSkin(isDark),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: AppColors.materialButtonSkin(isDark),
              width: 1.0,
            ),
          ),

          child: column,
        ),
      ),
      isRightLang
          ? Positioned(
        right: 0,
        child: Padding(
          padding: const EdgeInsets.only(right: MAIN_VERTICAL_PADDING),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6.0),
            color: AppColors.backgroundColorSkin(isDark),
            child: appText(
              text: titleText,
              textStyle: itemTextStyle().copyWith(
                  color: AppColors.materialButtonSkin(isDark),
                  fontSize: NORMAL_TEXT_FONT_SIZE
              ),
            ),
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.only(left: MAIN_VERTICAL_PADDING),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.0),
          color: AppColors.backgroundColorSkin(isDark),
          child: appText(
            text: titleText,
            textStyle: itemTextStyle().copyWith(
                color: AppColors.materialButtonSkin(isDark),
                fontSize: NORMAL_TEXT_FONT_SIZE
            ),
          ),
        ),
      ),
    ],
  );
}