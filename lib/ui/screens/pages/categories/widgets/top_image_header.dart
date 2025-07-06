import 'package:danapaniexpress/core/common_imports.dart';

class TopImageHeader extends StatelessWidget {
  final String title;
  final String? coverImage;

  const TopImageHeader({super.key, required this.title, this.coverImage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.25,
      width: size.width,
      child: Stack(
        children: [
          /// IMAGE SECTION
          SizedBox(
            height: size.height * 0.25,
            width: size.width,
            child: (coverImage != null && coverImage!.isNotEmpty)
                ? appAsyncImage(coverImage!, boxFit: BoxFit.cover)
                : appAssetImage(image: imgDPEBanner, fit: BoxFit.cover),
          ),

          /// IMAGE SECTION BLACK OVERLAY
          Container(color: Colors.black.withValues(alpha: 0.6)),

          /// BACK NAVIGATION BUTTON
          Positioned(
            top: MAIN_VERTICAL_PADDING * 2,
            left: MAIN_HORIZONTAL_PADDING,
            child: appBackNavigationButton(),
          ),

          /// Screen name And Search\
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: size.width,
              child: Padding(
                padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: appText(
                        text: title,
                        maxLines: 1,
                        textStyle: bigBoldHeadingTextStyle().copyWith(
                          color: Colors.white,
                          fontSize: SECONDARY_HEADING_FONT_SIZE
                        ),
                      ),
                    ),
                    setWidth(MAIN_HORIZONTAL_PADDING),
                    appSearchButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
