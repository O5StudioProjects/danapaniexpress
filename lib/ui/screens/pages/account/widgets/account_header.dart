import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/domain/controllers/account_controller/account_controller.dart';

class AccountHeader extends StatelessWidget {
  const AccountHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var account = Get.find<AccountController>();
    return Obx(
      ()=> Container(
          width: size.width,
          height: size.height * 0.23,
          color: AppColors.cardColorSkin(isDark),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 80.0,
                        height: 80.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColorSkin(isDark),
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child:
                        account.profileImage!.isNotEmpty
                            ? appAsyncImage(
                          account.profileImage!.value,
                          boxFit: BoxFit.cover,
                        )
                            : appAssetImage(image: imgDPEBanner, fit: BoxFit.cover),
                      ),
                      setWidth(MAIN_HORIZONTAL_PADDING),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            appText(text: 'Zain Shakeel',
                                maxLines: 1,
                                textStyle: bigBoldHeadingTextStyle().copyWith(fontSize: ACCOUNT_TITLE_FONT_SIZE)),
                            // setHeight(4.0),
                            Row(
                              children: [
                                appIcon(iconType: IconType.ICON, icon: Icons.verified, color: blueColor, width: 16.0),
                                setWidth(6.0),
                                appText(text: 'Verified', textStyle: secondaryTextStyle())
                              ],
                            ),
                            // setHeight(8.0),
                            appDivider(),
                            Row(
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
                                appText(text: 'Coins', textStyle: accountSecondaryTextStyle()),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
