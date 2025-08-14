import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class SocialMediaSection extends StatelessWidget {
  const SocialMediaSection({super.key});

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
        ///INSTAGRAM
        _instagram(icArrow, nav),
        ///FACEBOOK
        _facebook(icArrow, nav),

      ],
    );
  }
  Widget _heading(){
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: MAIN_HORIZONTAL_PADDING,
      ),
      child: appText(
        text: AppLanguage.followUsStr(appLanguage).toString(),
        textStyle: secondaryTextStyle(),
      ),
    );
  }
  Widget _instagram(icArrow, nav){
    return Padding(
      padding: const EdgeInsets.only(
        top: MAIN_HORIZONTAL_PADDING,
      ),
      child: listItemIcon(
        iconType: IconType.SVG,
        leadingIcon: icInstagram,
        itemTitle: AppLanguage.instagramStr(appLanguage).toString(),
        trailingIcon: icArrow,
        onItemClick: ()=> nav.launchInstagram(url: EnvStrings.followUsInstagram),
      ),
    );
  }
  Widget _facebook(icArrow, nav){
    return Padding(
      padding: const EdgeInsets.only(
        top: MAIN_HORIZONTAL_PADDING,
      ),
      child: listItemIcon(
        iconType: IconType.SVG,
        leadingIcon: icFacebook,
        itemTitle: AppLanguage.facebookStr(appLanguage).toString(),
        trailingIcon: icArrow,
        onItemClick: () async => await nav.launchFacebook(pageUserName: EnvStrings.followUsFacebook),
      ),
    );
  }

}
