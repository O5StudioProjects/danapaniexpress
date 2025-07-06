import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class ProductDetailController extends GetxController {

  RxInt quantity = 1.obs;

  Rx<ProductsModel?> productData = Rx<ProductsModel?>(null);


  @override
  void onInit() {
    productData.value = Get.arguments[DATA_PRODUCT] as ProductsModel;

    super.onInit();
  }


  onTapMinus(){
    if(quantity.value > 1){
      quantity.value -=1;
    } else {
      print('Zero is not allowed');
    }
  }

  onTapPlus({productLimit = 5}){ //LIMIT TO 5 ITEMS AS QUANTITY
    if(quantity.value < productLimit){
      quantity.value +=1;
    } else {
      print('Limit Exceeded');
    }
  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

}