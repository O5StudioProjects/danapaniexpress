import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';


class AddAddressMobile extends StatelessWidget {
  AddAddressMobile({super.key});

  final _formKey = GlobalKey<FormState>(); // 🔑 Form key

  @override
  Widget build(BuildContext context) {
    var auth = Get.find<AuthController>();
    var addAddress = Get.find<AddAddressController>();

    return Obx(() {
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(
              title: addAddress.curdType.value == CurdType.ADD
                  ? AppLanguage.addAddressStr(appLanguage)
                  : AppLanguage.updateAddressStr(appLanguage),
              isBackNavigation: true,
            ),
            if(addAddress.curdType.value == CurdType.UPDATE
                && (auth.currentUser.value!.userDefaultAddress == null || addAddress.addressData.value!.addressId != auth.currentUser.value!.userDefaultAddress!.addressId!))
              Padding(
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
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        /// NAME
                        AppTextFormField(
                          textEditingController:
                              addAddress.addressNameTextController.value,
                          hintText: AppLanguage.nameStr(appLanguage),
                          validator: FormValidations.fullNameValidator,
                        ),
                        setHeight(MAIN_HORIZONTAL_PADDING),

                        /// PHONE
                        AppTextFormField(
                          textEditingController:
                              addAddress.addressPhoneTextController.value,
                          hintText: AppLanguage.phoneStr(appLanguage),
                          validator: FormValidations.phoneValidator,
                        ),
                        setHeight(MAIN_HORIZONTAL_PADDING),

                        /// ADDRESS
                        AppTextFormField(
                          textEditingController:
                              addAddress.addressAddressTextController.value,
                          hintText: AppLanguage.addressHintStr(appLanguage),
                          validator: FormValidations.addressValidator,
                        ),
                        setHeight(MAIN_HORIZONTAL_PADDING),

                        /// NEAREST PLACE
                        AppTextFormField(
                          textEditingController: addAddress
                              .addressNearestPlaceTextController
                              .value,
                          hintText: AppLanguage.nearestPlaceStr(appLanguage),
                          validator: FormValidations.nearestPlaceValidator,
                        ),
                        setHeight(MAIN_HORIZONTAL_PADDING),

                        /// CITY
                        SimpleDropdown(
                          items: citiesList,
                          selectedItem: ServiceAreas.SAHIWAL,
                          onChanged: (val) {
                            addAddress.cityName.value = val!;
                          },
                          hintText: AppLanguage.selectCityStr(appLanguage).toString(),
                        ),
                        setHeight(MAIN_HORIZONTAL_PADDING),

                        /// PROVINCE
                        SimpleDropdown(
                          items: provinceList,
                          selectedItem: ServiceAreas.PUNJAB,
                          onChanged: (val) {
                            addAddress.province.value = val!;
                          },
                          hintText: AppLanguage.selectProvinceStr(appLanguage).toString(),
                        ),
                        setHeight(MAIN_HORIZONTAL_PADDING),

                        /// POSTAL CODE
                        AppTextFormField(
                          textEditingController:
                              addAddress.addressPostalCodeTextController.value,
                          hintText: AppLanguage.postalCodeOptionalStr(appLanguage),
                        ),
                       setHeight(MAIN_VERTICAL_PADDING),

                        Obx(() {
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
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
