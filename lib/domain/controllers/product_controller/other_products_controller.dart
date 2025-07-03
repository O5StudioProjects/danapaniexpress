import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/data/repositories/dashboard_repository/dashboard_repository.dart';

import '../../../core/data_model_imports.dart';

class OtherProductsController extends GetxController {

  var dashboardRepo = DashboardRepository();
  final dashBoardController = Get.find<DashBoardController>();
  Rx<ProductsScreenType> productScreenType = ProductsScreenType.CATEGORIES.obs;
  final scrollController = ScrollController();
  RxBool showBottomMessage = true.obs;
  RxBool reachedEndOfScroll = false.obs;

  double _previousOffset = 0;


  void initScrollListener(DashBoardController dashboardController) {
    scrollController.addListener(() {
      final currentOffset = scrollController.position.pixels;
      final maxOffset = scrollController.position.maxScrollExtent;

      // Show/hide based on scroll direction
      if (currentOffset > _previousOffset) {
        showBottomMessage.value = true;
      } else {
        showBottomMessage.value = false;
      }

      _previousOffset = currentOffset;

      // ✅ Set end of scroll state
      reachedEndOfScroll.value = currentOffset >= maxOffset - 10;

      // ✅ Trigger load more
      if (currentOffset >= maxOffset - 300) {
        _loadMoreProducts(dashboardController);
      }
    });
  }


  void _loadMoreProducts(DashBoardController dashboardController) {
    final screenType = productScreenType.value;

    if (screenType == ProductsScreenType.FEATURED) {
      if (!dashboardController.isLoadingMore.value &&
          dashboardController.hasMoreFeatured.value) {
        dashboardController.fetchFeaturedProducts(loadMore: true);
      }
    } else if (screenType == ProductsScreenType.FLASHSALE) {
      if (!dashboardController.isLoadingMore.value &&
          dashboardController.hasMoreFlashSale.value) {
        dashboardController.fetchFlashSaleProducts(loadMore: true);
      }
    } else if (screenType == ProductsScreenType.POPULAR) {
      if (!dashboardController.isLoadingMore.value &&
          dashboardController.hasMoreAllProducts.value) {
        dashboardController.fetchAllProducts(loadMore: true);
      }
    }
  }

  @override
  void onInit() {
    productScreenType.value = Get.arguments[PRODUCT_SCREEN_TYPE] as ProductsScreenType;

    print(productScreenType.value);
    super.onInit();
  }



}