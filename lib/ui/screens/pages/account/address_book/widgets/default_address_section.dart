import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class DefaultAddressSection extends StatelessWidget {
  final AddressScreenType addressScreenType;
  const DefaultAddressSection({super.key, required this.addressScreenType});

  @override
  Widget build(BuildContext context) {
    var auth = Get.find<AuthController>();
    return _buildUI(auth);
  }


  Widget _buildUI(auth){
    return Obx((){
      var defaultAddress = auth.currentUser.value?.userDefaultAddress;
      return defaultAddress != null
          ? _defaultAddressAvailable(defaultAddress)
          : _defaultAddressNotAvailable();
    });
  }

  Widget _defaultAddressNotAvailable(){
    return Padding(
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
              text: AppLanguage.defaultAddressNotFoundStr(appLanguage),
              textDirection: setTextDirection(
                appLanguage,
              ),
              textAlign: TextAlign.center,
              textStyle: secondaryTextStyle(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _defaultAddressAvailable(defaultAddress){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        setHeight(MAIN_VERTICAL_PADDING),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: MAIN_HORIZONTAL_PADDING,
          ),
          child: AddressItemUI(data: defaultAddress, isDefault: true, addressScreenType: addressScreenType),
        ),
        appDivider(),
      ],
    );
  }


}
