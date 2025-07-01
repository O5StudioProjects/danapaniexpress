import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/data/repositories/products_repository/products_repository.dart';

class ProductController extends GetxController {

  final productsRepo  = ProductRepository();

  RxInt subCategoryIndex = 0.obs;
  Rx<CategoryModel?> categoryDataInitial = Rx<CategoryModel?>(null);

  Rx<ProductsByCatStatus> productsStatus = ProductsByCatStatus.IDLE.obs;
  RxList<ProductsModel> productsList = <ProductsModel>[].obs;

  //
  // @override
  // void onInit() {
  //  fetchProductsByCategories(categoryData: categoryDataInitial.value!, subCategoryIndex: subCategoryIndex.value);
  //   super.onInit();
  // }
  @override
  void onInit() {
    // Optional: Set initial category from navigation arguments
    categoryDataInitial.value = Get.arguments[DATA_CATEGORY] as CategoryModel;
    subCategoryIndex.value = Get.arguments[SUB_CATEGORY_INDEX] ?? 0;

    fetchProductsByCategories(
      categoryData: categoryDataInitial.value!,
      subCategoryIndex: subCategoryIndex.value,
    );

    super.onInit();
  }


  Future<void> onTapSubCategories(int index, categoryData) async {
    subCategoryIndex.value = index;
    await fetchProductsByCategories(categoryData: categoryData, subCategoryIndex: index);
  }

  Future<void> fetchProductsByCategories({required CategoryModel categoryData, int subCategoryIndex = 0}) async {
    productsRepo.fetchProductsByCategoriesEvent(productsList, productsStatus, categoryData: categoryData, subCategoryIndex: subCategoryIndex);
  }

}