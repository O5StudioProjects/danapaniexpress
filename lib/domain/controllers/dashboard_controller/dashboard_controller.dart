import 'dart:async';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import '../../../data/repositories/dashboard_repository/dashboard_repository.dart';

class DashBoardController extends GetxController {
  final dashboardRepo = DashboardRepository();

  // Bottom nav
  RxInt navIndex = 0.obs;

  // AppBar Slider
  RxList<PagerImagesModel> appbarPagerList = <PagerImagesModel>[].obs;
  Rx<AppbarPagerImagesStatus> appbarPagerStatus = AppbarPagerImagesStatus.IDLE.obs;

  // Notifications
  RxList<NotificationModel> notificationsList = <NotificationModel>[].obs;
  Rx<NotificationsStatus> notificationStatus = NotificationsStatus.IDLE.obs;

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

  // Init
  @override
  void onInit() {
    super.onInit();
    fetchAppbarPagerImages();
    fetchNotifications();
    fetchCategories();
    fetchBodyPagerImages();
    fetchAllProductLists();
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

  // Fetch marquee notification
  NotificationModel? get marqueeNotification {
    try {
      return notificationsList.firstWhere(
            (e) => e.notificationType.toLowerCase() == 'marquee',
      );
    } catch (e) {
      return null;
    }
  }

  // Fetch Notifications
  Future<void> fetchNotifications() async {
    await dashboardRepo.fetchNotificationsListEvent(
      notificationStatus,
      notificationsList,
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
        ..sort((a, b) => b.productTotalSold!.compareTo(a.productTotalSold!));
      popularProducts.assignAll(sorted);
      popularStatus.value = ProductsStatus.SUCCESS;
    } catch (e) {
      popularStatus.value = ProductsStatus.FAILURE;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
