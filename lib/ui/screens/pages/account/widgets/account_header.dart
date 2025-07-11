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
                  appIcon(iconType: IconType.ICON, icon: Icons.settings, color: AppColors.materialButtonSkin(isDark)),


                  GestureDetector(
                    onTap: (){
                      if(data != null){
                        navigation.gotoAccountInformationScreen();
                      } else {
                        navigation.gotoSignInScreen();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Container(
                        //   width: 80.0,
                        //   height: 80.0,
                        //   clipBehavior: Clip.antiAlias,
                        //   decoration: BoxDecoration(
                        //     color: whiteColor,
                        //     borderRadius: BorderRadius.circular(100.0),
                        //     border: Border.all(color: AppColors.backgroundColorSkin(isDark), width: 1.0)
                        //   ),
                        //   child:
                        //   data != null && data.userImage!.isNotEmpty
                        //       ? appAsyncImage(
                        //     data.userImage,
                        //     boxFit: BoxFit.cover,
                        //   )
                        //       : appAssetImage(image: EnvImages.imgMainLogo, fit: BoxFit.cover),
                        // ),
                        ProfileImage(profileImage: data?.userImage),
                        setWidth(MAIN_HORIZONTAL_PADDING),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              appText(text: data?.userFullName ?? 'Sign In Now',
                                  maxLines: 1,
                                  textStyle: bigBoldHeadingTextStyle().copyWith(fontSize: ACCOUNT_TITLE_FONT_SIZE)),
                              // setHeight(4.0),
                              if(data != null)
                              Row(
                                children: [
                                  appIcon(iconType: IconType.ICON, icon:  Icons.verified, color: data.userDefaultAddress != null ? blueColor : greyColor, width: 16.0),
                                  setWidth(6.0),
                                  appText(text: data.userDefaultAddress != null ? 'Verified' : 'Verify Address', textStyle: secondaryTextStyle())
                                ],
                              ),
                              // setHeight(8.0),
                              appDivider(),
                              data != null
                              ? Row(
                                children: [
                                  appText(text: '0 ', textStyle: itemTextStyle()),
                                  appText(text: 'Wishlist', textStyle: accountSecondaryTextStyle()),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: appText(text: '-', textStyle: bodyTextStyle().copyWith(color: AppColors.secondaryTextColorSkin(isDark))),
                                  ),
                                  appText(text: '0 ', textStyle: itemTextStyle()),
                                  appText(text: 'Cart', textStyle: accountSecondaryTextStyle()),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: appText(text: '-', textStyle: bodyTextStyle().copyWith(color: AppColors.secondaryTextColorSkin(isDark))),
                                  ),
                                  appText(text: '0 ', textStyle: itemTextStyle()),
                                  appText(text: 'Orders', textStyle: accountSecondaryTextStyle()),
                                ],
                              )
                                  : appText(text: 'Welcome to Dana Pani Express', textStyle: secondaryTextStyle())
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
