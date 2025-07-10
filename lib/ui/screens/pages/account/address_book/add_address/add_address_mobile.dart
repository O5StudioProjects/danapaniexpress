import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../../../app_common/components/simple_dropdown.dart';
import '../../../../../app_common/components/searchable_dropdown_list_widget.dart';

class AddAddressMobile extends StatelessWidget {
  AddAddressMobile({super.key});
  final _formKey = GlobalKey<FormState>(); // 🔑 Form key

  @override
  Widget build(BuildContext context) {
    var auth = Get.find<AuthController>();
    return Obx((){
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(
                title: 'Add Address', isBackNavigation: true
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
                            textEditingController: auth.addressNameTextController.value,
                            hintText: 'Name',
                            validator: FormValidations.fullNameValidator,
                          ),
                          setHeight(MAIN_HORIZONTAL_PADDING),
                          /// PHONE
                          AppTextFormField(
                            textEditingController: auth.addressPhoneTextController.value,
                            hintText: 'Phone',
                            validator: FormValidations.phoneValidator,

                          ),
                          setHeight(MAIN_HORIZONTAL_PADDING),
                          /// ADDRESS
                          AppTextFormField(
                            textEditingController: auth.addressAddressTextController.value,
                            hintText: 'Address',
                            validator: FormValidations.addressValidator,
                          ),
                          setHeight(MAIN_HORIZONTAL_PADDING),
                          /// NEAREST PLACE
                          AppTextFormField(
                            textEditingController: auth.addressNearestPlaceTextController.value,
                            hintText: 'Nearest Place',
                            validator: FormValidations.nearestPlaceValidator,
                          ),
                          setHeight(MAIN_HORIZONTAL_PADDING),
                          /// CITY
                          SimpleDropdown(
                            items: citiesList,
                            selectedItem: ServiceAreas.SAHIWAL,
                            onChanged: (val) {
                              auth.cityName.value = val!;
                            },
                            hintText: 'Select City',
                          ),
                          setHeight(MAIN_HORIZONTAL_PADDING),
                          /// PROVINCE
                          SimpleDropdown(
                            items: provinceList,
                            selectedItem: ServiceAreas.PUNJAB,
                            onChanged: (val) {
                              auth.province.value = val!;
                            },
                            hintText: 'Select City',
                          ),
                          setHeight(MAIN_HORIZONTAL_PADDING),




                          /// POSTAL CODE
                          AppTextFormField(
                            textEditingController: auth.addressPostalCodeTextController.value,
                            hintText: 'Postal Code (Optional)',
                          ),
                          setHeight(MAIN_VERTICAL_PADDING),

                          Obx((){
                            if (auth.addressStatus.value == AuthStatus.LOADING) {
                              return loadingIndicator(); // or custom loading widget
                            }
                            return appMaterialButton(
                              isDisable: !auth.isAddressFormValid.value,
                              text: 'Add',
                              onTap: () async {
                                if(auth.isAddressFormValid.value){
                                  if (_formKey.currentState?.validate() ?? false) {
                                    // Proceed with login
                                    await auth.handleAddAddressButtonTap();
                                  }
                                }
                              },
                            );
                          })



                        ],
                      ),
                    ),
                  ),
                )
            ),
          ],
        ),
      );
    });
  }
}
