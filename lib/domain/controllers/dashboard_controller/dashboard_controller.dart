import 'dart:async';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import '../../../data/repositories/dashboard_repository/dashboard_repository.dart';

class DashBoardController extends GetxController {
  final dashboardRepo = DashboardRepository();


  // Bottom nav
  RxInt navIndex = 0.obs;

  ///HOME SCREEN

  // AppBar Slider
  RxList<PagerImagesModel> appbarPagerList = <PagerImagesModel>[].obs;
  Rx<AppbarPagerImagesStatus> appbarPagerStatus = AppbarPagerImagesStatus.IDLE.obs;

  // MARQUEE
  Rx<MarqueeModel?> marqueeData = Rx<MarqueeModel?>(null);
  Rx<MarqueeStatus> marqueeStatus = MarqueeStatus.IDLE.obs;

  // Categories
  RxList<CategoryModel> categoriesList = <CategoryModel>[].obs;
  Rx<CategoriesStatus> categoriesStatus = CategoriesStatus.IDLE.obs;

  // Body Pager Slider
  RxList<PagerImagesModel> bodyPagerList = <PagerImagesModel>[].obs;
  Rx<BodyPagerImagesStatus> bodyPagerStatus = BodyPagerImagesStatus.IDLE.obs;
  final CarouselSliderController bodyPagerController = CarouselSliderController();
  final RxInt currentSlide = 0.obs;


  // Status
  Rx<ProductsStatus> allStatus = ProductsStatus.IDLE.obs;
  Rx<ProductsStatus> featuredStatus = ProductsStatus.IDLE.obs;
  Rx<ProductsStatus> flashSaleStatus = ProductsStatus.IDLE.obs;
  Rx<ProductsStatus> popularStatus = ProductsStatus.IDLE.obs;

  // Lists
  RxList<ProductsModel> allProducts = <ProductsModel>[].obs;
  RxList<ProductsModel> featuredProducts = <ProductsModel>[].obs;
  RxList<ProductsModel> flashSaleProducts = <ProductsModel>[].obs;
  RxList<ProductsModel> popularProducts = <ProductsModel>[].obs;

  // Limits
  int _allLimit = 20;
  int _featuredLimit = 20;
  int _flashSaleLimit = 20;

  // Loading Flags
  bool _isLoadingAll = false;
  bool _isLoadingFeatured = false;
  bool _isLoadingFlashSale = false;


  // SINGLE BANNER ON HOME SCREEN
  Rx<PagerImagesModel?> singleBannerOne = Rx<PagerImagesModel?>(null);
  Rx<SingleBannerOneStatus> singleBannerOneStatus = SingleBannerOneStatus.IDLE.obs;

  Rx<PagerImagesModel?> singleBannerTwo = Rx<PagerImagesModel?>(null);
  Rx<SingleBannerTwoStatus> singleBannerTwoStatus = SingleBannerTwoStatus.IDLE.obs;

  /// CATEGORIES SECTION

  RxInt categoryIndex = 0.obs;

  var navigationController = Get.find<NavigationController>();


  // Init
  @override
  void onInit() {
    super.onInit();
    fetchAppbarPagerImages();
    fetchMarquee();
    fetchCategories();
    fetchBodyPagerImages();
    fetchAllProductLists();
    fetchSingleBannerOne();
    fetchSingleBannerTwo();

  }

  // Bottom nav change
  void onBottomNavItemTap(int index) {
    navIndex.value = index;
  }

  // Fetch AppBar slider images
  Future<void> fetchAppbarPagerImages() async {
    await dashboardRepo.fetchAppbarPagerImagesListEvent(
      appbarPagerStatus,
      appbarPagerList,
    );
  }


  // Fetch Notifications
  Future<void> fetchMarquee() async {
    await dashboardRepo.fetchMarqueeEvent(
      marqueeStatus,
      marqueeData,
    );
  }

  // Fetch Categories
  Future<void> fetchCategories() async {
    await dashboardRepo.fetchCategoriesListEvent(
      categoriesStatus,
      categoriesList,
    );
  }

  // Fetch Body Slider
  Future<void> fetchBodyPagerImages() async {
    await dashboardRepo.fetchBodyPagerImagesListEvent(
      bodyPagerStatus,
      bodyPagerList,
    );
  }

  // SIGNLE BANNER HOME
  Future<void> fetchSingleBannerOne() async {
    await dashboardRepo.fetchSingleBannerOneEvent(
      singleBannerOneStatus,
      singleBannerOne,
    );
  }

  Future<void> fetchSingleBannerTwo() async {
    await dashboardRepo.fetchSingleBannerTwoEvent(
        singleBannerTwoStatus,
        singleBannerTwo,
    );
  }

  // ✅ Fetch All Lists at Once
  Future<void> fetchAllProductLists() async {
    await Future.wait([
      fetchAllProducts(),
      fetchFeaturedProducts(),
      fetchFlashSaleProducts(),
    ]);
    _generatePopularProducts();
  }

  // ✅ All Products (used to build popular)
  Future<void> fetchAllProducts({bool loadMore = false}) async {
    if (_isLoadingAll) return;
    _isLoadingAll = true;

    if (loadMore) _allLimit += 20;

    allStatus.value = ProductsStatus.LOADING;

    try {
      final result = await dashboardRepo.fetchProductsListEvent(
        filterType: ProductFilterType.all,
        limit: _allLimit,
      );
      allProducts.assignAll(result);
      allStatus.value = ProductsStatus.SUCCESS;
      _generatePopularProducts(); // refresh popular when all changes
    } catch (e) {
      allStatus.value = ProductsStatus.FAILURE;
    }

    _isLoadingAll = false;
  }

  // ✅ Featured
  Future<void> fetchFeaturedProducts({bool loadMore = false}) async {
    if (_isLoadingFeatured) return;
    _isLoadingFeatured = true;

    if (loadMore) _featuredLimit += 20;

    featuredStatus.value = ProductsStatus.LOADING;

    try {
      final result = await dashboardRepo.fetchProductsListEvent(
        filterType: ProductFilterType.featured,
        limit: _featuredLimit,
      );
      featuredProducts.assignAll(result);
      featuredStatus.value = ProductsStatus.SUCCESS;
    } catch (e) {
      featuredStatus.value = ProductsStatus.FAILURE;
    }

    _isLoadingFeatured = false;
  }

  // ✅ Flash Sale
  Future<void> fetchFlashSaleProducts({bool loadMore = false}) async {
    if (_isLoadingFlashSale) return;
    _isLoadingFlashSale = true;

    if (loadMore) _flashSaleLimit += 20;

    flashSaleStatus.value = ProductsStatus.LOADING;

    try {
      final result = await dashboardRepo.fetchProductsListEvent(
        filterType: ProductFilterType.flashSale,
        limit: _flashSaleLimit,
      );
      flashSaleProducts.assignAll(result);
      flashSaleStatus.value = ProductsStatus.SUCCESS;
    } catch (e) {
      flashSaleStatus.value = ProductsStatus.FAILURE;
    }

    _isLoadingFlashSale = false;
  }

  // ✅ Build Popular List from All Products
  void _generatePopularProducts() {
    popularStatus.value = ProductsStatus.LOADING;

    try {
      final sorted = List<ProductsModel>.from(allProducts)
        ..sort((a, b) {
          // Handle nulls explicitly
          final aAvailable = a.productAvailability ?? false;
          final bAvailable = b.productAvailability ?? false;

          // Prioritize available products
          if (aAvailable != bAvailable) {
            return bAvailable ? 1 : -1;
          }

          // If both have same availability, sort by total sold
          return b.productTotalSold!.compareTo(a.productTotalSold!);
        });

      popularProducts.assignAll(sorted);
      popularStatus.value = ProductsStatus.SUCCESS;
    } catch (e) {
      popularStatus.value = ProductsStatus.FAILURE;
    }
  }


  ///CATEGORIES SECTION METHODS

  Future<void> onTapCategories(int index)async {
    categoryIndex.value = index;
  }

  Future<void> onTapSubCategories(int index, CategoryModel categoryData)async {
    navigationController.gotoProductsScreen(data: categoryData, subCategoryIndex: index);

  }



  @override
  void onClose() {
    super.onClose();
  }
}
