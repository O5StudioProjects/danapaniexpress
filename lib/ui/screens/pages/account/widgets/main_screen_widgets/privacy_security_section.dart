import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class PrivacySecuritySection extends StatelessWidget {
  const PrivacySecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    var nav = Get.find<NavigationController>();
    return Obx((){
      var icArrow = isRightLang ? icArrowLeftSmall : icArrowRightSmall;
      return _buildUI(icArrow, nav);
    });
  }

  Widget _buildUI(icArrow, nav){
    return Column(
      crossAxisAlignment: isRightLang
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        _heading(),

        ///PRIVACY POLICY
        _privacyPolicy(icArrow, nav),

        ///TERMS & CONDITIONS
        _termsConditions(icArrow, nav),

        ///RETURNS & REFUNDS
        _returnsRefunds(icArrow, nav),

      ],
    );
  }

  Widget _heading(){
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: MAIN_HORIZONTAL_PADDING,
      ),
      child: appText(
        text: AppLanguage.privacySecurityStr(appLanguage).toString(),
        textStyle: secondaryTextStyle(),
      ),
    );
  }
  Widget _privacyPolicy(icArrow, nav){
    return Padding(
      padding: const EdgeInsets.only(
        top: MAIN_HORIZONTAL_PADDING,
      ),
      child: listItemIcon(
        iconType: IconType.ICON,
        leadingIcon: Icons.privacy_tip_rounded,
        itemTitle: AppLanguage.privacyPolicyStr(appLanguage).toString(),
        trailingIcon: icArrow,
        onItemClick: ()=> nav.gotoPrivacyPolicyScreen(),
      ),
    );
  }
  Widget _termsConditions(icArrow, nav){
    return Padding(
      padding: const EdgeInsets.only(
        top: MAIN_HORIZONTAL_PADDING,
      ),
      child: listItemIcon(
        iconType: IconType.ICON,
        leadingIcon: Icons.receipt_long_rounded,
        itemTitle: AppLanguage.termsConditionsStr(appLanguage).toString(),
        trailingIcon: icArrow,
        onItemClick: ()=> nav.gotoTermsConditionsScreen(isStart: false),
      ),
    );
  }
  Widget _returnsRefunds(icArrow, nav){
    return Padding(
      padding: const EdgeInsets.only(
          top: MAIN_HORIZONTAL_PADDING,
          bottom: MAIN_VERTICAL_PADDING
      ),
      child: listItemIcon(
        iconType: IconType.ICON,
        leadingIcon: Icons.keyboard_return_rounded,
        itemTitle: AppLanguage.returnsRefundsStr(appLanguage).toString(),
        trailingIcon: icArrow,
        onItemClick: ()=> nav.gotoReturnsRefundsScreen(),
      ),
    );
  }

}
