import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/ui/screens/pages/cart/widgets/top_checkout_status.dart';

class OrderPlacedScreenMobile extends StatelessWidget {
  const OrderPlacedScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var orderData = Get.arguments[DATA_ORDER] as OrderModel?;
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          SizedBox(
            height: 130.0,
            child: TopCheckoutStatus(
              isShipping: true,
              isPayment: true,
              isReview: true,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  appIcon(
                    iconType: IconType.PNG,
                    icon: isDark ? icOrderPlacedDark : icOrderPlacedLight,
                    width: 150.0,
                  ),
                  setHeight(LIST_ITEM_HEIGHT),
                  appText(
                    text: AppLanguage.orderPlacedSuccessfullyStr(appLanguage),
                    textStyle: headingTextStyle().copyWith(
                      color: AppColors.materialButtonSkin(isDark),
                      fontSize: SECONDARY_HEADING_FONT_SIZE,
                    ),
                  ),
                  appText(
                    text: '${AppLanguage.orderNumberStr(appLanguage)} ${orderData?.orderNumber}',
                    textStyle: headingTextStyle().copyWith(
                      color: AppColors.materialButtonSkin(isDark),
                      fontSize: HEADING_FONT_SIZE,
                    ),
                    textDirection: setTextDirection(appLanguage),
                    textAlign: setTextAlignment(appLanguage)
                  ),
                  setHeight(MAIN_VERTICAL_PADDING),
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text:
                          AppLanguage.orderPlacedDescriptionStr(appLanguage),
                      style: secondaryTextStyle(),
                      children: [
                        TextSpan(
                          text: AppLanguage.thankYouTrustStr(appLanguage),
                          style: secondaryTextStyle(),
                        ),
                        TextSpan(
                          text: AppLanguage.companyNameStr(appLanguage),
                          style: buttonTextStyle().copyWith(
                            fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
                            color: AppColors.materialButtonSkin(isDark),
                          ),
                        ),
                        TextSpan(
                          text: AppLanguage.checkOrderHistoryStr(appLanguage),
                          style: secondaryTextStyle(),
                        ),
                        TextSpan(
                          text: AppLanguage.orderHistoryStr(appLanguage),
                          style: buttonTextStyle().copyWith(
                            fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
                            color: AppColors.materialButtonSkin(isDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  setHeight(MAIN_VERTICAL_PADDING),
                  appDivider(),
                  setHeight(MAIN_VERTICAL_PADDING),
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: AppLanguage.customerSupportMessageStr(appLanguage),
                      style: secondaryTextStyle(),
                      children: [
                        TextSpan(
                          text: AppLanguage.customerServiceStr(appLanguage),
                          style: buttonTextStyle().copyWith(
                            fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
                            color: AppColors.materialButtonSkin(isDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          setHeight(MAIN_VERTICAL_PADDING),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: MAIN_HORIZONTAL_PADDING,
              vertical: MAIN_VERTICAL_PADDING,
            ),
            child: appMaterialButton(text: AppLanguage.continueShoppingStr(appLanguage), onTap: () {
              Get.find<DashBoardController>().navIndex.value = 0;
              Get.back();
            }),
          ),
        ],
      ),
    );
  }
}
