import 'dart:convert';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/data/repositories/dashboard_repository/dashbboard_datasource.dart';

class DashboardRepository extends DashboardDataSource{


  /// GET PAGERS DATA - ASSETS

  // Future<void> fetchAppbarPagerImagesListEvent(
  //   Rx<AppbarPagerImagesStatus> status,
  //   RxList<PagerImagesModel> sliderList,
  // ) async {
  //   try {
  //     status.value = AppbarPagerImagesStatus.LOADING;
  //     String jsonString = await rootBundle.loadString(jsonAppbarPager);
  //
  //     List<dynamic> jsonData = json.decode(jsonString);
  //     List<PagerImagesModel> value = jsonData
  //         .map((item) => PagerImagesModel.fromJson(item))
  //         .toList();
  //
  //     sliderList.assignAll(value);
  //     status.value = AppbarPagerImagesStatus.SUCCESS;
  //     if (kDebugMode) {
  //       print("Appbar Pager Images Fetched");
  //     }
  //   } catch (e) {
  //     status.value = AppbarPagerImagesStatus.FAILURE;
  //     if (kDebugMode) {
  //       print("Error loading Appbar Pager images: $e");
  //     }
  //   }
  // }

  // /// FETCH MARQUEE
  // Future<void> fetchMarqueeEvent(
  //     Rx<MarqueeStatus> status,
  //     Rx<MarqueeModel?> marquee,
  //     ) async {
  //   try {
  //     status.value = MarqueeStatus.LOADING;
  //
  //     // Load and decode JSON
  //     String jsonString = await rootBundle.loadString(jsonMarquee); // Update with your actual path
  //     Map<String, dynamic> jsonData = json.decode(jsonString);
  //
  //     // Convert to model
  //     MarqueeModel model = MarqueeModel.fromJson(jsonData);
  //     marquee.value = model;
  //
  //     status.value = MarqueeStatus.SUCCESS;
  //
  //     if (kDebugMode) {
  //       print("Marquee Fetched: ${model.marqueeTitleEnglish}");
  //     }
  //   } catch (e) {
  //     status.value = MarqueeStatus.FAILURE;
  //     if (kDebugMode) {
  //       print("Error loading marquee: $e");
  //     }
  //   }
  // }
  //
  Future<void> fetchCoverImagesEvent(
      Rx<CoverImagesStatus> status,
      Rx<CoverImagesModel?> covers,
      ) async {
    try {
      status.value = CoverImagesStatus.LOADING;

      // Load and decode JSON
      String jsonString = await rootBundle.loadString(jsonCoverImages); // Update with your actual path
      Map<String, dynamic> jsonData = json.decode(jsonString);

      // Convert to model
      CoverImagesModel model = CoverImagesModel.fromJson(jsonData);
      covers.value = model;

      status.value = CoverImagesStatus.SUCCESS;

      if (kDebugMode) {
        print("Cover Images Fetched: ${model}");
      }
    } catch (e) {
      status.value = CoverImagesStatus.FAILURE;
      if (kDebugMode) {
        print("Error loading Cover Images: $e");
      }
    }
  }
  //
  //
  //
  //
  //
  // Future<void> fetchBodyPagerImagesListEvent(
  //   Rx<BodyPagerImagesStatus> bodyPagerStatus,
  //   RxList<PagerImagesModel> bodyPagerList,
  // ) async {
  //   try {
  //     bodyPagerStatus.value = BodyPagerImagesStatus.LOADING;
  //     String jsonString = await rootBundle.loadString(jsonBodyPager);
  //
  //     List<dynamic> jsonData = json.decode(jsonString);
  //     List<PagerImagesModel> value =
  //     jsonData.map((item) => PagerImagesModel.fromJson(item)).toList();
  //
  //     bodyPagerList.assignAll(value);
  //     bodyPagerStatus.value = BodyPagerImagesStatus.SUCCESS;
  //     if (kDebugMode) {
  //       print("Body Pager Images Fetched");
  //     }
  //   } catch (e) {
  //     bodyPagerStatus.value = BodyPagerImagesStatus.FAILURE;
  //     if (kDebugMode) {
  //       print("Error loading Body Pager images: $e");
  //     }
  //   }
  // }



  // /// SINGLE BANNER ON HOME
  // Future<void> fetchSingleBannerOneEvent(
  //     Rx<SingleBannerOneStatus> status,
  //     Rx<PagerImagesModel?> singleBanner,
  //     ) async {
  //   try {
  //     status.value = SingleBannerOneStatus.LOADING;
  //
  //     String jsonString = await rootBundle.loadString(jsonSingleBannerHomeOne);
  //     Map<String, dynamic> jsonData = json.decode(jsonString);
  //
  //     PagerImagesModel model = PagerImagesModel.fromJson(jsonData);
  //     singleBanner.value = model;
  //
  //     status.value = SingleBannerOneStatus.SUCCESS;
  //     if (kDebugMode) {
  //       print("Single Banner Fetched: ${model.imageUrl}");
  //     }
  //   } catch (e) {
  //     status.value = SingleBannerOneStatus.FAILURE;
  //     if (kDebugMode) {
  //       print("Error loading single banner: $e");
  //     }
  //   }
  // }
  //
  // Future<void> fetchSingleBannerTwoEvent(
  //     Rx<SingleBannerTwoStatus> status,
  //     Rx<PagerImagesModel?> singleBanner,
  //     ) async {
  //   try {
  //     status.value = SingleBannerTwoStatus.LOADING;
  //
  //     String jsonString = await rootBundle.loadString(jsonSingleBannerHomeTwo);
  //     Map<String, dynamic> jsonData = json.decode(jsonString);
  //
  //     PagerImagesModel model = PagerImagesModel.fromJson(jsonData);
  //     singleBanner.value = model;
  //
  //     status.value = SingleBannerTwoStatus.SUCCESS;
  //     if (kDebugMode) {
  //       print("Single Banner Fetched: ${model.imageUrl}");
  //     }
  //   } catch (e) {
  //     status.value = SingleBannerTwoStatus.FAILURE;
  //     if (kDebugMode) {
  //       print("Error loading single banner: $e");
  //     }
  //   }
  // }

}
