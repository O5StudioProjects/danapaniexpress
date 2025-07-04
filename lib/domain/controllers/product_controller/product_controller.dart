import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/data/repositories/products_repository/products_repository.dart';

import '../dashboard_controller/dashboard_controller.dart';

class ProductController extends GetxController {

  final productsRepo  = ProductRepository();

  RxInt subCategoryIndex = 0.obs;
  Rx<CategoryModel?> categoryDataInitial = Rx<CategoryModel?>(null);

  Rx<ProductsByCatStatus> productsStatus = ProductsByCatStatus.IDLE.obs;
  RxList<ProductsModel> productsList = <ProductsModel>[].obs;

  final scrollController = ScrollController();
  RxBool showBottomMessage = true.obs;
  RxBool reachedEndOfScroll = false.obs;
  double _previousOffset = 0;

// Load-more state for category-based products
  RxBool isLoadingMoreCategory = false.obs;
  RxBool hasMoreCategoryProducts = true.obs;
  RxList<ProductsModel> categoryProducts = <ProductsModel>[].obs;
  int categoryOffset = 0;
  final int categoryLimit = 10;

  //
  // @override
  // void onInit() {
  //  fetchProductsByCategories(categoryData: categoryDataInitial.value!, subCategoryIndex: subCategoryIndex.value);
  //   super.onInit();
  // }
  @override
  void onInit() {
    // Optional: Set initial category from navigation arguments
    categoryDataInitial.value = Get.arguments[DATA_CATEGORY] as CategoryModel?;
    subCategoryIndex.value = Get.arguments[SUB_CATEGORY_INDEX] ?? 0;

    initCategoryScrollListener(
      categoryData: categoryDataInitial.value!,
      subCategoryIndex: subCategoryIndex.value,
    );

    fetchProductsByCategories(
      categoryData: categoryDataInitial.value!,
      subCategoryIndex: subCategoryIndex.value,
      loadMore: false,
    );

    super.onInit();
  }

  void initCategoryScrollListener({
    required CategoryModel categoryData,
    required int subCategoryIndex,
  }) {
    scrollController.addListener(() {
      final currentOffset = scrollController.position.pixels;
      final maxOffset = scrollController.position.maxScrollExtent;

      // Scroll direction visibility logic (optional)
      if (currentOffset > _previousOffset) {
        showBottomMessage.value = true;
      } else {
        showBottomMessage.value = false;
      }
      _previousOffset = currentOffset;

      // ✅ End of scroll
      reachedEndOfScroll.value = currentOffset >= maxOffset - 10;

      // ✅ Trigger load more
      if (currentOffset >= maxOffset - 300) {
        _loadMoreCategoryProducts(categoryData, subCategoryIndex);
      }
    });
  }

  void _loadMoreCategoryProducts(CategoryModel categoryData, int subCategoryIndex) {
    if (!isLoadingMoreCategory.value && hasMoreCategoryProducts.value) {
      fetchProductsByCategories(
        categoryData: categoryData,
        subCategoryIndex: subCategoryIndex,
        loadMore: true,
      );
    }
  }


  Future<void> onTapSubCategories(int index, categoryData) async {
    subCategoryIndex.value = index;
    await fetchProductsByCategories(categoryData: categoryData, subCategoryIndex: index);
  }

  Future<void> fetchProductsByCategories({
    required CategoryModel categoryData,
    int subCategoryIndex = 0,
    bool loadMore = false,
  }) async {
    if (isLoadingMoreCategory.value || (!hasMoreCategoryProducts.value && loadMore)) return;

    if (loadMore) {
      isLoadingMoreCategory.value = true;
      await Future.delayed(Duration(seconds: 1));
      categoryOffset += categoryLimit;
    } else {
      categoryOffset = 0;
      hasMoreCategoryProducts.value = true;
    }

    final result = await productsRepo.fetchProductsByCategoriesEvent(
      categoryData: categoryData,
      subCategoryIndex: subCategoryIndex,
      limit: categoryLimit,
      offset: categoryOffset,
    );

    if (!loadMore) {
      productsList.assignAll(result);
    } else {
      productsList.addAll(result);
    }

    if (result.length < categoryLimit) {
      hasMoreCategoryProducts.value = false;
    }

    isLoadingMoreCategory.value = false;
  }

  // Future<void> fetchProductsByCategories({required CategoryModel categoryData, int subCategoryIndex = 0}) async {
  //   productsRepo.fetchProductsByCategoriesEvent(productsList, productsStatus, categoryData: categoryData, subCategoryIndex: subCategoryIndex);
  // }

@override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}