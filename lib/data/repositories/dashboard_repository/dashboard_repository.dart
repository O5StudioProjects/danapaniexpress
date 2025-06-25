import 'dart:convert';

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';


class DashboardRepository {

  Future<void> fetchSliderImagesListEvent(
      Rx<AppbarSliderImagesStatus> status,
      RxList<SliderImagesModel> sliderList,
      ) async {
    try {
      status.value = AppbarSliderImagesStatus.LOADING;
      String jsonString = await rootBundle.loadString(jsonAppbarSlider);

      List<dynamic> jsonData = json.decode(jsonString);
      List<SliderImagesModel> value =
      jsonData.map((item) => SliderImagesModel.fromJson(item)).toList();

      sliderList.assignAll(value);
      status.value = AppbarSliderImagesStatus.SUCCESS;
      if (kDebugMode) {
        print("SliderImages Fetched");
      }
    } catch (e) {
      status.value = AppbarSliderImagesStatus.FAILURE;
      if (kDebugMode) {
        print("Error loading slider images: $e");
      }
    }
  }

  Future<void> fetchNotificationsListEvent(
      Rx<NotificationsStatus> status,
      RxList<NotificationModel> notificationsList,
      ) async {
    try {
      status.value = NotificationsStatus.LOADING;
      String jsonString = await rootBundle.loadString(jsonNotification);

      List<dynamic> jsonData = json.decode(jsonString);
      List<NotificationModel> value =
      jsonData.map((item) => NotificationModel.fromJson(item)).toList();

      notificationsList.assignAll(value);
      status.value = NotificationsStatus.SUCCESS;
      if (kDebugMode) {
        print("Notifications Fetched");
      }
    } catch (e) {
      status.value = NotificationsStatus.FAILURE;
      if (kDebugMode) {
        print("Error loading notifications: $e");
      }
    }
  }

  Future<void> fetchCategoriesListEvent(
      Rx<CategoriesStatus> status,
      RxList<CategoryModel> categoriesList,
      ) async {
    try {
      status.value = CategoriesStatus.LOADING;
      String jsonString = await rootBundle.loadString(jsonCategories);

      List<dynamic> jsonData = json.decode(jsonString);
      List<CategoryModel> value =
      jsonData.map((item) => CategoryModel.fromJson(item)).toList();

      categoriesList.assignAll(value);
      status.value = CategoriesStatus.SUCCESS;
      if (kDebugMode) {
        print("Categories Fetched");
      }
    } catch (e) {
      status.value = CategoriesStatus.FAILURE;
      if (kDebugMode) {
        print("Error loading categories: $e");
      }
    }
  }


}