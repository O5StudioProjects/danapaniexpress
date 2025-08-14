import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class MyProfileSection extends StatelessWidget {
  const MyProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = Get.find<AuthController>();
    var nav = Get.find<NavigationController>();
    return Obx((){
      var icArrow = isRightLang ? icArrowLeftSmall : icArrowRightSmall;
      return _buildUI(icArrow, auth, nav);
    });
  }

  Widget _buildUI(icArrow, auth, nav){
    if(auth.currentUser.value != null){
      return Column(
        crossAxisAlignment: isRightLang
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          _heading(),
          ///ACCOUNT INFORMATION - (VERTICAL PADDING)
          _accountInformation(icArrow, nav),
          ///ADDRESS BOOK
          _addressBook(icArrow, nav),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _heading(){
    return  Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: MAIN_HORIZONTAL_PADDING,
      ),
      child: appText(
        text: AppLanguage.myProfileStr(appLanguage),
        textStyle: secondaryTextStyle(),
      ),
    );
  }

  Widget _accountInformation(icArrow, nav){
    return Padding(
      padding: const EdgeInsets.only(
        top: MAIN_HORIZONTAL_PADDING,
      ),
      child: listItemIcon(
        iconType: IconType.ICON,
        leadingIcon: Icons.account_circle_rounded,
        itemTitle: AppLanguage.accountInformationStr(appLanguage).toString(),
        trailingIcon: icArrow,
        onItemClick: ()=> nav.gotoAccountInformationScreen(),
      ),
    );
  }

  Widget _addressBook(icArrow, nav){
    return Padding(
      padding: const EdgeInsets.only(
          top: MAIN_HORIZONTAL_PADDING,
          bottom: MAIN_VERTICAL_PADDING
      ),
      child: listItemIcon(
        iconType: IconType.ICON,
        leadingIcon: Icons.location_on_rounded,
        itemTitle: AppLanguage.addressBookStr(appLanguage).toString(),
        trailingIcon: icArrow,
        onItemClick: ()=> nav.gotoAddressBookScreen(),
      ),
    );
  }

}
