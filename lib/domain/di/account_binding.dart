import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class AccountInfoBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(AccountInfoController());
  }

}