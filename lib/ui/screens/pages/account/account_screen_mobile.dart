import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class AccountScreenMobile extends StatelessWidget {
  const AccountScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = Get.find<AuthController>();
    var navigate = Get.find<NavigationController>();
    return Obx(
      () => Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            AccountHeader(),

            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: appLanguage == URDU_LANGUAGE
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,

                  children: [
                    setHeight(MAIN_VERTICAL_PADDING),

                    if(auth.currentUser.value != null)
                    Column(

                      children: [
                        HomeHeadings(
                          mainHeadingText: 'My Orders',
                          isSeeAll: true,
                          isTrailingText: true,
                          trailingText: 'View All Orders',
                          onTapSeeAllText: () {},
                        ),
                        setHeight(MAIN_VERTICAL_PADDING),
                        MyOrders(),
                      ],
                    ),

                    /// MY PROFILE SECTION
                    if(auth.currentUser.value != null)
                      Column(
                        crossAxisAlignment: appLanguage == URDU_LANGUAGE
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: MAIN_HORIZONTAL_PADDING,
                            ),
                            child: appText(
                              text: 'My Profile',
                              textStyle: secondaryTextStyle(),
                            ),
                          ),

                          ///ACCOUNT INFORMATION - (VERTICAL PADDING)
                          Padding(
                            padding: const EdgeInsets.only(
                              top: MAIN_HORIZONTAL_PADDING,
                            ),
                            child: listItemIcon(
                              iconType: IconType.ICON,
                              leadingIcon: Icons.account_circle_rounded,
                              itemTitle: 'Account Information',
                              trailingIcon: icArrowRight,
                              onItemClick: ()=> navigate.gotoAccountInformationScreen(),
                            ),
                          ),

                          ///ADDRESS BOOK
                          Padding(
                            padding: const EdgeInsets.only(
                              top: MAIN_HORIZONTAL_PADDING,
                            ),
                            child: listItemIcon(
                              iconType: IconType.ICON,
                              leadingIcon: Icons.location_on_rounded,
                              itemTitle: 'Address Book',
                              trailingIcon: icArrowRight,
                              onItemClick: ()=> navigate.gotoAddressBookScreen(),
                            ),
                          ),

                          setHeight(MAIN_VERTICAL_PADDING),
                        ],
                      ),




                    /// LEGAL SECTION
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: MAIN_HORIZONTAL_PADDING,
                      ),
                      child: appText(
                        text: 'Legal',
                        textStyle: secondaryTextStyle(),
                      ),
                    ),

                    ///PRIVACY POLICY
                    Padding(
                      padding: const EdgeInsets.only(
                        top: MAIN_HORIZONTAL_PADDING,
                      ),
                      child: listItemIcon(
                        iconType: IconType.ICON,
                        leadingIcon: Icons.privacy_tip_rounded,
                        itemTitle: 'Privacy Policy',
                        trailingIcon: icArrowRight,
                        onItemClick: () {},
                      ),
                    ),

                    ///TERMS & CONDITIONS
                    Padding(
                      padding: const EdgeInsets.only(
                        top: MAIN_HORIZONTAL_PADDING,
                      ),
                      child: listItemIcon(
                        iconType: IconType.ICON,
                        leadingIcon: Icons.receipt_long_rounded,
                        itemTitle: 'Terms & Conditions',
                        trailingIcon: icArrowRight,
                        onItemClick: () {},
                      ),
                    ),

                    ///RETURNS & REFUNDS
                    Padding(
                      padding: const EdgeInsets.only(
                        top: MAIN_HORIZONTAL_PADDING,
                      ),
                      child: listItemIcon(
                        iconType: IconType.ICON,
                        leadingIcon: Icons.keyboard_return_rounded,
                        itemTitle: 'Returns & Refunds',
                        trailingIcon: icArrowRight,
                        onItemClick: () {},
                      ),
                    ),

                    setHeight(MAIN_VERTICAL_PADDING),

                    /// SUPPORT SECTION
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: MAIN_HORIZONTAL_PADDING,
                      ),
                      child: appText(
                        text: 'Support',
                        textStyle: secondaryTextStyle(),
                      ),
                    ),

                    ///Customer Support Service
                    Padding(
                      padding: const EdgeInsets.only(
                        top: MAIN_HORIZONTAL_PADDING,
                      ),
                      child: listItemIcon(
                        iconType: IconType.PNG,
                        leadingIcon: icAdmins,
                        itemTitle: 'Customer Service',
                        trailingIcon: icArrowRight,
                        onItemClick: () {},
                      ),
                    ),

                    /// CONTACT US ON WHATSAPP
                    Padding(
                      padding: const EdgeInsets.only(
                        top: MAIN_HORIZONTAL_PADDING,
                      ),
                      child: listItemIcon(
                        iconType: IconType.SVG,
                        leadingIcon: icWhatsapp,
                        itemTitle: 'Our Whatsapp',
                        trailingIcon: icArrowRight,
                        onItemClick: () {},
                      ),
                    ),

                    setHeight(MAIN_VERTICAL_PADDING),

                    /// SOCIAL MEDIA SECTION
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: MAIN_HORIZONTAL_PADDING,
                      ),
                      child: appText(
                        text: 'Follow Us',
                        textStyle: secondaryTextStyle(),
                      ),
                    ),

                    /// INSTAGRAM
                    Padding(
                      padding: const EdgeInsets.only(
                        top: MAIN_HORIZONTAL_PADDING,
                      ),
                      child: listItemIcon(
                        iconType: IconType.SVG,
                        leadingIcon: icInstagram,
                        itemTitle: 'Instagram',
                        trailingIcon: icArrowRight,
                        onItemClick: () {},
                      ),
                    ),

                    /// FACEBOOK
                    Padding(
                      padding: const EdgeInsets.only(
                        top: MAIN_HORIZONTAL_PADDING,
                      ),
                      child: listItemIcon(
                        iconType: IconType.SVG,
                        leadingIcon: icFacebook,
                        itemTitle: 'Facebook',
                        trailingIcon: icArrowRight,
                        onItemClick: () {},
                      ),
                    ),

                    /// LOGIN/LOGOUT
                    auth.currentUser.value != null
                        ? Padding(
                            padding: const EdgeInsets.only(
                              top: MAIN_HORIZONTAL_PADDING,
                            ),
                            child: auth.authStatus.value == AuthStatus.LOADING
                                ? loadingIndicator()
                                : listItemIcon(
                                    iconType: IconType.ICON,
                                    leadingIcon: Icons.logout_rounded,
                                    itemTitle: 'Sign out',
                                    trailingIcon: icArrowRight,
                                    onItemClick: () async {
                                      await auth.logoutUser().then((val) {
                                        Get.find<DashBoardController>()
                                                .navIndex
                                                .value =
                                            0;
                                      });
                                    },
                                  ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                              top: MAIN_HORIZONTAL_PADDING,
                            ),
                            child: listItemIcon(
                              iconType: IconType.ICON,
                              leadingIcon: Icons.login_rounded,
                              itemTitle: 'Sign in',
                              trailingIcon: icArrowRight,
                              onItemClick: (){
                                navigate.gotoSignInScreen();
                              },
                            ),
                          ),

                    setHeight(MAIN_VERTICAL_PADDING),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
