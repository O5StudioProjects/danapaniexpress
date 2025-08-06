import 'package:danapaniexpress/core/common_imports.dart';

import '../../../../../../../data/models/order_model.dart';
import '../../../../../../../domain/controllers/dashboard_controller/dashboard_controller.dart';
import '../../../../../../../domain/controllers/navigation_controller/navigation_controller.dart';

class OrderFeedbackCompleteMobile extends StatelessWidget {
  const OrderFeedbackCompleteMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var orderData = Get.arguments[DATA_ORDER] as OrderModel?;
    var nav = Get.find<NavigationController>();
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  appIcon(
                    iconType: IconType.ICON,
                    icon: Icons.feedback_rounded,
                    width: 100.0,
                    color: AppColors.materialButtonSkin(isDark)
                  ),
                  setHeight(LIST_ITEM_HEIGHT),
                  appText(
                    text: 'Thank you for the feedback for',
                    textStyle: headingTextStyle().copyWith(
                      color: AppColors.materialButtonSkin(isDark),
                      fontSize: SECONDARY_HEADING_FONT_SIZE,
                    ),
                  ),
                  appText(
                    text: '${AppLanguage.orderNumberStr(appLanguage)} ${orderData?.orderNumber?.split('_').last ?? ''}',
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
                      'Thank you for sharing your valuable feedback. We truly appreciate it and will work on improving our services to serve you better.\n\n',
                      style: secondaryTextStyle(),
                      children: [
                        TextSpan(
                          text: AppLanguage.thankYouTrustStr(appLanguage),
                          style: secondaryTextStyle(),
                        ),
                        TextSpan(
                          text: '${AppLanguage.appNameStr(appLanguage)}\n\n',
                          style: buttonTextStyle().copyWith(
                            fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
                            color: AppColors.materialButtonSkin(isDark),
                          ),
                        ),

                        TextSpan(
                          text: AppLanguage.checkOrderHistoryStr(appLanguage),
                          style: secondaryTextStyle(),
                        ),
                        WidgetSpan(
                            child: GestureDetector(
                              onTap: ()=> nav.gotoOrdersScreen(screenIndex: 0),
                              child: appText(text: AppLanguage.orderHistoryStr(appLanguage), textStyle: buttonTextStyle().copyWith(
                                fontSize: NORMAL_TEXT_FONT_SIZE,
                                color: AppColors.materialButtonSkin(isDark),
                              )),
                            )
                        ),
                      ],
                    ),
                  ),
                  setHeight(30.0),
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
            child: appMaterialButton(text: 'Go back', onTap: () {
              Get.find<DashBoardController>().navIndex.value = 0;
              Get.back();
            }),
          ),
        ],
      ),
    );
  }
}
