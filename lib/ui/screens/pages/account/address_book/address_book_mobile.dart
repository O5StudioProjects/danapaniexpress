import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class AddressBookMobile extends StatelessWidget {
  const AddressBookMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var navigation = Get.find<NavigationController>();
    var auth = Get.find<AuthController>();
    Get.put(CheckoutController());
    var addressScreenType = Get.arguments[ADDRESS_SCREEN_TYPE] as AddressScreenType;
    return _buildUI(navigation, auth, addressScreenType);
  }

  Widget _buildUI(navigation, auth, addressScreenType){
    return Obx(() {
      var addressList = auth.currentUser.value!.addressBook!;
      var defaultAddress = auth.currentUser.value!.userDefaultAddress;
      return Scaffold(
        backgroundColor: AppColors.backgroundColorSkin(isDark),
        body: Column(
          children: [
            _appBar(),

            _mainSection(auth,addressScreenType,addressList,defaultAddress),

            _addAddressButton(navigation, defaultAddress),
          ],
        ),
      );
    });
  }

  Widget _appBar(){
    return appBarCommon(title: AppLanguage.addressBookStr(appLanguage), isBackNavigation: true);
  }

  Widget _mainSection(auth,addressScreenType,addressList,defaultAddress){
    return Expanded(
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
                _defaultAddressSection(auth,addressScreenType),

                if (addressList.isNotEmpty && auth.getProfileStatus.value == AuthStatus.SUCCESS && (defaultAddress != null && addressList.length > 1 || defaultAddress == null))
                  _existingAddressListSection(addressList, defaultAddress, addressScreenType),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _defaultAddressSection(auth,addressScreenType){
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
      ],
    );
  }

  Widget _existingAddressListSection(addressList, defaultAddress, addressScreenType){
    return Column(
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
    );
  }

  Widget _addAddressButton(navigation, defaultAddress){
    return Padding(
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
    );
  }

}


