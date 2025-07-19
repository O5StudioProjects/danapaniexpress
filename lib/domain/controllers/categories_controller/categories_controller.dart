import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class CategoriesController extends GetxController {
  final categoriesRepo = CategoriesRepository();

  // Categories
  RxList<CategoryModel> categoriesList = <CategoryModel>[].obs;
  Rx<CategoriesStatus> categoriesStatus = CategoriesStatus.IDLE.obs;

  // Single category
  Rx<CategoryModel?> singleCategory = Rx<CategoryModel?>(null);
  Rx<CategoriesStatus> singleCategoryStatus = CategoriesStatus.IDLE.obs;


  // Fetch AppBar slider images
  Future<void> fetchCategories() async {
    try {
      categoriesStatus.value = CategoriesStatus.LOADING;
      final items = await categoriesRepo.getCategories();
      categoriesList.assignAll(items);
      if (kDebugMode) {
        print("Categories Fetched");
      }
      categoriesStatus.value = CategoriesStatus.SUCCESS;
    } catch (e) {
      categoriesStatus.value = CategoriesStatus.FAILURE;
      if (kDebugMode) {
        print("=====================Error loading categories: $e");
      }
      showSnackbar(
        isError: true,
        title: 'Error',
        message: "=====================Error loading categories: $e",
      );
    }
  }
  // Fetch Category by ID
  Future<void> fetchCategoryById(String id) async {
    try {
      singleCategoryStatus.value = CategoriesStatus.LOADING;
      singleCategory.value  = await categoriesRepo.getSingleCategory(categoryId: id);
      if (kDebugMode) {
        print("Single Category Fetched :  ${singleCategory.value!.categoryNameEnglish}");
      }
      singleCategoryStatus.value = CategoriesStatus.SUCCESS;
    } catch (e) {
      singleCategoryStatus.value = CategoriesStatus.FAILURE;
      if (kDebugMode) {
        print("=====================Error loading Single Category: $e");
      }
      showSnackbar(
        isError: true,
        title: 'Error',
        message: "=====================Error loading Single Category: $e",
      );
    }

  }

}