import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/controllers/product_controller/products_controller.dart';

class OtherProductsController extends GetxController {
  final products = Get.find<ProductsController>();
  Rx<ProductsScreenType> productScreenType = ProductsScreenType.CATEGORIES.obs;
  final scrollController = ScrollController();
  RxBool showBottomMessage = true.obs;
  RxBool reachedEndOfScroll = false.obs;

  double _previousOffset = 0;


  final RxBool showTopHeader = true.obs;
  double _lastHeaderVisibilityOffset = 0.0;


  void initScrollListener(DashBoardController dashboardController) {
    scrollController.addListener(() {
      final currentOffset = scrollController.position.pixels;
      final maxOffset = scrollController.position.maxScrollExtent;

      // ✅ Show/hide bottom message
      if (currentOffset > _previousOffset) {
        showBottomMessage.value = true;
      } else {
        showBottomMessage.value = false;
      }

      // ✅ Show Top Header when scrolling up OR at the top
      if (currentOffset <= 0) {
        // At the very top of the list
        if (!showTopHeader.value) showTopHeader.value = true;
      } else if (currentOffset > _lastHeaderVisibilityOffset + 10) {
        // Scrolling down
        if (showTopHeader.value) showTopHeader.value = false;
      } else if (currentOffset < _lastHeaderVisibilityOffset - 10) {
        // Scrolling up
        if (!showTopHeader.value) showTopHeader.value = true;
      }

      _lastHeaderVisibilityOffset = currentOffset;
      _previousOffset = currentOffset;

      // ✅ Reached end of scroll
      reachedEndOfScroll.value = currentOffset >= maxOffset - 10;

      // ✅ Load more
      if (currentOffset >= maxOffset - 300) {
        if(productScreenType.value == ProductsScreenType.POPULAR){
          products.loadMorePopularProducts();
        } else if(productScreenType.value == ProductsScreenType.FEATURED){
          products.loadMoreFeaturedProducts();
        } else if(productScreenType.value == ProductsScreenType.FLASHSALE){
          products.loadMoreFlashSaleProducts();
        }

       // _loadMoreProducts(dashboardController);
      }
    });
  }


  @override
  void onInit() {
    productScreenType.value = Get.arguments[PRODUCT_SCREEN_TYPE] as ProductsScreenType;

    print(productScreenType.value);
    initScrollListener(Get.find<DashBoardController>());
    super.onInit();
  }




}