import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class AddressBookMobile extends StatelessWidget {
  const AddressBookMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var navigation = Get.find<NavigationController>();
    var auth = Get.find<AuthController>();
    return Obx(() {
      var addressList = auth.currentUser.value!.addressBook!;
      var defaultAddress = auth.currentUser.value!.userDefaultAddress;
      return Scaffold(
        backgroundColor: AppColors.backgroundColorSkin(isDark),
        body: Column(
          children: [
            appBarCommon(title: 'Address Book', isBackNavigation: true),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  // Call your reload or refresh logic here
                  await auth.fetchUserProfile(); // or any function to refresh data
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        setHeight(MAIN_VERTICAL_PADDING),
                        HomeHeadings(
                          mainHeadingText: 'Default Shipping Address',
                          isTrailingText: false,
                          isSeeAll: false,
                        ),
                        auth.getProfileStatus.value == AuthStatus.LOADING
                        ? SizedBox(
                            width: size.width,
                            height: size.height * 0.2,
                            child: loadingIndicator())
                        : defaultAddress != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  setHeight(MAIN_VERTICAL_PADDING),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: MAIN_HORIZONTAL_PADDING,
                                    ),
                                    child: AddressItemUI(data: defaultAddress, isDefault: true,),
                                  ),
                                  appDivider(),
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: MAIN_HORIZONTAL_PADDING,
                                  vertical: MAIN_VERTICAL_PADDING,
                                ),
                                child: Container(
                                  width: size.width,
                                  padding: const EdgeInsets.all(
                                    MAIN_VERTICAL_PADDING,
                                  ),
                
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: MAIN_HORIZONTAL_PADDING,
                                        ),
                                        child: appIcon(
                                          iconType: IconType.ICON,
                                          icon: Icons.location_city_rounded,
                                          width: 34.0,
                                          color: AppColors.materialButtonSkin(
                                            isDark,
                                          ),
                                        ),
                                      ),
                                      appText(
                                        text:
                                            'Default Address Not found!\nPlease add new address',
                                        textDirection: setTextDirection(
                                          appLanguage,
                                        ),
                                        textAlign: TextAlign.center,
                                        textStyle: secondaryTextStyle(),
                                      ),
                                      if(addressList.isNotEmpty)
                                      appText(
                                        text:
                                        'or select from other existing addresses.',
                                        maxLines: 2,
                                        textDirection: setTextDirection(
                                          appLanguage,
                                        ),
                                        textAlign: TextAlign.center,
                                        textStyle: secondaryTextStyle(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                
                        if (addressList.isNotEmpty && auth.getProfileStatus.value == AuthStatus.SUCCESS && (defaultAddress != null && addressList.length > 1 || defaultAddress == null))
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HomeHeadings(
                                mainHeadingText: 'My Other Addresses',
                                isTrailingText: false,
                                isSeeAll: false,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(
                                  MAIN_HORIZONTAL_PADDING,
                                ),
                                child: Column(
                                  children: List.generate(addressList.length, (
                                    index,
                                  ) {
                                    var data = addressList[index];
                                    return AddressItemUI(
                                      data: data,
                                      isDefault: defaultAddress != null && defaultAddress.addressId == data.addressId ? true : false
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                      ],
                    );
                  }),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: MAIN_HORIZONTAL_PADDING,
                right: MAIN_HORIZONTAL_PADDING,
                bottom: MAIN_VERTICAL_PADDING,
              ),
              child: appMaterialButton(
                customWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    appIcon(
                      iconType: IconType.ICON,
                      icon: Icons.add,
                      color: AppColors.materialButtonTextSkin(isDark),
                    ),
                    //setWidth(MAIN_HORIZONTAL_PADDING),
                    appText(
                      text: 'Add New Address',
                      textStyle: buttonTextStyle(
                        color: AppColors.materialButtonTextSkin(isDark),
                      ),
                    ),
                  ],
                ),
                onTap: () => navigation.gotoAddAddressScreen(data: defaultAddress),
              ),
            ),
          ],
        ),
      );
    });
  }
}


