import 'dart:async';
import 'dart:convert';
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

  // Products
  RxList<ProductsModel> productsList = <ProductsModel>[].obs;
  Rx<ProductsStatus> productsStatus = ProductsStatus.IDLE.obs;
  int _currentProductLimit = 20;
  bool _isLoadingMore = false;

  // Init
  @override
  void onInit() {
    super.onInit();
    fetchAppbarPagerImages();
    fetchNotifications();
    fetchCategories();
    fetchBodyPagerImages();
    fetchProducts(); // Fetch initial 20 products
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

  // Fetch Products (initial 20)
  Future<void> fetchProducts({int limit = 20}) async {
    _currentProductLimit = limit;
    await dashboardRepo.fetchProductsListEvent(
      productsStatus,
      productsList,
      limit: _currentProductLimit,
    );
  }

  // Load More Products
  Future<void> loadMoreProducts() async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;

    _currentProductLimit += 20;
    await dashboardRepo.fetchProductsListEvent(
      productsStatus,
      productsList,
      limit: _currentProductLimit,
    );

    _isLoadingMore = false;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
