import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/ui/screens/pages/account/address_book/widgets/default_address_section.dart';

class AddressBookMobile extends StatelessWidget {
  const AddressBookMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var navigation = Get.find<NavigationController>();
    var auth = Get.find<AuthController>();
    Get.put(CheckoutController());
    var addressScreenType = Get.arguments[ADDRESS_SCREEN_TYPE] as AddressScreenType;
    return Obx(() {
      var addressList = auth.currentUser.value!.addressBook!;
      var defaultAddress = auth.currentUser.value!.userDefaultAddress;
      return Scaffold(
        backgroundColor: AppColors.backgroundColorSkin(isDark),
        body: Column(
          children: [
            appBarCommon(title: AppLanguage.addressBookStr(appLanguage), isBackNavigation: true),

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
                          mainHeadingText: AppLanguage.defaultShippingAddressStr(appLanguage).toString(),
                          isTrailingText: false,
                          isSeeAll: false,
                        ),
                        auth.getProfileStatus.value == AuthStatus.LOADING
                        ? SizedBox(
                            width: size.width,
                            height: size.height * 0.2,
                            child: loadingIndicator())
                        : DefaultAddressSection(addressScreenType: addressScreenType,),
                
                        if (addressList.isNotEmpty && auth.getProfileStatus.value == AuthStatus.SUCCESS && (defaultAddress != null && addressList.length > 1 || defaultAddress == null))
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HomeHeadings(
                                mainHeadingText: AppLanguage.myOtherAddressesStr(appLanguage).toString(),
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
                                      isDefault: defaultAddress != null && defaultAddress.addressId == data.addressId ? true : false, addressScreenType: addressScreenType,
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
                      text: AppLanguage.addNewAddressStr(appLanguage),
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


