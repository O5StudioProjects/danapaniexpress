

import 'package:danapaniexpress/core/common_imports.dart';
import '../../../data/models/slider_image_model.dart';
import '../../../data/repositories/dashboard_repository/dashboard_repository.dart';

class DashBoardController extends GetxController {
  RxDouble appBarHeight = 0.0.obs;

  RxInt navIndex = 0.obs;
  RxList<SliderImagesModel> sliderList = <SliderImagesModel>[].obs;
  Rx<AppbarSliderImagesStatus> sliderStatus = AppbarSliderImagesStatus.IDLE.obs;

  final dashboardRepo = DashboardRepository();

  @override
  void onInit() {
    super.onInit();
    fetchSliderImages();
  }

  onBottomNavItemTap(index){
    navIndex.value = index;
  }

  Future<void> fetchSliderImages() async {
    await dashboardRepo.fetchSliderImagesListEvent(sliderStatus, sliderList);
  }

}