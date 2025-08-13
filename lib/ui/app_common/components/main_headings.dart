import 'package:danapaniexpress/core/common_imports.dart';

class HomeHeadings extends StatelessWidget {
  final String mainHeadingText;
  final bool isLeadingIcon;
  final bool isSeeAll;
  final bool isTrailingText;
  final String? trailingText;
  final String? leadingIcon;
  final double? horizontalPadding;
  final GestureTapCallback? onTapSeeAllText;
  const HomeHeadings({super.key, required this.mainHeadingText,  this.onTapSeeAllText,  this.isLeadingIcon = false,  this.leadingIcon, this.isSeeAll = true, this.trailingText, this.isTrailingText =false, this.horizontalPadding = MAIN_HORIZONTAL_PADDING});

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Padding(
        padding:  EdgeInsets.only(right: horizontalPadding!, left: horizontalPadding!),
        child: isRightLang
            ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isSeeAll
                ? GestureDetector(
              onTap:  onTapSeeAllText,
              child: appText(
                text: isTrailingText ? trailingText : AppLanguage.seeAllStr(appLanguage),
                textStyle: secondaryTextStyle(),
              ),
            ) : SizedBox(),
            Spacer(),

            appText(
              text: mainHeadingText,
              textStyle: headingTextStyle(),
            ),
            isLeadingIcon ?
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: appIcon(iconType: IconType.PNG, icon: leadingIcon, width: 24.0, color: AppColors.percentageTextSkin(isDark)),
            ) : SizedBox(),

          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isLeadingIcon ?
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: appIcon(iconType: IconType.PNG, icon: leadingIcon, width: 24.0, color: AppColors.percentageTextSkin(isDark)),
            ) : SizedBox(),
            appText(
              text: mainHeadingText,
              textStyle: headingTextStyle(),
            ),
            Spacer(),
            isSeeAll
            ? GestureDetector(
              onTap: onTapSeeAllText,
              child: appText(
                text: isTrailingText ? trailingText : AppLanguage.seeAllStr(appLanguage) ,
                textStyle: secondaryTextStyle(),
              ),
            )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}



