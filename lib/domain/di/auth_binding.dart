import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/controllers/text_controllers/text_controllers.dart';

class AuthBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(()=>TextControllers(), fenix: true);
  }

}