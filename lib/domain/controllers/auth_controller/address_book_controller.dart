import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/data/repositories/address_repository/address_repository.dart';

class AddressBookController extends GetxController {

  final addressRepo = AddressRepository();
  final auth = Get.find<AuthController>();

  //
  // @override
  // void onInit() {
  //
  //   // auth.fetchUserProfile();
  //
  //   super.onInit();
  // }



}