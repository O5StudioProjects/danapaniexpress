import 'package:danapaniexpress/core/common_imports.dart';

class CartProductItem extends StatelessWidget {
  const CartProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final imageSize = constraints.maxWidth * 0.2;

          return Container(
            width: size.width,
          //  height: imageSize * 3, // fixes container height based on image size + padding
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
                    setWidth(MAIN_HORIZONTAL_PADDING),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          appText(
                            text: 'Product Name Here',
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
                          const SizedBox(height: 6),
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
                   // setWidth(MAIN_HORIZONTAL_PADDING),


                  ],
                ),
              //  Spacer(),
                setHeight(MAIN_HORIZONTAL_PADDING),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    appIcon(
                        icon: icDeleteCart,
                        iconType: IconType.PNG,
                        width: 24.0,
                        color: EnvColors.specialFestiveColorDark
                    ),
                   Spacer(),
                    counterButton(icon: icMinus, iconType: IconType.PNG, onTap: (){}),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
                      child: appText(text: '1', textStyle: bodyTextStyle(). copyWith(fontSize: 24.0)),
                    ),
                    counterButton(icon: icPlus, iconType: IconType.PNG, onTap: (){}),

                  ],
                )

              ],
            ),
          );
        },
      ),
    );
  }
}
