import 'dart:convert';

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class DashboardRepository {
  Future<void> fetchAppbarPagerImagesListEvent(
    Rx<AppbarPagerImagesStatus> status,
    RxList<PagerImagesModel> sliderList,
  ) async {
    try {
      status.value = AppbarPagerImagesStatus.LOADING;
      String jsonString = await rootBundle.loadString(jsonAppbarPager);

      List<dynamic> jsonData = json.decode(jsonString);
      List<PagerImagesModel> value = jsonData
          .map((item) => PagerImagesModel.fromJson(item))
          .toList();

      sliderList.assignAll(value);
      status.value = AppbarPagerImagesStatus.SUCCESS;
      if (kDebugMode) {
        print("Appbar Pager Images Fetched");
      }
    } catch (e) {
      status.value = AppbarPagerImagesStatus.FAILURE;
      if (kDebugMode) {
        print("Error loading Appbar Pager images: $e");
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
      List<NotificationModel> value = jsonData
          .map((item) => NotificationModel.fromJson(item))
          .toList();

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
      List<CategoryModel> value = jsonData
          .map((item) => CategoryModel.fromJson(item))
          .toList();

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

  Future<void> fetchBodyPagerImagesListEvent(
    Rx<BodyPagerImagesStatus> bodyPagerStatus,
    RxList<PagerImagesModel> bodyPagerList,
  ) async {
    try {
      bodyPagerStatus.value = BodyPagerImagesStatus.LOADING;
      String jsonString = await rootBundle.loadString(jsonBodyPager);

      List<dynamic> jsonData = json.decode(jsonString);
      List<PagerImagesModel> value =
      jsonData.map((item) => PagerImagesModel.fromJson(item)).toList();

      bodyPagerList.assignAll(value);
      bodyPagerStatus.value = BodyPagerImagesStatus.SUCCESS;
      if (kDebugMode) {
        print("Body Pager Images Fetched");
      }
    } catch (e) {
      bodyPagerStatus.value = BodyPagerImagesStatus.FAILURE;
      if (kDebugMode) {
        print("Error loading Body Pager images: $e");
      }
    }
  }


  Future<void> fetchProductsListEvent(
      Rx<ProductsStatus> status,
      RxList<ProductsModel> productsList, {
        int limit = 20,
      }) async {
    try {
      status.value = ProductsStatus.LOADING;
      String jsonString = await rootBundle.loadString(jsonProducts);
      List<dynamic> jsonData = json.decode(jsonString);

      List<ProductsModel> result = jsonData
          .map((item) => ProductsModel.fromJson(item))
          .take(limit)
          .toList();

      productsList.assignAll(result);
      status.value = ProductsStatus.SUCCESS;

      if (kDebugMode) {
        print("Fetched $limit products");
      }
    } catch (e) {
      status.value = ProductsStatus.FAILURE;
      if (kDebugMode) {
        print("Error loading products: $e");
      }
    }
  }



}
