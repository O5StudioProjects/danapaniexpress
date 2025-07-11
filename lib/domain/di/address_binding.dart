import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/domain/controllers/auth_controller/address_book_controller.dart';

class AddressBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(AddressBookController());
  }

}