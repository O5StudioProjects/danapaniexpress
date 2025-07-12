import 'package:danapaniexpress/core/common_imports.dart';

Widget listItemIcon({
  iconType,
  leadingIcon,
  isPngColor = false,
  itemTitle,
  trailingIcon,
  onItemClick,
}) {
  return GestureDetector(
    onTap: onItemClick,
    child: Container(
      width: size.width,
      height: LIST_ITEM_HEIGHT,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(color: AppColors.cardColorSkin(isDark)),
      child: appLanguage == ENGLISH_LANGUAGE
          ? Row(
              children: [
                setIcon(
                  iconType: iconType,
                  iconName: leadingIcon,
                  isPngColor: isPngColor,
                  color: AppColors.backgroundColorInverseSkin(isDark),
                ),
                // appSvgIcon(icon: leadingIcon, width: 24.0, color: AppColors.blackInLightWhiteInDarkSkin(isDark)),
                setWidth(8.0),
                Expanded(
                  child: appText(
                    text: itemTitle,
                    textAlign: TextAlign.start,
                    textStyle: bodyTextStyle(),
                  ),
                ),
                setWidth(8.0),
                appSvgIcon(
                  icon: trailingIcon,
                  width: 24.0,
                  color: AppColors.materialButtonSkin(isDark),
                ),
              ],
            )
          : Row(
              children: [
                appSvgIcon(
                  icon: trailingIcon,
                  width: 24.0,
                  color: AppColors.materialButtonSkin(isDark),
                ),
                setWidth(8.0),
                Expanded(
                  child: appText(
                    text: itemTitle,
                    textAlign: TextAlign.end,
                    textStyle: bodyTextStyle(),
                  ),
                ),
                setWidth(8.0),
                setIcon(
                  iconType: iconType,
                  iconName: leadingIcon,
                  isPngColor: isPngColor,
                  color: AppColors.backgroundColorInverseSkin(isDark),
                ),
                // appSvgIcon(icon: leadingIcon, width: 24.0, color: AppColors.blackInLightWhiteInDarkSkin(isDark)),
              ],
            ),
    ),
  );
}

Widget listItemSwitchButton({
  iconType,
  leadingIcon,
  itemTitle,
  switchValue,
  onItemClick,
}) {
  return GestureDetector(
    onTap: onItemClick,
    child: Container(
      width: size.width,
      height: LIST_ITEM_HEIGHT,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(color: AppColors.cardColorSkin(isDark)),
      child: appLanguage == URDU_LANGUAGE
          ? Row(
              children: [
                SizedBox(
                  width: 40.0,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Switch(
                      activeColor: AppColors.backgroundColorInverseSkin(isDark),
                      activeTrackColor: AppColors.backgroundColorInverseSkin(
                        isDark,
                      ),
                      inactiveThumbColor: AppColors.backgroundColorSkin(isDark),
                      inactiveTrackColor: AppColors.backgroundColorSkin(isDark),
                      trackOutlineColor: const WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                      value: switchValue,
                      onChanged: null,
                    ),
                  ),
                ),
                setWidth(8.0),
                Expanded(
                  child: appText(
                    text: itemTitle,
                    textAlign: TextAlign.end,
                    textStyle: itemTextStyle(),
                  ),
                ),
                setWidth(8.0),
                setIcon(
                  iconType: iconType,
                  iconName: leadingIcon,
                  color: AppColors.backgroundColorInverseSkin(isDark),
                ),
                // appSvgIcon(icon: leadingIcon, width: 24.0, color: AppColors.blackInLightWhiteInDarkSkin(isDark)),
              ],
            )
          : Row(
              children: [
                // appSvgIcon(icon: leadingIcon, width: 24.0, color: AppColors.blackInLightWhiteInDarkSkin(isDark)),
                setIcon(
                  iconType: iconType,
                  iconName: leadingIcon,
                  color: AppColors.backgroundColorInverseSkin(isDark),
                ),
                setWidth(8.0),
                Expanded(
                  child: appText(
                    text: itemTitle,
                    textAlign: TextAlign.start,
                    textStyle: itemTextStyle(),
                  ),
                ),
                setWidth(8.0),
                SizedBox(
                  width: 40.0,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Switch(
                      activeColor: AppColors.materialButtonSkin(isDark),
                      activeTrackColor: AppColors.materialButtonSkin(isDark),
                      inactiveThumbColor: AppColors.backgroundColorSkin(isDark),
                      inactiveTrackColor: AppColors.secondaryTextColorSkin(isDark),
                      trackOutlineColor: const WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                      value: switchValue,
                      onChanged: null,
                    ),
                  ),
                ),
              ],
            ),
    ),
  );
}

Widget listItemInfo({
  trailingText,
  isPngColor = false,
  itemTitle,
  trailingIcon,
  isTrailingIcon = true,
  onItemClick,
}) {
  return GestureDetector(
    onTap: onItemClick,
    child: Container(
      width: size.width,
      height: LIST_ITEM_HEIGHT,
      padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
      decoration: BoxDecoration(color: AppColors.cardColorSkin(isDark)),
      child: appLanguage == ENGLISH_LANGUAGE
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: appText(
                    text: itemTitle,
                    textAlign: TextAlign.start,
                    textStyle: bodyTextStyle(),
                  ),
                ),
                setWidth(8.0),
                appText(text: trailingText, textStyle: secondaryTextStyle()),
                //  setWidth(4.0),
                isTrailingIcon
                ? appSvgIcon(
                  icon: trailingIcon,
                  width: 16.0,
                  color: AppColors.secondaryTextColorSkin(isDark),
                ) :  SizedBox(),
              ],
            )
          : Row(
              children: [
                isTrailingIcon
                    ? appSvgIcon(
                  icon: trailingIcon,
                  width: 16.0,
                  color: AppColors.secondaryTextColorSkin(isDark),
                ) :  SizedBox(),
                appText(text: trailingText, textStyle: secondaryTextStyle()),
                setWidth(8.0),
                Expanded(
                  child: appText(
                    text: itemTitle,
                    textAlign: TextAlign.end,
                    textStyle: bodyTextStyle(),
                  ),
                ),
              ],
            ),
    ),
  );
}
