import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class AccountScreenMobile extends StatelessWidget {
  const AccountScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var account = Get.find<AccountController>();
    return Obx(
      ()=> Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(

            children: [
              AccountHeader(),
              setHeight(MAIN_VERTICAL_PADDING),
              HomeHeadings(mainHeadingText: 'My Orders', isSeeAll: true, isTrailingText: true, trailingText: 'View All Orders', onTapSeeAllText: (){}),
              setHeight(MAIN_VERTICAL_PADDING),
              MyOrders(),

              /// MY PROFILE SECTION
              HomeHeadings(mainHeadingText: 'My Profile', isSeeAll: false),

              ///ACCOUNT INFORMATION - (VERTICAL PADDING)
              Padding(
                padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING),
                child: listItemIcon(iconType: IconType.ICON, leadingIcon: Icons.account_circle_rounded, itemTitle: 'Account Information', trailingIcon: icArrowRight, onItemClick: (){}),
              ),

              ///ADDRESS BOOK
              Padding(
                padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
                child: listItemIcon(iconType: IconType.ICON, leadingIcon: Icons.location_on_rounded,  itemTitle: 'Address Book', trailingIcon: icArrowRight, onItemClick: (){}),
              ),


              setHeight(MAIN_VERTICAL_PADDING),

              /// LEGAL SECTION
              HomeHeadings(mainHeadingText: 'Legal', isSeeAll: false),

              ///PRIVACY POLICY
              Padding(
                padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
                child: listItemIcon(iconType: IconType.ICON, leadingIcon: Icons.privacy_tip_rounded, itemTitle: 'Privacy Policy', trailingIcon: icArrowRight, onItemClick: (){}),
              ),

              ///TERMS & CONDITIONS
              Padding(
                padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
                child: listItemIcon(iconType: IconType.ICON, leadingIcon: Icons.receipt_long_rounded,  itemTitle: 'Terms & Conditions', trailingIcon: icArrowRight, onItemClick: (){}),
              ),

              ///RETURNS & REFUNDS
              Padding(
                padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
                child: listItemIcon(iconType: IconType.ICON, leadingIcon: Icons.keyboard_return_rounded,  itemTitle: 'Returns & Refunds', trailingIcon: icArrowRight, onItemClick: (){}),
              ),


              setHeight(MAIN_VERTICAL_PADDING),

              /// SUPPORT SECTION
              HomeHeadings(mainHeadingText: 'Support', isSeeAll: false),

              ///Customer Support Service
              Padding(
                padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
                child: listItemIcon(iconType: IconType.PNG, leadingIcon: icAdmins, itemTitle: 'Customer Service', trailingIcon: icArrowRight, onItemClick: (){}),
              ),

              /// CONTACT US ON WHATSAPP
              Padding(
                padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
                child: listItemIcon(iconType: IconType.SVG, leadingIcon: icWhatsapp, itemTitle: 'Our Whatsapp', trailingIcon: icArrowRight, onItemClick: (){}),
              ),

              setHeight(MAIN_VERTICAL_PADDING),

              /// SOCIAL MEDIA SECTION
              HomeHeadings(mainHeadingText: 'Follow Us', isSeeAll: false),

              /// INSTAGRAM
              Padding(
                padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
                child: listItemIcon(iconType: IconType.SVG, leadingIcon: icInstagram, itemTitle: 'Instagram', trailingIcon: icArrowRight, onItemClick: (){}),
              ),
              /// FACEBOOK
              Padding(
                padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
                child: listItemIcon(iconType: IconType.SVG, leadingIcon: icFacebook, itemTitle: 'Facebook', trailingIcon: icArrowRight, onItemClick: (){}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
