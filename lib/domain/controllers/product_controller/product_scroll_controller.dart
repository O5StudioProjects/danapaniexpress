import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/domain/controllers/product_controller/products_controller.dart';

class ProductScrollController extends GetxController {

  final productsRepo  = ProductDetailRepository();
  var products = Get.find<ProductsController>();

  final Rxn<CategoryModel> categoryDataInitial = Rxn<CategoryModel>();


  final scrollController = ScrollController();
  RxBool showBottomMessage = true.obs;
  RxBool reachedEndOfScroll = false.obs;
  double _previousOffset = 0;

  final RxBool showTopHeader = true.obs;
  double _lastHeaderVisibilityOffset = 0.0;

  @override
  void onInit() {
    super.onInit();

    final categoryArg = Get.arguments[DATA_CATEGORY];
    final subCatIndexArg = Get.arguments[SUB_CATEGORY_INDEX] ?? 0;

    if (categoryArg is CategoryModel) {
      categoryDataInitial.value = categoryArg;
      final subCategories = categoryDataInitial.value!.subCategories ?? [];

      products.subCategoryIndex.value = subCatIndexArg;

      initCategoryScrollListener(
        categoryData: categoryDataInitial.value!.categoryId!,
        subCategory: 'All',
      );

      print('Subcategory Index : ${products.subCategoryIndex.value}');

      if (subCatIndexArg == 0) {
        // 'All' selected
        products.fetchInitialProductsByCategory(categoryDataInitial.value!.categoryId!);
      } else {
        final realIndex = subCatIndexArg - 1;

        if (realIndex >= 0 && realIndex < subCategories.length) {
          final subCatId = subCategories[realIndex].subCategoryId!;
          products.fetchInitialProductsByCategoryAndSubCategory(
            category: categoryDataInitial.value!.categoryId!,
            subCategory: subCatId,
          );
        } else {
          showSnackbar(
            isError: true,
            title: 'Invalid Index',
            message: 'Subcategory index is out of bounds.',
          );
        }
      }
    } else {
      showSnackbar(
        isError: true,
        title: 'Invalid Data',
        message: 'Category data is missing or invalid.',
      );
    }
  }




  void initCategoryScrollListener({
    required String categoryData,
    required String subCategory,
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
        if(products.subCategoryIndex.value == 0){
          products.loadMoreProductsByCategory(categoryData);
        } else {
          products.loadMoreProductsByCategoryAndSubCategory(category: categoryData, subCategory: subCategory);
        }
      }
    });
  }



@override
  void onClose() {
    products.subCategoryIndex.value = 0;
    scrollController.dispose();
    super.onClose();
  }
}