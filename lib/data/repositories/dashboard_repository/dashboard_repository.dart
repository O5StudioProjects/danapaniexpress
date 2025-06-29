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

  Future<List<ProductsModel>> fetchProductsListEvent({
    required ProductFilterType filterType,
    required int limit,
  }) async {
    String jsonString = await rootBundle.loadString(jsonProducts);
    List<dynamic> jsonData = json.decode(jsonString);

    Iterable filtered = jsonData;

    // Apply filter
    switch (filterType) {
      case ProductFilterType.featured:
        filtered = jsonData.where((item) => item[ProductsFields.productIsFeatured] == true);
        break;
      case ProductFilterType.flashSale:
        filtered = jsonData.where((item) => item[ProductsFields.productIsFlashsale] == true);
        break;
      case ProductFilterType.all:
      case ProductFilterType.popular: // fallback to all for popular
        filtered = jsonData;
        break;
    }

    List<ProductsModel> result = filtered
        .map((item) => ProductsModel.fromJson(item))
        .toList();

    return result.take(limit).toList();
  }


  /// SINGLE BANNER ON HOME
  Future<void> fetchSingleBannerOneEvent(
      Rx<SingleBannerOneStatus> status,
      Rx<PagerImagesModel?> singleBanner,
      ) async {
    try {
      status.value = SingleBannerOneStatus.LOADING;

      String jsonString = await rootBundle.loadString(jsonSingleBannerHomeOne);
      Map<String, dynamic> jsonData = json.decode(jsonString);

      PagerImagesModel model = PagerImagesModel.fromJson(jsonData);
      singleBanner.value = model;

      status.value = SingleBannerOneStatus.SUCCESS;
      if (kDebugMode) {
        print("Single Banner Fetched: ${model.imageUrl}");
      }
    } catch (e) {
      status.value = SingleBannerOneStatus.FAILURE;
      if (kDebugMode) {
        print("Error loading single banner: $e");
      }
    }
  }

  Future<void> fetchSingleBannerTwoEvent(
      Rx<SingleBannerTwoStatus> status,
      Rx<PagerImagesModel?> singleBanner,
      ) async {
    try {
      status.value = SingleBannerTwoStatus.LOADING;

      String jsonString = await rootBundle.loadString(jsonSingleBannerHomeTwo);
      Map<String, dynamic> jsonData = json.decode(jsonString);

      PagerImagesModel model = PagerImagesModel.fromJson(jsonData);
      singleBanner.value = model;

      status.value = SingleBannerTwoStatus.SUCCESS;
      if (kDebugMode) {
        print("Single Banner Fetched: ${model.imageUrl}");
      }
    } catch (e) {
      status.value = SingleBannerTwoStatus.FAILURE;
      if (kDebugMode) {
        print("Error loading single banner: $e");
      }
    }
  }

}
