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
                          mainHeadingText: AppLanguage.myOrdersStr(appLanguage).toString(),
                          isSeeAll: true,
                          isTrailingText: true,
                          trailingText: AppLanguage.viewAllOrdersStr(appLanguage).toString(),
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
                              itemTitle: AppLanguage.accountInformationStr(appLanguage).toString(),
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
                              itemTitle: AppLanguage.addressBookStr(appLanguage).toString(),
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
                        text: AppLanguage.privacySecurityStr(appLanguage).toString(),
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
                        itemTitle: AppLanguage.privacyPolicyStr(appLanguage).toString(),
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
                        itemTitle: AppLanguage.termsConditionsStr(appLanguage).toString(),
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
                        itemTitle: AppLanguage.returnsRefundsStr(appLanguage).toString(),
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
                        text: AppLanguage.supportStr(appLanguage).toString(),
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
                        itemTitle: AppLanguage.customerServiceStr(appLanguage).toString(),
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
                        itemTitle: AppLanguage.whatsappStr(appLanguage).toString(),
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
                        text: AppLanguage.followUsStr(appLanguage).toString(),
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
                        itemTitle: AppLanguage.instagramStr(appLanguage).toString(),
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
                        itemTitle: AppLanguage.facebookStr(appLanguage).toString(),
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
                                    itemTitle: AppLanguage.signOutStr(appLanguage).toString(),
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
                              itemTitle: AppLanguage.signInStr(appLanguage).toString(),
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
