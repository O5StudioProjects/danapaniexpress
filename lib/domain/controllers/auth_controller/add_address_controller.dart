import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/data/repositories/address_repository/address_repository.dart';

import '../../../data/models/address_model.dart';

class AddAddressController extends GetxController {
  final addressRepo = AddressRepository();
  final auth = Get.find<AuthController>();

  final RxBool isAddressFormValid = false.obs;
  final Rx<AuthStatus> addressStatus = AuthStatus.IDLE.obs;
  final RxBool setDefaultAddressValue = false.obs;
  final Rx<AuthStatus> deleteAddressStatus = AuthStatus.IDLE.obs;
  final Rx<AuthStatus> updateAddressStatus = AuthStatus.IDLE.obs;

  ///ARGUMENTS DATA
  final Rx<AddressModel?> addressData = Rx<AddressModel?>(null);
  final Rx<CurdType> curdType = CurdType.ADD.obs;

  /// ADD ADDRESS TEXT CONTROLLERS - REGISTER SCREEN
  var addressNameTextController = TextEditingController().obs;
  var addressPhoneTextController = TextEditingController().obs;
  var addressAddressTextController = TextEditingController().obs;
  var addressNearestPlaceTextController = TextEditingController().obs;
  var addressPostalCodeTextController = TextEditingController().obs;
  final RxString cityName = ServiceAreas.SAHIWAL.obs;
  final RxString province = ServiceAreas.PUNJAB.obs;

  @override
  void onInit() {
    addressData.value = Get.arguments[DATA_ADDRESS] as AddressModel?;
    curdType.value = Get.arguments[DATA_CURD_TYPE] as CurdType;
    print(addressData.value?.name);
    print(curdType.value);
    setInitialFormValues();

    super.onInit();
  }

  ///SET USER INITIAL VALUES
  Future<void> setInitialFormValues() async {

    ///ADDRESS VALIDATE
    addressNameTextController.value.addListener(validateAddressForm);
    addressPhoneTextController.value.addListener(validateAddressForm);
    addressAddressTextController.value.addListener(validateAddressForm);
    addressNearestPlaceTextController.value.addListener(validateAddressForm);


    if (curdType.value == CurdType.ADD) {
      addressNameTextController.value.text =
          auth.currentUser.value!.userFullName ?? '';
      addressPhoneTextController.value.text =
          auth.currentUser.value!.userPhone ?? '';
    } else if (curdType.value == CurdType.UPDATE) {
      addressNameTextController.value.text = addressData.value!.name ?? '';
      addressPhoneTextController.value.text = addressData.value!.phone ?? '';
      addressAddressTextController.value.text =
          addressData.value!.address ?? '';
      addressNearestPlaceTextController.value.text =
          addressData.value!.nearestPlace ?? '';
      addressPostalCodeTextController.value.text =
          addressData.value!.postalCode ?? '';
      cityName.value = addressData.value!.city!;
      province.value = addressData.value!.province!;
    }


  }

  ///ADD USER ADDRESS
  Future<void> addAddress() async {
    addressStatus.value = AuthStatus.LOADING;

    final formattedPhone = PhoneUtils.normalizePhone(
      addressPhoneTextController.value.text.trim(),
    );

    if (formattedPhone == null) {
      addressStatus.value = AuthStatus.FAILURE;
      showSnackbar(
        isError: true,
        title: AppLanguage.invalidPhoneStr(appLanguage).toString(),
        message: AppLanguage.invalidPhoneDetailStr(appLanguage).toString(),
      );
      return;
    }

    final result = await addressRepo.addAddressApi(
      userId: auth.userId.value ?? '',
      name: addressNameTextController.value.text.trim(),
      phone: formattedPhone,
      address: addressAddressTextController.value.text.trim(),
      nearestPlace: addressNearestPlaceTextController.value.text.trim(),
      city: cityName.value,
      province: province.value,
      postalCode: addressPostalCodeTextController.value.text.trim(),
      setAsDefault: auth.currentUser.value?.userDefaultAddress == null,
    );

    if (result['success'] == true) {
      await auth.fetchUserProfile();
      showSnackbar(
        title: AppLanguage.successStr(appLanguage).toString(),
        message: AppLanguage.addressAddedSuccessStr(appLanguage).toString(),
      );

      addressStatus.value = AuthStatus.SUCCESS;

      await clearAddressForm(); // optional: clear form after success
      Navigator.pop(gContext);// close screen
    } else {
      addressStatus.value = AuthStatus.FAILURE;
      showSnackbar(
        isError: true,
        title: 'Error',
        message: result['message'] ?? result['error'] ?? 'Something went wrong',
      );
      if (kDebugMode) {
        print('ADD ADDRESS: ${result['message'] ?? result['error']}');
      }
    }

    addressStatus.value = AuthStatus.IDLE;
  }


  /// DELETE USER ADDRESS
  Future<void> deleteAddress(String addressId) async {
    final uid = auth.userId.value;

    if (uid == null) {
      showSnackbar(
        isError: true,
          title: AppLanguage.errorStr(appLanguage).toString(),
          message: AppLanguage.userNotLoggedInStr(appLanguage).toString(),
      );
      return;
    }

    deleteAddressStatus.value = AuthStatus.LOADING;

    final result = await addressRepo.deleteAddressApi(
      userId: uid,
      addressId: addressId,
    );

    if (result['success'] == true) {
      // Optionally refresh profile or address list
      await auth.fetchUserProfile(); // or loadAddressList()
      deleteAddressStatus.value = AuthStatus.SUCCESS;
      Navigator.pop(gContext);// close screen
      showSnackbar(
        isError: false,
        title: AppLanguage.successStr(appLanguage).toString(),
        message: AppLanguage.addressDeletedSuccessStr(appLanguage).toString(),
      );


    } else {
      deleteAddressStatus.value = AuthStatus.FAILURE;
      showSnackbar(
        isError: false,
        title: 'Failed',
        message: result['message'] ?? result['error'] ?? 'Unknown error',
      );
      if (kDebugMode) {
        print('DELETE ADDRESS : ${result['message'] ?? result['error']}');
      }
    }
  }

  /// UPDATE USER ADDRESS
  Future<void> updateAddress({
    required String addressId,
    required String name,
    required String phone,
    required String address,
    required String nearestPlace,
    required String city,
    required String province,
    required String postalCode,
    bool setAsDefault = false,
  }) async {
    final uid = auth.userId.value;
    if (uid == null) {
      showSnackbar(
        isError: true,
        title: AppLanguage.errorStr(appLanguage).toString(),
        message: AppLanguage.userNotLoggedInStr(appLanguage).toString(),
      );
      return;
    }
    updateAddressStatus.value = AuthStatus.LOADING;

    final result = await addressRepo.updateAddressApi(
      userId: uid,
      addressId: addressId,
      name: name,
      phone: phone,
      address: address,
      nearestPlace: nearestPlace,
      city: city,
      province: province,
      postalCode: postalCode,
      setAsDefault: setAsDefault,
    );

    if (result['success'] == true) {
      updateAddressStatus.value = AuthStatus.SUCCESS;
      showSnackbar(
          title: AppLanguage.successStr(appLanguage).toString(),
          message: AppLanguage.addressUpdatedSuccessStr(appLanguage).toString()
      );

      // Optionally refresh profile or address list
      await auth.fetchUserProfile(); // optional, based on your logic
    } else {
      updateAddressStatus.value = AuthStatus.FAILURE;
      showSnackbar(
          isError: true,
          title: 'Failed',
          message: result['message'] ?? result['error'] ?? 'Unknown error');
      if (kDebugMode) {
        print('UPDATE ADDRESS : ${result['message'] ?? result['error']}');
      }
    }
  }





  /// ONTAP ADD ADDRESS BUTTON
  Future<void> handleAddAddressButtonTap() async {
    await addAddress(); // Everything handled inside
  }

  /// ONTAP DELETE USER ADDRESS
  Future<void> handleDeleteUserAddressButtonTap(String addressId) async {
    await deleteAddress(addressId);
  }

  /// ONTAP UPDATE USER ADDRESS
  Future<void> handleUpdateUserAddressButtonTap(String addressId) async {
    await updateAddress(
      addressId: addressId,
      name: addressNameTextController.value.text.trim(),
      phone: addressPhoneTextController.value.text.trim(),
      address: addressAddressTextController.value.text.trim(),
      nearestPlace: addressNearestPlaceTextController.value.text.trim(),
      city: cityName.value,
      province: province.value,
      postalCode: addressPostalCodeTextController.value.text.trim(),
      setAsDefault: setDefaultAddressValue.value
    );
  }

  Future<void> clearAddressForm() async {
    addressNameTextController.value.clear();
    addressPhoneTextController.value.clear();
    addressAddressTextController.value.clear();
    addressNearestPlaceTextController.value.clear();
    addressPostalCodeTextController.value.clear();
  }

  void validateAddressForm() {
    final fullName = addressNameTextController.value.text.trim();
    final phone = addressPhoneTextController.value.text.trim();
    final address = addressAddressTextController.value.text.trim();
    final nearestPlace = addressNearestPlaceTextController.value.text.trim();
    isAddressFormValid.value =
        fullName.isNotEmpty &&
        phone.isNotEmpty &&
        address.isNotEmpty &&
        nearestPlace.isNotEmpty;
  }

  @override
  void onClose() {
    clearAddressForm();
    super.onClose();
  }
}
