

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import '../../../data/repositories/dashboard_repository/dashboard_repository.dart';

class DashBoardController extends GetxController {
  RxDouble appBarHeight = 0.0.obs;

  RxInt navIndex = 0.obs;
  RxList<SliderImagesModel> sliderList = <SliderImagesModel>[].obs;
  Rx<AppbarSliderImagesStatus> sliderStatus = AppbarSliderImagesStatus.IDLE.obs;

  RxList<NotificationModel> notificationsList = <NotificationModel>[].obs;
  Rx<NotificationsStatus> notificationStatus = NotificationsStatus.IDLE.obs;

  RxList<CategoryModel> categoriesList = <CategoryModel>[].obs;
  Rx<CategoriesStatus> categoriesStatus = CategoriesStatus.IDLE.obs;

  final dashboardRepo = DashboardRepository();

  @override
  void onInit() {
    super.onInit();
    fetchSliderImages();
    fetchNotifications();
    fetchCategories();
  }

  onBottomNavItemTap(index){
    navIndex.value = index;
  }

  Future<void> fetchSliderImages() async {
    await dashboardRepo.fetchSliderImagesListEvent(sliderStatus, sliderList);
  }
  Future<void> fetchNotifications() async {
    await dashboardRepo.fetchNotificationsListEvent(notificationStatus, notificationsList);
  }

  NotificationModel? get marqueeNotification {
    try {
      return notificationsList.firstWhere(
            (element) => element.notificationType.toLowerCase() == 'marquee',
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> fetchCategories() async {
    await dashboardRepo.fetchCategoriesListEvent(categoriesStatus, categoriesList);
  }


}