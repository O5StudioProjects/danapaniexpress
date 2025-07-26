

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class ProductsController extends GetxController{

  final productsRepo = ProductsRepository();

  // Single Product
  Rx<ProductModel?> singleProduct = Rx<ProductModel?>(null);
  RxInt subCategoryIndex = 0.obs;
  RxBool isLoadingMore = false.obs;

  /// PRODUCTS LIST IN CATEGORIES
  Rx<ProductsByCatStatus> productsStatus = ProductsByCatStatus.IDLE.obs;
  RxList<ProductModel> productsList = <ProductModel>[].obs;
  final int productsLimit = PRODUCTS_LIMIT;
  int currentPage = 1;
  RxBool hasMoreProducts = true.obs;

  /// IF INDEX IS 0 AND ALL PRODUCTS FROM ONE CATEGORY
  Future<void> fetchInitialProductsByCategory(String category) async {
    try {
      productsStatus.value = ProductsByCatStatus.LOADING;
      currentPage = 1;
      final fetchedProducts = await productsRepo.getProductsByCategoryPaginated(
        category: category,
        page: currentPage,
        limit: productsLimit,
      );
      productsList.clear();
      productsList.assignAll(fetchedProducts);
      hasMoreProducts.value = fetchedProducts.length == productsLimit;
      productsStatus.value = ProductsByCatStatus.SUCCESS;
    } catch (e) {
      productsStatus.value = ProductsByCatStatus.FAILURE;
    }
  }

  Future<void> loadMoreProductsByCategory(String category) async {
    if (isLoadingMore.value || !hasMoreProducts.value) return;

    try {
      isLoadingMore.value = true;
      currentPage++;

      final moreProducts = await productsRepo.getProductsByCategoryPaginated(
        category: category,
        page: currentPage,
        limit: productsLimit,
      );

      productsList.addAll(moreProducts);

      // Check if more products are available
      if (moreProducts.length < productsLimit) {
        hasMoreProducts.value = false;
      }
    } catch (e) {
      currentPage--; // rollback if failed
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// FETCH INITIAL PRODUCTS BY CATEGORY & SUBCATEGORY
  Future<void> fetchInitialProductsByCategoryAndSubCategory({
    required String category,
    required String subCategory,
  }) async {
    try {
      productsStatus.value = ProductsByCatStatus.LOADING;
      currentPage = 1;
      hasMoreProducts.value = true;

      final fetchedProducts = await productsRepo.getProductsByCategoryAndSubCategoryPaginated(
        category: category,
        subCategory: subCategory,
        page: currentPage,
        limit: productsLimit,
      );
      productsList.clear();

      productsList.assignAll(fetchedProducts);
      hasMoreProducts.value = fetchedProducts.length == productsLimit;

      productsStatus.value = ProductsByCatStatus.SUCCESS;
    } catch (e) {
      productsStatus.value = ProductsByCatStatus.FAILURE;
    }
  }
  /// LOAD MORE PRODUCTS BY CATEGORY & SUBCATEGORY
  Future<void> loadMoreProductsByCategoryAndSubCategory({
    required String category,
    required String subCategory,
  }) async {
    if (isLoadingMore.value || !hasMoreProducts.value) return;

    try {
      isLoadingMore.value = true;
      currentPage++;

      final moreProducts = await productsRepo.getProductsByCategoryAndSubCategoryPaginated(
        category: category,
        subCategory: subCategory,
        page: currentPage,
        limit: productsLimit,
      );

      productsList.addAll(moreProducts);
      if (moreProducts.length < productsLimit) {
        hasMoreProducts.value = false;
      }
    } catch (e) {
      currentPage--;
    } finally {
      isLoadingMore.value = false;
    }
  }



  /// OTHER PRODUCTS - POPULAR PRODUCTS
  final RxList<ProductModel> popularProducts = <ProductModel>[].obs;
  final Rx<ProductsStatus> popularStatus = ProductsStatus.IDLE.obs;
  final RxBool hasMoreAllProducts = true.obs;

  final int popularLimit = 50;
  int currentPopularPage = 1;

  Future<void> fetchInitialPopularProducts() async {
    try {
      popularStatus.value = ProductsStatus.LOADING;
      currentPopularPage = 1;

      final products = await productsRepo.getPopularProductsPaginated(
        page: currentPopularPage,
        limit: popularLimit,
      );


      popularProducts.assignAll(products);
      hasMoreAllProducts.value = products.length == popularLimit;
      popularStatus.value = ProductsStatus.SUCCESS;
      print('POPULAR products Fetched');

    } catch (e) {
      popularStatus.value = ProductsStatus.FAILURE;
      // handle error or log
      print('POPULAR products $e');
    }
  }

  Future<void> loadMorePopularProducts() async {
    if (isLoadingMore.value || !hasMoreAllProducts.value) return;

    try {
      isLoadingMore.value = true;
      currentPopularPage += 1;

      final moreProducts = await productsRepo.getPopularProductsPaginated(
        page: currentPopularPage,
        limit: popularLimit,
      );

      if (moreProducts.isNotEmpty) {
        popularProducts.addAll(moreProducts);
      }

      // If fetched less than limit, no more products
      hasMoreAllProducts.value = moreProducts.length == popularLimit;
    } catch (e) {
      currentPopularPage -= 1; // revert page if failed
      // handle error
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// OTHER PRODUCTS - FEATURED PRODUCTS
  final RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  final Rx<ProductsStatus> featuredStatus = ProductsStatus.IDLE.obs;
  final RxBool hasMoreFeaturedProducts = true.obs;

  final int featuredLimit = PRODUCTS_LIMIT;
  int currentFeaturedPage = 1;

  Future<void> fetchInitialFeaturedProducts() async {
    try {
      featuredStatus.value = ProductsStatus.LOADING;
      currentFeaturedPage = 1;

      final products = await productsRepo.getFeaturedProductsPaginated(
        page: currentFeaturedPage,
        limit: featuredLimit,
      );


      featuredProducts.assignAll(products);
      hasMoreFeaturedProducts.value = products.length == featuredLimit;
      featuredStatus.value = ProductsStatus.SUCCESS;
      print('FEATURED products Fetched');

    } catch (e) {
      featuredStatus.value = ProductsStatus.FAILURE;
      // handle error or log
      print('POPULAR products $e');
    }
  }

  Future<void> loadMoreFeaturedProducts() async {
    if (isLoadingMore.value || !hasMoreFeaturedProducts.value) return;

    try {
      isLoadingMore.value = true;
      currentFeaturedPage += 1;

      final moreProducts = await productsRepo.getFeaturedProductsPaginated(
        page: currentFeaturedPage,
        limit: featuredLimit,
      );

      if (moreProducts.isNotEmpty) {
        featuredProducts.addAll(moreProducts);
      }

      // If fetched less than limit, no more products
      hasMoreFeaturedProducts.value = moreProducts.length == featuredLimit;
    } catch (e) {
      currentFeaturedPage -= 1; // revert page if failed
      // handle error
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// OTHER PRODUCTS - FLASH SALE PRODUCTS
  final RxList<ProductModel> flashSaleProducts = <ProductModel>[].obs;
  final Rx<ProductsStatus> flashSaleStatus = ProductsStatus.IDLE.obs;
  final RxBool hasMoreFlashSaleProducts = true.obs;

  final int flashSaleLimit = PRODUCTS_LIMIT;
  int currentFlashSalePage = 1;

  Future<void> fetchInitialFlashSaleProducts() async {
    try {
      flashSaleStatus.value = ProductsStatus.LOADING;
      currentFlashSalePage = 1;

      final products = await productsRepo.getFlashsaleProductsPaginated(
        page: currentFlashSalePage,
        limit: flashSaleLimit,
      );


      flashSaleProducts.assignAll(products);
      hasMoreFlashSaleProducts.value = products.length == flashSaleLimit;
      flashSaleStatus.value = ProductsStatus.SUCCESS;
      print('FLASH SALE products Fetched');

    } catch (e) {
      flashSaleStatus.value = ProductsStatus.FAILURE;
      // handle error or log
      print('POPULAR products $e');
    }
  }

  Future<void> loadMoreFlashSaleProducts() async {
    if (isLoadingMore.value || !hasMoreFlashSaleProducts.value) return;

    try {
      isLoadingMore.value = true;
      currentFlashSalePage += 1;

      final moreProducts = await productsRepo.getFlashsaleProductsPaginated(
        page: currentFlashSalePage,
        limit: flashSaleLimit,
      );

      if (moreProducts.isNotEmpty) {
        flashSaleProducts.addAll(moreProducts);
      }

      // If fetched less than limit, no more products
      hasMoreFlashSaleProducts.value = moreProducts.length == flashSaleLimit;
    } catch (e) {
      currentFlashSalePage -= 1; // revert page if failed
      // handle error
    } finally {
      isLoadingMore.value = false;
    }
  }





  Future<void> getSingleProduct(String id) async {
    singleProduct.value = await productsRepo.getSingleProduct(productId: id);
  }



}