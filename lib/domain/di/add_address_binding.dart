import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/controllers/auth_controller/add_address_controller.dart';
import 'package:danapaniexpress/domain/controllers/auth_controller/address_book_controller.dart';
import 'package:danapaniexpress/domain/controllers/text_controllers/text_controllers.dart';

class AddAddressBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(AddressBookController());
    Get.put(AddAddressController());
  }

}