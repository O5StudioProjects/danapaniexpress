import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});

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

        ///Customer Support Service
        _customerService(icArrow, nav),

        /// CONTACT US ON WHATSAPP
        _whatsapp(icArrow, nav),

        /// CONTACT US ON EMAIL
        _email(icArrow, nav),
      ],
    );
  }
  
  Widget _heading(){
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: MAIN_HORIZONTAL_PADDING,
      ),
      child: appText(
        text: AppLanguage.supportStr(appLanguage).toString(),
        textStyle: secondaryTextStyle(),
      ),
    );
  }
  Widget _customerService(icArrow, nav){
    return Padding(
      padding: const EdgeInsets.only(
        top: MAIN_HORIZONTAL_PADDING,
      ),
      child: listItemIcon(
        iconType: IconType.PNG,
        leadingIcon: icAdmins,
        itemTitle: AppLanguage.customerServiceStr(appLanguage).toString(),
        trailingIcon: icArrow,
        onItemClick: () async => await nav.gotoCustomerServiceScreen(),
      ),
    );
  }
  Widget _whatsapp(icArrow, nav){
    return Padding(
      padding: const EdgeInsets.only(
        top: MAIN_HORIZONTAL_PADDING,
      ),
      child: listItemIcon(
        iconType: IconType.SVG,
        leadingIcon: icWhatsapp,
        itemTitle: AppLanguage.whatsappStr(appLanguage).toString(),
        trailingIcon: icArrow,
        onItemClick: () async => await nav.launchWhatsApp(phone: EnvStrings.contactUsWhatsapp),
      ),
    );
  }
  Widget _email(icArrow, nav){
    return Padding(
      padding: const EdgeInsets.only(
          top: MAIN_HORIZONTAL_PADDING,
          bottom: MAIN_VERTICAL_PADDING
      ),
      child: listItemIcon(
        iconType: IconType.ICON,
        leadingIcon: Icons.email_rounded,
        itemTitle: AppLanguage.emailStr(appLanguage).toString(),
        trailingIcon: icArrow,
        onItemClick: () async => await nav.launchEmail(email: EnvStrings.contactUsEmail),
      ),
    );
  }
  
  
  
}
