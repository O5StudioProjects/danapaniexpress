import 'package:danapaniexpress/core/common_imports.dart';

class CartController  extends GetxController{

  // @override
  // void onInit() {
  //   print('Cart Controller Started');
  //   super.onInit();
  // }


  @override
  void onClose() {
    print('Cart Controller Stopped');
    super.onClose();
  }


  void startController(){
    print('Cart Controller Started');
  }

}