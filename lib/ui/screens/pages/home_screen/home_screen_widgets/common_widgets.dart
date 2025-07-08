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
        child: appLanguage == URDU_LANGUAGE
            ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onTapSeeAllText,
              child: appText(
                text: AppLanguage.seeAllStr(appLanguage),
                textStyle: secondaryTextStyle(),
              ),
            ),
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

class CategoryItem extends StatelessWidget {
  final dynamic data;

  const CategoryItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final itemWidth = constraints.maxWidth;
      final imageSize = itemWidth; // square container
     final nameHeight = 24.0;     // enough for 2 lines
     final padding = 4.0 * 2;     // vertical spacing

  //   final totalHeight = imageSize + nameHeight +padding;

      return SizedBox(
       // height: totalHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 Image Container
            Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                color: AppColors.cardColorSkin(isDark),
                borderRadius: BorderRadius.circular(12.0),

              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: appAsyncImage(
                  data.categoryImage,
                  boxFit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 8.0),

            // 🔹 Text
            SizedBox(
             // height: nameHeight,
              child: Center(
                child: appText(
                  text: appLanguage == URDU_LANGUAGE
                      ? data.categoryNameUrdu
                      : data.categoryNameEnglish,
                  maxLines: 1,
                  overFlow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  textStyle: bodyTextStyle().copyWith(
                    fontSize: appLanguage == URDU_LANGUAGE
                        ? TAGS_FONT_SIZE + 2
                        : TAGS_FONT_SIZE,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class SubCategoryItem extends StatelessWidget {
  final dynamic data;

  const SubCategoryItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final itemWidth = constraints.maxWidth;
      final imageSize = itemWidth; // square container
      //  final nameHeight = 34.0;     // enough for 2 lines
      //  final padding = 16.0 * 2;     // vertical spacing

      // final totalHeight = imageSize + padding;

      return SizedBox(
        //height: totalHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 Image Container
            Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                color: AppColors.cardColorSkin(isDark),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: appAsyncImage(
                  data.subCategoryImage,
                  boxFit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 8.0),

            // 🔹 Text
            Flexible(
              child: Center(
                child: appText(
                  text: appLanguage == URDU_LANGUAGE
                      ? data.subCategoryNameUrdu
                      : data.subCategoryNameEnglish,
                  maxLines: 1,
                  overFlow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  textStyle: bodyTextStyle().copyWith(
                    fontSize: appLanguage == URDU_LANGUAGE
                        ? SUB_HEADING_TEXT_BUTTON_FONT_SIZE + 2
                        : SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}