import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/ui/app_common/components/bottom_sheet.dart';
import 'package:danapaniexpress/ui/app_common/components/profile_image.dart';

class AccountInformationMobile extends StatelessWidget {
  const AccountInformationMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = Get.find<AuthController>();
    var account = Get.find<AccountController>();
    return Obx((){
      var data = auth.currentUser.value;
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(title: 'Account Information', isBackNavigation: true),

            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                    children: [
                      /// PROFILE PICTURE SECTION
                      Padding(
                        padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING, bottom: MAIN_HORIZONTAL_PADDING),
                        child: SizedBox(
                          width: 100.0,
                          height: 105.0,
                          child: Stack(
                            children: [
                              Container(
                                width: 100.0,
                                height: 100.0,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(100.0),
                                    border: Border.all(color: AppColors.materialButtonSkin(isDark), width: 2.0)
                                ),
                                child:
                                account.profileImage.value.isNotEmpty
                                    ? appAssetImage(image: account.profileImage.value, fit: BoxFit.cover)
                                    : data != null && data.userImage!.isNotEmpty
                                    ? appAsyncImage(data.userImage, boxFit: BoxFit.cover,)
                                    : appAssetImage(image: EnvImages.imgMainLogo, fit: BoxFit.cover),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: appFloatingButton(icon: Icons.camera_alt, iconType: IconType.ICON)),
                            ],
                          ),
                        ),
                      ),

                      /// PROFILE PICTURE UPLOAD BUTTON
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: AppColors.materialButtonSkin(isDark),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: AppColors.materialButtonSkin(isDark), width: 2.0)
                        ),
                        child: appText(text: 'Upload Profile Picture', textStyle: itemTextStyle().copyWith(color: AppColors.materialButtonTextSkin(isDark)), )
                      ),

                      setHeight(MAIN_VERTICAL_PADDING),

                      /// Full NAME
                      Padding(
                        padding: const EdgeInsets.only(
                          top: MAIN_VERTICAL_PADDING,
                        ),
                        child: listItemInfo(
                          itemTitle: 'Full Name',
                          trailingText: data!.userFullName,
                          trailingIcon: icArrowRight,
                          onItemClick: () {
                            appBottomSheet(context, widget: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                               appText(text: 'Welcome', textStyle: headingTextStyle())
                              ],
                            ));
                          },
                        ),
                      ),

                      /// CHANGE EMAIL
                      Padding(
                        padding: const EdgeInsets.only(
                          top: MAIN_HORIZONTAL_PADDING,
                        ),
                        child: listItemInfo(
                          itemTitle: 'Change Email',
                          trailingText: data.userEmail,
                          trailingIcon: icArrowRight,
                          onItemClick: () {

                          },
                        ),
                      ),

                      /// CHANGE PASSWORD
                      Padding(
                        padding: const EdgeInsets.only(
                          top: MAIN_HORIZONTAL_PADDING,
                          bottom: MAIN_HORIZONTAL_PADDING /2
                        ),
                        child: listItemInfo(
                          itemTitle: 'Change Password',
                          trailingText: '',
                          trailingIcon: icArrowRight,
                          onItemClick: () {

                          },
                        ),
                      ),
                      appDivider(),

                      /// UNCHANGE ABLE ITEMS
                      /// PHONE
                      Padding(
                        padding: const EdgeInsets.only(
                          top: MAIN_HORIZONTAL_PADDING/2,
                        ),
                        child: listItemInfo(
                          itemTitle: 'Phone',
                          trailingText: data.userPhone,
                          isTrailingIcon: false,
                        ),
                      ),

                      /// DEFAULT ADDRESS
                      if(data.userDefaultAddress != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: MAIN_HORIZONTAL_PADDING/2,
                          ),
                          child: listItemInfo(
                            itemTitle: 'Address',
                            trailingText: data.userDefaultAddress!.address,
                            isTrailingIcon: false,
                          ),
                        ),

                      /// CITY
                      if(data.userDefaultAddress != null)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: MAIN_HORIZONTAL_PADDING/2,
                        ),
                        child: listItemInfo(
                          itemTitle: 'City',
                          trailingText: data.userDefaultAddress!.city,
                          isTrailingIcon: false,
                        ),
                      ),


                      /// PROVICE
                      if(data.userDefaultAddress != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: MAIN_HORIZONTAL_PADDING/2,
                          ),
                          child: listItemInfo(
                            itemTitle: 'Province',
                            trailingText: data.userDefaultAddress!.province,
                            isTrailingIcon: false,
                          ),
                        ),

                    ]
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
