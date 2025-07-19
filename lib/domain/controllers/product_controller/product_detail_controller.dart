import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class ProductDetailController extends GetxController {

  final productRepo = ProductRepository();
  RxInt quantity = 1.obs;
  Rx<ProductsStatus> relatedProductStatus = ProductsStatus.IDLE.obs;
  Rx<ProductModel?> productData = Rx<ProductModel?>(null);
  RxList<ProductModel> relatedProductsList = <ProductModel>[].obs;


  @override
  Future<void> onInit() async {
    productData.value = Get.arguments[DATA_PRODUCT] as ProductModel;
    fetchRelatedProducts(productData.value!);

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

  Future<void> fetchRelatedProducts(ProductModel currentProduct) async {
    relatedProductStatus.value = ProductsStatus.LOADING;

    try {
      final result = await productRepo.fetchRelatedProducts(
        categoryId: currentProduct.productCategory!,
        subCategoryId: currentProduct.productSubCategory!,
      );

      // Remove current product from related list
      result.removeWhere((p) => p.productId == currentProduct.productId);

      relatedProductsList.assignAll(result);
      relatedProductStatus.value = ProductsStatus.SUCCESS;
      if (kDebugMode) {
        print("Related Products Fetched");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching related products: $e");
      }
      relatedProductsList.clear();
      relatedProductStatus.value = ProductsStatus.FAILURE;
    }
  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

}