import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/controllers/text_controllers/text_controllers.dart';

class AuthBinding extends Bindings{
  @override
  void dependencies() {
    // // Register AuthRepository
    // Get.lazyPut<AuthRepository>(() => AuthRepository());
    // // Register AuthController with injected repository
    // Get.lazyPut<AuthController>(() => AuthController(authRepo: Get.find<AuthRepository>()),
    // );
  }

}