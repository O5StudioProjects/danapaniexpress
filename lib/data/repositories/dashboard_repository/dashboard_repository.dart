import 'dart:convert';

import 'package:danapaniexpress/core/common_imports.dart';

import '../../models/slider_image_model.dart';

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
    } catch (e) {
      status.value = AppbarSliderImagesStatus.FAILURE;
      print("Error loading slider images: $e");
    }
  }
}