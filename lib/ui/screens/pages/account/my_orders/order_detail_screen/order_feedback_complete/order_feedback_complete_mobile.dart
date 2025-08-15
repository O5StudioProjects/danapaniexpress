import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class OrderFeedbackCompleteMobile extends StatelessWidget {
  const OrderFeedbackCompleteMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var orderData = Get.arguments[DATA_ORDER] as OrderModel?;
    var nav = Get.find<NavigationController>();
    return _buildUI(orderData,nav);
  }

  _buildUI(orderData,nav){
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          _mainSection(orderData, nav),
          setHeight(MAIN_VERTICAL_PADDING),
          _buttonSection(),
        ],
      ),
    );
  }

  _mainSection(orderData, nav){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            _iconSection(),
            _descriptionSection(orderData),
            _thankYouAndOrderHistory(nav),
            _divider(),
            _customerService(nav),
          ],
        ),
      ),
    );
  }

  _iconSection(){
    return Padding(
      padding: const EdgeInsets.only(bottom: LIST_ITEM_HEIGHT),
      child: appIcon(
          iconType: IconType.ICON,
          icon: Icons.feedback_rounded,
          width: 100.0,
          color: AppColors.materialButtonSkin(isDark)
      ),
    );
  }

  _descriptionSection(orderData){
    return
      isRightLang
          ? Column(
        children: [
          appText(
              text: '${AppLanguage.orderNumberStr(appLanguage)} ${orderData?.orderNumber?.split('_').last ?? ''}',
              textStyle: headingTextStyle().copyWith(
                color: AppColors.materialButtonSkin(isDark),
                fontSize: HEADING_FONT_SIZE,
              ),
              textDirection: setTextDirection(appLanguage),
              textAlign: setTextAlignment(appLanguage)
          ),
          appText(
            text: AppLanguage.thankYouForTheFeedbackForStr(appLanguage),
            textStyle: headingTextStyle().copyWith(
              color: AppColors.materialButtonSkin(isDark),
              fontSize: SECONDARY_HEADING_FONT_SIZE,
            ),
          ),
        ],
      )
          : Column(
        children: [
          appText(
            text: AppLanguage.thankYouForTheFeedbackForStr(appLanguage),
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
        ],
      );
  }

  _thankYouAndOrderHistory(nav){
    return Padding(
      padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING, bottom: 30.0),
      child: Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          text:
          AppLanguage.thankYouForSharingYourValuableFeedbackStr(appLanguage),
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
                alignment: PlaceholderAlignment.middle,
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
    );
  }

  _divider(){
    return Padding(
      padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING, bottom: MAIN_VERTICAL_PADDING),
      child: appDivider(),
    );
  }

  _customerService(nav){
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text: AppLanguage.customerSupportMessageStr(appLanguage),
        style: secondaryTextStyle(),
        children: [
          WidgetSpan(
              child: GestureDetector(
                onTap: ()=> nav.gotoCustomerServiceScreen(),
                child: appText(text: AppLanguage.customerServiceStr(appLanguage),
                  textStyle: buttonTextStyle().copyWith(
                    fontSize: NORMAL_TEXT_FONT_SIZE,
                    color: AppColors.materialButtonSkin(isDark),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }

  _buttonSection(){
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: MAIN_HORIZONTAL_PADDING,
        vertical: MAIN_VERTICAL_PADDING,
      ),
      child: appMaterialButton(text: AppLanguage.goBackStr(appLanguage), onTap: () {
        Get.find<DashBoardController>().navIndex.value = 0;
        Get.back();
      }),
    );
  }



}
