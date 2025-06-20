
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

Widget appText({String? text, textStyle, textAlign, maxLines, textDirection, overFlow = TextOverflow.ellipsis}) {
  return Text(
    text!,
    style: textStyle,
    textDirection: textDirection,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overFlow,
  );
}

Widget appSelectableText(
    {String? text, textStyle, textAlign, maxLines, textDirection}) {
  return SelectableText(text!,
      style: textStyle,
      textDirection: textDirection,
      textAlign: textAlign,
      maxLines: maxLines);
}

// Widget appAsyncImage(imageUrl, {boxFit = BoxFit.cover, showLoading = true}) {
//   return CachedNetworkImage(
//     progressIndicatorBuilder: (context, url, downloadProgress) => showLoading ? loadingIndicator() : const SizedBox(),
//     errorWidget: (context, url, error) => appIcon(iconType: IconType.PNG, icon: icEmptyImagePlaceholder, color: AppColors.iconSecondaryColorSkin(isDark)),
//     fit: boxFit,
//     imageUrl: imageUrl,
//     // imageUrl: '$coreUrl${data[index]['qr_image']}',
//   );
// }

Widget setHeight(height) {
  return SizedBox(
    height: height,
  );
}

Widget setWidth(width) {
  return SizedBox(
    width: width,
  );
}

Widget appSvgIcon({icon, width,  color}) {
  return SvgPicture.asset(
    icon,
    width: width,
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
  );
}

Widget appMaterialButton({text, onTap, isCustomColor = false, textColor, buttonColor}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      height: BUTTON_HEIGHT,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: isCustomColor ? buttonColor : AppColors.materialButtonSkin(isDark)),
      child: Center(
        child: appText(
            text: text,
            textStyle: buttonTextStyle(color: isCustomColor ? textColor : AppColors.materialButtonTextSkin(isDark))),
      ),
    ),
  );
}
