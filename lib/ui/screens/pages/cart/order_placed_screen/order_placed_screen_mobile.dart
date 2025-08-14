import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class OrderPlacedScreenMobile extends StatelessWidget {
  const OrderPlacedScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var nav = Get.find<NavigationController>();
   return Obx((){
     return buildUI(nav);
   });
  }

  Widget buildUI(nav){
    return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            _checkoutStatus(),
            _orderPlacedMainSection(nav),
            _continueShoppingButton(),
          ],
        )
    );
  }

  Widget _checkoutStatus(){
    return SizedBox(
      height: 130.0,
      child: TopCheckoutStatus(
        isShipping: true,
        isPayment: true,
        isReview: true,
      ),
    );
  }

  Widget _orderPlacedMainSection(nav){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _iconSection(),
                _orderPlacedText(),
                _descriptionText(nav),
                Spacer(),
                _divider(),
                _customerServiceText(nav),
              ],
            ),
            _confettiAnimation(),

          ],
        ),
      ),
    );
  }

  Widget _iconSection(){
    return appIcon(
      iconType: IconType.PNG,
      icon: isDark ? icOrderPlacedDark : icOrderPlacedLight,
      width: 150.0,
    );
  }

  Widget _orderPlacedText(){
    return Padding(
      padding: const EdgeInsets.only(top: LIST_ITEM_HEIGHT),
      child: appText(
        text: AppLanguage.orderPlacedSuccessfullyStr(appLanguage),
        textStyle: headingTextStyle().copyWith(
          color: AppColors.materialButtonSkin(isDark),
          fontSize: SECONDARY_HEADING_FONT_SIZE,
        ),
      ),
    );
  }

  Widget _descriptionText(nav){
    return Padding(
      padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING),
      child: Text.rich(
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

  Widget _divider(){
    return Padding(
      padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING, bottom: MAIN_VERTICAL_PADDING),
      child: appDivider(),
    );
  }

  Widget _customerServiceText(nav){
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

  Widget _confettiAnimation(){
    return Positioned(
        top: 0,
        right: 2,
        child: SizedBox(
            width: size.width,
            child: Center(child: appIcon(iconType: IconType.ANIM, icon: animConfetti, width: 120.0))));
  }


  Widget _continueShoppingButton(){
    return Padding(
      padding: const EdgeInsets.only(
        left: MAIN_HORIZONTAL_PADDING,
        right: MAIN_HORIZONTAL_PADDING,
        bottom: MAIN_VERTICAL_PADDING,
        top: MAIN_VERTICAL_PADDING*2,
      ),
      child: appMaterialButton(text: AppLanguage.continueShoppingStr(appLanguage), onTap: () {
        Get.find<DashBoardController>().navIndex.value = 0;
        Get.back();
      }),
    );
  }

}
