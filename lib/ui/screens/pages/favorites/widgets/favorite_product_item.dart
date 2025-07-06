import 'package:danapaniexpress/core/common_imports.dart';

class FavoriteProductItem extends StatelessWidget {
  const FavoriteProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final imageSize = constraints.maxWidth * 0.2;

          return Container(
          //  height: imageSize * 1.4, // fixes container height based on image size + padding
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: AppColors.cardColorSkin(isDark),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(30),
                  blurRadius: 1,
                  spreadRadius: 0,
                  offset: const Offset(1, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: SizedBox(
                        width: imageSize,
                        height: imageSize,
                        child: appAssetImage(
                          image: imgProductBackground,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: MAIN_HORIZONTAL_PADDING),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          appText(
                            text: 'Product Name ',
                            textStyle: itemTextStyle().copyWith(fontSize: HEADING_FONT_SIZE),
                            textDirection: setTextDirection(appLanguage),
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              appText(
                                text: '10000 gm',
                                textStyle: textFormHintTextStyle().copyWith(fontSize: NORMAL_TEXT_FONT_SIZE -2),
                                maxLines: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: appText(
                                  text: 'L',
                                  textStyle: itemTextStyle(),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              appText(
                                text: 'Rs. 300',
                                textStyle: sellingPriceTextStyle(),
                                maxLines: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: appText(
                                  text: 'Rs. 400',
                                  maxLines: 1,
                                  textStyle: cutPriceTextStyle(isDetail: false),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                   const SizedBox(width: MAIN_HORIZONTAL_PADDING),
                    appIcon(
                      iconType: IconType.PNG,
                      icon: icHeartFill,
                      width: 24.0,
                      color: AppColors.materialButtonSkin(isDark),
                    ),
                  ],
                ),
                setHeight(MAIN_VERTICAL_PADDING),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 35.0,
                      child: appMaterialButton(
                        text: AppLanguage.addToCartStr(appLanguage),
                        fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE
                      ),
                    ),

                    // appFloatingButton(
                    //   icon: icCart,
                    //   iconType: IconType.PNG,
                    //   iconWidth: 14.0,
                    //   circlePadding: 8.0,
                    //   onTap: () {},
                    // ),


                    //  const SizedBox(height: 12),

                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
