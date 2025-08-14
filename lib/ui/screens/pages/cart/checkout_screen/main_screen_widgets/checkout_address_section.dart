import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class CheckoutAddressSection extends StatelessWidget {
  const CheckoutAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    var nav = Get.find<NavigationController>();
    var checkout = Get.find<CheckoutController>();
    var auth = Get.find<AuthController>();
    return _buildUI(nav,checkout, auth);
  }

  Widget _buildUI(nav,checkout, auth){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
          child: HomeHeadings(
            mainHeadingText: AppLanguage.shippingAddressStr(appLanguage).toString(),
            isSeeAll: true,
            isTrailingText: true,
            trailingText: AppLanguage.addressBookStr(appLanguage),
            onTapSeeAllText: () => nav.gotoAddressBookScreen(
              addressScreenType: AddressScreenType.CHECKOUT,
            ),
          ),
        ),
        _addressSectionMain(nav, auth, checkout),
      ],
    );
  }

  Widget _addressSectionMain(nav, auth, checkout){
    return GestureDetector(
      onTap: () => nav.gotoAddressBookScreen(
        addressScreenType: AddressScreenType.CHECKOUT,
      ),
      child: Obx(() {
        var defaultAddress = auth.currentUser.value?.userDefaultAddress;
        return Column(
          children: [
            checkout.shippingAddress.value != null
                ? _alreadyHasAddress(checkout, defaultAddress)
                : _addressNotFound(),
          ],
        );
      }),
    );
  }

  Widget _alreadyHasAddress(checkout, defaultAddress){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        setHeight(MAIN_VERTICAL_PADDING),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: MAIN_HORIZONTAL_PADDING,
          ),
          child: AddressItemUI(
            data: checkout.shippingAddress.value!,
            isDefault:
            checkout.shippingAddress.value!.addressId ==
                defaultAddress?.addressId
                ? true
                : false,
            addressScreenType: AddressScreenType.IDLE,
          ),
        ),
        //appDivider(),
      ],
    );
  }

  Widget _addressNotFound(){
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: MAIN_HORIZONTAL_PADDING,
        vertical: MAIN_VERTICAL_PADDING,
      ),
      child: Container(
        width: size.width,
        padding: const EdgeInsets.all(MAIN_VERTICAL_PADDING),

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
                color: AppColors.materialButtonSkin(isDark),
              ),
            ),
            appText(
              text: AppLanguage.defaultAddressNotFoundStr(
                appLanguage,
              ),
              textDirection: setTextDirection(appLanguage),
              textAlign: TextAlign.center,
              textStyle: secondaryTextStyle(),
            ),
          ],
        ),
      ),
    );
  }

}
