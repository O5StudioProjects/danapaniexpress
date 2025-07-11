import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class AccountBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(AccountController());
  }

}