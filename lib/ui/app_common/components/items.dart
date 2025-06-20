
import'package:danapaniexpress/core/common_imports.dart';

Widget listItemIcon({iconType, leadingIcon, isPngColor = false, itemTitle, trailingIcon, onItemClick}) {
  return GestureDetector(
    onTap: onItemClick,
    child: Container(
      width: size.width,
      height: LIST_ITEM_HEIGHT,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: AppColors.cardColorSkin(isDark),
      ),
      child: appLanguage == ENGLISH_LANGUAGE
          ? Row(
          children: [
            setIcon(iconType: iconType, iconName: leadingIcon, isPngColor: isPngColor, color: AppColors.backgroundColorInverseSkin(isDark)),
            // appSvgIcon(icon: leadingIcon, width: 24.0, color: AppColors.blackInLightWhiteInDarkSkin(isDark)),
            setWidth(8.0),
            Expanded(child: appText(text: itemTitle,textAlign: TextAlign.start, textStyle: itemTextStyle())),
            setWidth(8.0),
            appSvgIcon(icon: trailingIcon, width: 24.0, color: AppColors.materialButtonSkin(isDark)),
          ])
          : Row(
          children: [
            appSvgIcon(icon: trailingIcon, width: 24.0, color: AppColors.materialButtonSkin(isDark)),
            setWidth(8.0),
            Expanded(child: appText(text: itemTitle, textAlign: TextAlign.end, textStyle: itemTextStyle())),
            setWidth(8.0),
            setIcon(iconType: iconType, iconName: leadingIcon, isPngColor: isPngColor, color: AppColors.backgroundColorInverseSkin(isDark)),
            // appSvgIcon(icon: leadingIcon, width: 24.0, color: AppColors.blackInLightWhiteInDarkSkin(isDark)),
          ]),
    ),
  );
}
