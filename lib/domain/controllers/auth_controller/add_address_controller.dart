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

    ///ADDRESS VALIDATE
    addressNameTextController.value.addListener(validateAddressForm);
    addressPhoneTextController.value.addListener(validateAddressForm);
    addressAddressTextController.value.addListener(validateAddressForm);
    addressNearestPlaceTextController.value.addListener(validateAddressForm);
  }

  ///ADD USER ADDRESS
  Future<void> addAddress() async {
    addressStatus.value = AuthStatus.LOADING;

    final formattedPhone = PhoneUtils.normalizePhone(
      addressPhoneTextController.value.text.trim(),
    );
    if (formattedPhone == null) {
      addressStatus.value = AuthStatus.FAILURE;
      Get.snackbar('Invalid Phone', 'Please enter a valid phone number');
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
      setAsDefault:
          auth.currentUser.value != null &&
              auth.currentUser.value!.userDefaultAddress == null
          ? true
          : false,
    );

    if (result['success'] == true) {
      // Refresh address book or profile
      await auth.fetchUserProfile().then((value) {
        addressStatus.value = AuthStatus.SUCCESS;
      });

      //navigation.goBack(); // or to address list
    } else {
      Get.snackbar('Error', result['message'] ?? 'Something went wrong');
    }

    addressStatus.value = AuthStatus.IDLE;
  }

  /// DELETE USER ADDRESS
  Future<void> deleteAddress(String addressId) async {
    final uid = auth.userId.value;

    if (uid == null) {
      Get.snackbar('Error', 'User not logged in');
      return;
    }

    deleteAddressStatus.value = AuthStatus.LOADING;

    final result = await addressRepo.deleteAddressApi(
      userId: uid,
      addressId: addressId,
    );

    if (result['success'] == true) {
      deleteAddressStatus.value = AuthStatus.SUCCESS;
      Get.snackbar('Success', 'Address deleted successfully');
      // Optionally refresh profile or address list
      await auth.fetchUserProfile(); // or loadAddressList()
      Get.back();
    } else {
      deleteAddressStatus.value = AuthStatus.FAILURE;
      Get.snackbar('Failed', result['message'] ?? 'Unknown error');
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
      Get.snackbar('Error', 'User not logged in');
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
      Get.snackbar('Success', 'Address updated successfully');

      // Optionally refresh profile or address list
      await auth.fetchUserProfile(); // optional, based on your logic
    } else {
      updateAddressStatus.value = AuthStatus.FAILURE;
      Get.snackbar('Failed', result['message'] ?? 'Unknown error');
    }
  }

  /// ONTAP ADD ADDRESS BUTTON
  Future<void> handleAddAddressButtonTap() async {
    await addAddress().then((value) async {
      await clearAddressForm();
      Get.snackbar('Success', 'Address added successfully');
    });
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
