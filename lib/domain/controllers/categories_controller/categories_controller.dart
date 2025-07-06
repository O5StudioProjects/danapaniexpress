import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/data/repositories/categories_repository/categories_repository.dart';

class CategoriesController extends GetxController {
  final categoriesRepo = CategoriesRepository();

  // Categories
  RxList<CategoryModel> categoriesList = <CategoryModel>[].obs;
  Rx<CategoriesStatus> categoriesStatus = CategoriesStatus.IDLE.obs;

  // Single category
  Rx<CategoryModel?> singleCategory = Rx<CategoryModel?>(null);
  Rx<CategoriesStatus> singleCategoryStatus = CategoriesStatus.IDLE.obs;

  // Fetch Categories
  Future<void> fetchCategories() async {
    await categoriesRepo.fetchCategoriesListEvent(
      categoriesStatus,
      categoriesList,
    );
  }
  // Fetch Category by ID
  Future<void> fetchCategoryById(String id) async {
    categoriesRepo.fetchSingleCategoryEvent(
      categoryId: id,
      categoryData: singleCategory,
      status: singleCategoryStatus,
    );
  }

}