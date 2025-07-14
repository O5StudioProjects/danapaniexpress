import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/ui/app_common/components/profile_image.dart';

class AccountHeader extends StatelessWidget {
  const AccountHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var navigation = Get.find<NavigationController>();
    var auth = Get.find<AuthController>();
    return Obx((){
      var data = auth.currentUser.value;
      return Container(
          width: size.width,
          height: size.height * 0.23,

          decoration: BoxDecoration(
            color: AppColors.cardColorSkin(isDark),
            image: isDark ? null : DecorationImage(image: AssetImage(imgAccountBg2), fit: BoxFit.cover)
          ),
          child: Padding(
            padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
            child: SizedBox(
              // height: 80.0,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: ()=> navigation.gotoSettingsScreen(),
                      child: appIcon(iconType: IconType.ICON, icon: Icons.settings,width: 28.0, color: AppColors.materialButtonSkin(isDark))),


                  GestureDetector(
                    onTap: (){
                      if(data == null){
                        navigation.gotoSignInScreen();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: ()=> navigation.gotoAccountInformationScreen(),
                            child: ProfileImage(profileImage: data?.userImage)),
                        setWidth(MAIN_HORIZONTAL_PADDING),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              appText(text: data?.userFullName ?? AppLanguage.signInNowStr(appLanguage),
                                  maxLines: 1,
                                  textStyle: accountHeaderNameTextStyle(text: data?.userFullName ?? AppLanguage.signInNowStr(appLanguage))),
                              // setHeight(4.0),
                              if(data != null)
                              GestureDetector(
                                onTap: (){
                                  if(data.userDefaultAddress == null){
                                    navigation.gotoAddressBookScreen();
                                  }
                                },
                                child: Row(
                                  children: [
                                    appIcon(iconType: IconType.ICON, icon:  Icons.verified, color: data.userDefaultAddress != null ? blueColor : greyColor, width: 16.0),
                                    setWidth(6.0),
                                    appText(text: data.userDefaultAddress != null ? AppLanguage.verifiedStr(appLanguage) : AppLanguage.verifyAddressStr(appLanguage), textStyle: secondaryTextStyle())
                                  ],
                                ),
                              ),
                              // setHeight(8.0),
                              appDivider(),
                              data != null
                              ? Row(
                                children: [
                                  appText(text: '${data.userFavoritesCount} ', textStyle: itemTextStyle()),
                                  appText(text: AppLanguage.wishlistStr(appLanguage), textStyle: accountSecondaryTextStyle()),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: appText(text: '-', textStyle: bodyTextStyle().copyWith(color: AppColors.secondaryTextColorSkin(isDark))),
                                  ),
                                  appText(text: '${data.userCartCount} ', textStyle: itemTextStyle()),
                                  appText(text: AppLanguage.cartStr(appLanguage), textStyle: accountSecondaryTextStyle()),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: appText(text: '-', textStyle: bodyTextStyle().copyWith(color: AppColors.secondaryTextColorSkin(isDark))),
                                  ),
                                  appText(text: '${data.userOrdersCount} ', textStyle: itemTextStyle()),
                                  appText(text: AppLanguage.ordersStr(appLanguage), textStyle: accountSecondaryTextStyle()),
                                ],
                              )
                                  : appText(text: AppLanguage.welcomeToDanaPaniExpressStr(appLanguage), textStyle: secondaryTextStyle())
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
      );
    });
  }
}



class AccountHeaderSmall extends StatelessWidget {
  const AccountHeaderSmall({super.key});

  @override
  Widget build(BuildContext context) {
    var navigation = Get.find<NavigationController>();
    var auth = Get.find<AuthController>();
    return Obx((){
      var data = auth.currentUser.value;
      return Container(
        width: size.width,
        height: 100.0,
        decoration: BoxDecoration(color: AppColors.appBarColorSkin(isDark)),
        child: Padding(
          padding: const EdgeInsets.only(left: MAIN_HORIZONTAL_PADDING, right: 0.0, bottom: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                  onTap: ()=> navigation.gotoAccountInformationScreen(),
                  child: SizedBox(
                      width: 46.0,
                      height: 46.0,
                      child: ProfileImage(profileImage: data?.userImage))),
              setWidth(MAIN_HORIZONTAL_PADDING),
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if(data != null)
                            appIcon(iconType: IconType.ICON, icon:  Icons.verified, color: data.userDefaultAddress != null ? blueColor : greyColor, width: 16.0),
                          if(data != null) setWidth(8.0),
                          appText(text: data?.userFullName ?? AppLanguage.signInNowStr(appLanguage),
                              maxLines: 1,
                              textStyle: accountHeaderNameTextStyle(text: data?.userFullName ?? AppLanguage.signInNowStr(appLanguage))
                                  .copyWith(fontSize: HEADING_FONT_SIZE)
                          ),

                        ],
                      ),

                      appDivider(height: 6.0),
                      data != null
                          ? Row(
                        children: [
                          appText(text: '${data.userFavoritesCount} ', textStyle: itemTextStyle()),
                          appText(text: AppLanguage.wishlistStr(appLanguage), textStyle: accountSecondaryTextStyle()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: appText(text: '-', textStyle: bodyTextStyle().copyWith(color: AppColors.secondaryTextColorSkin(isDark))),
                          ),
                          appText(text: '${data.userCartCount} ', textStyle: itemTextStyle()),
                          appText(text: AppLanguage.cartStr(appLanguage), textStyle: accountSecondaryTextStyle()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: appText(text: '-', textStyle: bodyTextStyle().copyWith(color: AppColors.secondaryTextColorSkin(isDark))),
                          ),
                          appText(text: '${data.userOrdersCount} ', textStyle: itemTextStyle()),
                          appText(text: AppLanguage.ordersStr(appLanguage), textStyle: accountSecondaryTextStyle()),
                        ],
                      )
                          : appText(text: AppLanguage.welcomeToDanaPaniExpressStr(appLanguage), textStyle: secondaryTextStyle())
                    ],
                  )
              ),
              setWidth(MAIN_VERTICAL_PADDING),
              GestureDetector(
                  onTap: ()=> navigation.gotoSettingsScreen(),
                  child: SizedBox(
                      width: 46.0,
                      height: 46.0,
                      child: appIcon(iconType: IconType.ICON, icon: Icons.settings,width: 28.0, color: AppColors.materialButtonSkin(isDark)))),
            ],
          ),
        ),
      );
    });
  }
}
