import 'package:danapaniexpress/core/packages_import.dart';
import 'package:danapaniexpress/core/common_imports.dart';

Widget appAssetImage({image, width, height, fit, opacity = 1.0}) {
  return Image.asset(
    image,
    width: width,
    height: height,
    fit: fit,
    opacity: AlwaysStoppedAnimation(opacity),
  );
}

Widget appText({
  String? text,
  textStyle,
  textAlign,
  maxLines,
  textDirection,
  overFlow = TextOverflow.ellipsis,
}) {
  return Text(
    text!,
    style: textStyle,
    textDirection: textDirection,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overFlow,
  );
}

Widget appSelectableText({
  String? text,
  textStyle,
  textAlign,
  maxLines,
  textDirection,
}) {
  return SelectableText(
    text!,
    style: textStyle,
    textDirection: textDirection,
    textAlign: textAlign,
    maxLines: maxLines,
  );
}

Widget loadingIndicator() {
  return Center(
    child: SizedBox(
      width: 30.0,
      height: 30.0,
      child: Lottie.asset(AppAnims.animLoading2Skin(isDark).toString(), repeat: true),
    ),
  );
}

Widget appAsyncImage(imageUrl, {boxFit = BoxFit.cover, width, showLoading = true}) {
  return CachedNetworkImage(
    progressIndicatorBuilder: (context, url, downloadProgress) => showLoading ? loadingIndicator() : const SizedBox(),
    errorWidget: (context, url, error) => appIcon(iconType: IconType.PNG, icon: icEmptyImagePlaceholder, color: AppColors.primaryTextColorSkin(isDark)),
    fit: boxFit,
    width: width,
    imageUrl: imageUrl,
    // imageUrl: '$coreUrl${data[index]['qr_image']}',
  );
}

Widget setHeight(height) {
  return SizedBox(height: height);
}

Widget setWidth(width) {
  return SizedBox(width: width);
}

Widget appSvgIcon({icon, width, color}) {
  return SvgPicture.asset(
    icon,
    width: width,
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
  );
}

Widget appIcon(
    {icon, required IconType iconType, width, height, color, selectedColor, iconSelected = false}) {
  return iconType == IconType.SVG
      ? SvgPicture.asset(icon,
      width: width,
      colorFilter: ColorFilter.mode(
          iconSelected ? selectedColor : color, BlendMode.srcIn))
      : iconType == IconType.ICON
      ? Icon(
    icon,
    size: width,
    color: iconSelected ? selectedColor : color,
  )
      : iconType == IconType.URL
      ? ClipRRect(
    borderRadius: BorderRadius.circular(12.0),
    child: SizedBox(
        width: 70.0,
        height: 70.0,
        child: appAsyncImage(icon)),
  )
      : iconType == IconType.ANIM
      ? Lottie.asset(icon, repeat: true, width: width)
      : Image.asset(
    icon,
    width: width,
    height: height,
    color: iconSelected ? selectedColor : color,
  );
}

Widget appMaterialButton({
  text,
  onTap,
  isCustomColor = false,
  textColor,
  buttonColor,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      height: BUTTON_HEIGHT,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: isCustomColor
            ? buttonColor
            : AppColors.materialButtonSkin(isDark),
      ),
      child: Center(
        child: appText(
          text: text,
          textDirection: setTextDirection(appLanguage),
          textStyle: buttonTextStyle(
            color: isCustomColor
                ? textColor
                : AppColors.materialButtonTextSkin(isDark),
          ),
        ),
      ),
    ),
  );
}

Widget appLogoTextButton({
  iconType,
  icon,
  text,
  onTap,
  isCustomColor = false,
  textColor,
  buttonColor,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      height: BUTTON_HEIGHT,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: isCustomColor
            ? buttonColor
            : AppColors.cardColorSkin(isDark),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            appIcon(iconType: iconType, icon: icon, width: 25.0),
            setWidth(10.0),
            appText(
              text: text,
              textDirection: setTextDirection(appLanguage),
              textStyle: buttonTextStyle(
                color: isCustomColor
                    ? textColor
                    : AppColors.secondaryTextColorSkin(isDark),
              ),
            ),
          ],
        )
      ),
    ),
  );
}

Widget appTextButton({text, onTap, useDefault = true, customTextColor}) {
  return TextButton(
    onPressed: onTap,
    child: appText(
      text: text,
      textStyle: appTextButtonStyle(
        color: useDefault
            ? AppColors.secondaryTextColorSkin(isDark)
            : customTextColor,
      ),
    ),
  );
}

Widget appDivider(){
  return Divider(
    color: AppColors.dividerColorSkin(isDark),
  );
}

Widget appDetailTextButton({detailText, buttonText, onTapButton}){
  return Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: detailText,
          style: secondaryTextStyle(),
        ),
        TextSpan(
            text: buttonText,
            style: appTextButtonStyle(
              color: AppColors.materialButtonSkin(isDark),
            ),
            recognizer: TapGestureRecognizer() ..onTap = onTapButton
        ),
      ],
    ),
  );
}

Widget appFloatingButton({
  icon, iconType = IconType.SVG, iconWidth = 20.0, circlePadding = 6.0,  onTap
}){
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(circlePadding),
      decoration: BoxDecoration(
          color: AppColors.floatingButtonSkin(isDark),
          borderRadius: BorderRadius.circular(100.0)
      ),
      child: appIcon(iconType: iconType, icon: icon, color: EnvColors.backgroundColorLight, width: iconWidth),
    ),
  );
}

Widget appBackNavigationButton(){
  return appFloatingButton(icon: icArrowLeft, onTap: (){
    Get.back();
  });
}

Widget appSearchButton({iconColor = whiteColor}){
  return GestureDetector(
    onTap: (){},
    child: appSvgIcon(
      icon: icSearch,
      width: 24.0,
      color: iconColor
    ),
  );
}

Widget counterButton({icon, iconType, onTap}){
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
          color: AppColors.materialButtonSkin(isDark),
          borderRadius: BorderRadius.circular(12.0)
      ),
      padding: EdgeInsets.all(10.0),
      child: appIcon(iconType: iconType, icon: icon, width: 12.0, color: AppColors.materialButtonTextSkin(isDark)),
    ),
  );
}