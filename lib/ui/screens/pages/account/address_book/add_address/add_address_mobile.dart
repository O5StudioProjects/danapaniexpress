import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class AddAddressMobile extends StatelessWidget {
  AddAddressMobile({super.key});

  final _formKey = GlobalKey<FormState>(); // 🔑 Form key

  @override
  Widget build(BuildContext context) {
    var auth = Get.find<AuthController>();
    var addAddress = Get.find<AddAddressController>();

    return _buildUI(auth, addAddress);
  }

  Widget _buildUI(auth, addAddress){
    return Obx(() {
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            _appBar(addAddress),

            _makeAddressDefault(addAddress, auth),

            _mainSection(addAddress),
          ],
        ),
      );
    });
  }

  Widget _appBar(addAddress){
    return appBarCommon(
      title: addAddress.curdType.value == CurdType.ADD
          ? AppLanguage.addAddressStr(appLanguage)
          : AppLanguage.updateAddressStr(appLanguage),
      isBackNavigation: true,
    );
  }

  Widget _makeAddressDefault(addAddress, auth){
    if(addAddress.curdType.value == CurdType.UPDATE
        && (auth.currentUser.value!.userDefaultAddress == null || addAddress.addressData.value!.addressId != auth.currentUser.value!.userDefaultAddress!.addressId!)){
      return Padding(
        padding: const EdgeInsets.only(
          top: MAIN_HORIZONTAL_PADDING,
        ),
        child: listItemSwitchButton(
          iconType: IconType.ICON,
          leadingIcon: Icons.location_on_rounded,
          itemTitle: AppLanguage.setAsDefaultAddressStr(appLanguage),
          switchValue: addAddress.setDefaultAddressValue.value,
          onItemClick: () {
            addAddress.setDefaultAddressValue.value = !addAddress.setDefaultAddressValue.value;
          },
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _mainSection(addAddress){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// NAME
                _name(addAddress),

                /// PHONE
                _phone(addAddress),

                /// ADDRESS
                _address(addAddress),

                /// NEAREST PLACE
                _nearestPlace(addAddress),

                /// CITY
                _city(addAddress),

                /// PROVINCE
                _province(addAddress),

                /// POSTAL CODE
                _postalCode(addAddress),

                _addButton(addAddress),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _name(addAddress){
    return  Padding(
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      child: AppTextFormField(
        textEditingController:
        addAddress.addressNameTextController.value,
        hintText: AppLanguage.nameStr(appLanguage),
        validator: FormValidations.fullNameValidator,
      ),
    );
  }
  Widget _phone(addAddress){
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      child: AppTextFormField(
        textEditingController:
        addAddress.addressPhoneTextController.value,
        hintText: AppLanguage.phoneStr(appLanguage),
        validator: FormValidations.phoneValidator,
        textInputType: TextInputType.number,
        isConstant: true,
      ),
    );
  }
  Widget _address(addAddress){
    return  Padding(
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      child: AppTextFormField(
        textEditingController:
        addAddress.addressAddressTextController.value,
        hintText: AppLanguage.addressHintStr(appLanguage),
        validator: FormValidations.addressValidator,
      ),
    );
  }
  Widget _nearestPlace(addAddress){
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      child: AppTextFormField(
        textEditingController: addAddress
            .addressNearestPlaceTextController
            .value,
        hintText: AppLanguage.nearestPlaceStr(appLanguage),
        validator: FormValidations.nearestPlaceValidator,
      ),
    );
  }
  Widget _city(addAddress){
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      child: SimpleDropdown(
        items: citiesList,
        selectedItem: ServiceAreas.SAHIWAL,
        onChanged: (val) {
          addAddress.cityName.value = val!;
        },
        hintText: AppLanguage.selectCityStr(appLanguage).toString(),
      ),
    );
  }
  Widget _province(addAddress){
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      child: SimpleDropdown(
        items: provinceList,
        selectedItem: ServiceAreas.PUNJAB,
        onChanged: (val) {
          addAddress.province.value = val!;
        },
        hintText: AppLanguage.selectProvinceStr(appLanguage).toString(),
      ),
    );
  }
  Widget _postalCode(addAddress){
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      child: AppTextFormField(
        textEditingController:
        addAddress.addressPostalCodeTextController.value,
        hintText: AppLanguage.postalCodeOptionalStr(appLanguage),
        textInputType: TextInputType.number,
        isConstant: true,
      ),
    );
  }
  Widget _addButton(addAddress){
    return Obx(() {
      if (addAddress.addressStatus.value ==
          AuthStatus.LOADING) {
        return loadingIndicator(); // or custom loading widget
      }
      if (addAddress.curdType.value == CurdType.UPDATE) {
        return Row(
          children: [
            Expanded(
              child: addAddress.deleteAddressStatus.value == AuthStatus.LOADING
                  ? loadingIndicator()
                  : appMaterialButton(
                isDisable: false,
                text: AppLanguage.deleteStr(appLanguage),
                onTap: () async {
                  await addAddress.handleDeleteUserAddressButtonTap(addAddress.addressData.value!.addressId!);
                },
              ),
            ),
            setWidth(MAIN_HORIZONTAL_PADDING),
            Expanded(
              child:

              addAddress.updateAddressStatus.value == AuthStatus.LOADING
                  ? loadingIndicator()
                  : appMaterialButton(
                isDisable: !addAddress.isAddressFormValid.value,
                text: AppLanguage.updateStr(appLanguage),
                onTap: () async {
                  if (addAddress.isAddressFormValid.value) {
                    if (_formKey.currentState?.validate() ??
                        false) {
                      // Proceed with Update
                      await addAddress.handleUpdateUserAddressButtonTap(addAddress.addressData.value!.addressId!);
                    }
                  }
                },
              ),
            ),
          ],
        );
      } else {
        return appMaterialButton(
          isDisable: !addAddress.isAddressFormValid.value,
          text: AppLanguage.addStr(appLanguage),
          onTap: () async {
            if (addAddress.isAddressFormValid.value) {
              if (_formKey.currentState?.validate() ??
                  false) {
                // Proceed with login
                await addAddress
                    .handleAddAddressButtonTap();
              }
            }
          },
        );
      }
    });
  }

}
