import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/controllers/auth_controller/add_address_controller.dart';
import 'package:danapaniexpress/domain/controllers/auth_controller/address_book_controller.dart';
import '../../../../../../data/models/address_model.dart';
import '../../../../../app_common/components/simple_dropdown.dart';

class AddAddressMobile extends StatelessWidget {
  AddAddressMobile({super.key});

  final _formKey = GlobalKey<FormState>(); // 🔑 Form key

  @override
  Widget build(BuildContext context) {
    var auth = Get.find<AuthController>();
    var address = Get.find<AddressBookController>();
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
                  ? 'Add Address'
                  : 'Update Address',
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
                  itemTitle: 'Set as default address',
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
                          hintText: 'Name',
                          validator: FormValidations.fullNameValidator,
                        ),
                        setHeight(MAIN_HORIZONTAL_PADDING),

                        /// PHONE
                        AppTextFormField(
                          textEditingController:
                              addAddress.addressPhoneTextController.value,
                          hintText: 'Phone',
                          validator: FormValidations.phoneValidator,
                        ),
                        setHeight(MAIN_HORIZONTAL_PADDING),

                        /// ADDRESS
                        AppTextFormField(
                          textEditingController:
                              addAddress.addressAddressTextController.value,
                          hintText: 'Address',
                          validator: FormValidations.addressValidator,
                        ),
                        setHeight(MAIN_HORIZONTAL_PADDING),

                        /// NEAREST PLACE
                        AppTextFormField(
                          textEditingController: addAddress
                              .addressNearestPlaceTextController
                              .value,
                          hintText: 'Nearest Place',
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
                          hintText: 'Select City',
                        ),
                        setHeight(MAIN_HORIZONTAL_PADDING),

                        /// PROVINCE
                        SimpleDropdown(
                          items: provinceList,
                          selectedItem: ServiceAreas.PUNJAB,
                          onChanged: (val) {
                            addAddress.province.value = val!;
                          },
                          hintText: 'Select City',
                        ),
                        setHeight(MAIN_HORIZONTAL_PADDING),

                        /// POSTAL CODE
                        AppTextFormField(
                          textEditingController:
                              addAddress.addressPostalCodeTextController.value,
                          hintText: 'Postal Code (Optional)',
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
                                    text: 'Delete',
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
                                    text: 'Update',
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
                              text: 'Add',
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
