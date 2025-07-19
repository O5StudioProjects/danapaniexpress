import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class ProductController extends GetxController {

  final productsRepo  = ProductRepository();

  RxInt subCategoryIndex = 0.obs;
  final Rxn<CategoryModel> categoryDataInitial = Rxn<CategoryModel>();

  Rx<ProductsByCatStatus> productsStatus = ProductsByCatStatus.IDLE.obs;
  RxList<ProductModel> productsList = <ProductModel>[].obs;

  final scrollController = ScrollController();
  RxBool showBottomMessage = true.obs;
  RxBool reachedEndOfScroll = false.obs;
  double _previousOffset = 0;

// Load-more state for category-based products
  RxBool isLoadingMoreCategory = false.obs;
  RxBool hasMoreCategoryProducts = true.obs;
  RxList<ProductModel> categoryProducts = <ProductModel>[].obs;
  int categoryOffset = 0;
  final int categoryLimit = 10;

  final RxBool showTopHeader = true.obs;
  double _lastHeaderVisibilityOffset = 0.0;

  @override
  void onInit() {
    super.onInit();

    final categoryArg = Get.arguments[DATA_CATEGORY];
    final subCatIndexArg = Get.arguments[SUB_CATEGORY_INDEX] ?? 0;

    if (categoryArg is CategoryModel) {
      categoryDataInitial.value = categoryArg;
      subCategoryIndex.value = subCatIndexArg;

      initCategoryScrollListener(
        categoryData: categoryDataInitial.value!,
        subCategoryIndex: subCategoryIndex.value,
      );

      fetchProductsByCategories(
        categoryData: categoryDataInitial.value!,
        subCategoryIndex: subCategoryIndex.value,
        loadMore: false,
      );
    } else {
      productsStatus.value = ProductsByCatStatus.FAILURE;
      showSnackbar(
        isError: true,
        title: 'Invalid Data',
        message: 'Category data is missing or invalid.',
      );
    }
  }


  void initCategoryScrollListener({
    required CategoryModel categoryData,
    required int subCategoryIndex,
  }) {
    scrollController.addListener(() {
      final currentOffset = scrollController.position.pixels;
      final maxOffset = scrollController.position.maxScrollExtent;

      // ✅ Bottom message visibility
      if (currentOffset > _previousOffset) {
        showBottomMessage.value = true;
      } else {
        showBottomMessage.value = false;
      }

      // ✅ Header visibility logic
      if (currentOffset <= 0) {
        // At top
        if (!showTopHeader.value) showTopHeader.value = true;
      } else if (currentOffset > _lastHeaderVisibilityOffset + 10) {
        // Scrolling down
        if (showTopHeader.value) showTopHeader.value = false;
      } else if (currentOffset < _lastHeaderVisibilityOffset - 10) {
        // Scrolling up
        if (!showTopHeader.value) showTopHeader.value = true;
      }

      _lastHeaderVisibilityOffset = currentOffset;
      _previousOffset = currentOffset;

      // ✅ End of scroll detection
      reachedEndOfScroll.value = currentOffset >= maxOffset - 10;

      // ✅ Load more trigger
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
      productsStatus.value = ProductsByCatStatus.LOADING;
    }

    try {
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

      if (!loadMore) {
        productsStatus.value = ProductsByCatStatus.SUCCESS;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching products by category: $e");
      }

      if (!loadMore) {
        productsList.clear();
        productsStatus.value = ProductsByCatStatus.FAILURE;
      }
    } finally {
      isLoadingMoreCategory.value = false;
    }
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