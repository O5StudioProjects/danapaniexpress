import 'dart:async';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/packages_import.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/ui/app_common/dialogs/bool_dialog.dart';

class DashBoardController extends GetxController {
  final dashboardRepo = DashboardRepository();
  final productRepo = ProductRepository();
  final home = Get.find<HomeController>();
  final navigation = Get.find<NavigationController>();
  final categories = Get.find<CategoriesController>();

  // Bottom nav
  RxInt navIndex = 0.obs;

  /// FLOATING DYNAMIC AVATARS/ICONS
  RxBool floatingAvatarIcon = true.obs;



  /// ALL PRODUCTS AND TYPES SECTION

  // Status
  Rx<ProductsStatus> allStatus = ProductsStatus.IDLE.obs;
  Rx<ProductsStatus> featuredStatus = ProductsStatus.IDLE.obs;
  Rx<ProductsStatus> flashSaleStatus = ProductsStatus.IDLE.obs;
  Rx<ProductsStatus> popularStatus = ProductsStatus.IDLE.obs;

  // Lists
  RxList<ProductModel> allProducts = <ProductModel>[].obs;
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  RxList<ProductModel> flashSaleProducts = <ProductModel>[].obs;
  RxList<ProductModel> popularProducts = <ProductModel>[].obs;

  RxBool isLoadingMore = false.obs;
  RxBool hasMoreFeatured = true.obs;
  RxBool hasMoreFlashSale = true.obs;
  RxBool hasMoreAllProducts = true.obs;

  //Offsets
  int _featuredOffset = 0;
  int _flashSaleOffset = 0;
  int _allOffset = 0;

  // Limits
  final int popularLimit = 10;
  int currentPopularPage = 1;

  int _allLimit = 20;
  int _featuredLimit = 20;
  int _flashSaleLimit = 20;

  // Loading Flags
  bool _isLoadingAll = false;
  bool _isLoadingFeatured = false;
  bool _isLoadingFlashSale = false;

  // Init
  @override
  void onInit() {
    super.onInit();
    navIndex.value = 0;
    startupMethods();

  }

  void startupMethods() async {
    // home.fetchAppbarPagerImages();
    // home.fetchMarquee();
    // home.fetchCoverImages();
   // home.fetchCategories(); // Categories Left
   //  home.fetchBodyPagerImages();
   // fetchAllProductLists(); // Left
    // home.fetchSingleBanners();
  }

  // Bottom nav change
  void onBottomNavItemTap(int index) {
    navIndex.value = index;
  }


  /// INITIAL FETCH
  Future<void> fetchPopularProductsInitial() async {
    popularStatus.value = ProductsStatus.LOADING;
    currentPopularPage = 1;
    hasMoreAllProducts.value = true;

    try {
      final result = await dashboardRepo.getPopularProductsPaginated(
        page: currentPopularPage,
        limit: popularLimit,
      );
      popularProducts.assignAll(result.products);
      hasMoreAllProducts.value = popularProducts.length < result.totalCount;
      currentPopularPage++;
      popularStatus.value = ProductsStatus.SUCCESS;
    } catch (e) {
      popularStatus.value = ProductsStatus.FAILURE;
      showSnackbar(isError: true, title: "Error", message: e.toString());
    }
  }

  /// LOAD MORE
  Future<void> fetchMorePopularProducts() async {
    if (isLoadingMore.value || !hasMoreAllProducts.value) return;

    isLoadingMore.value = true;

    try {
      final result = await dashboardRepo.getPopularProductsPaginated(
        page: currentPopularPage,
        limit: popularLimit,
      );
      popularProducts.addAll(result.products);

      if (popularProducts.length >= result.totalCount) {
        hasMoreAllProducts.value = false;
      } else {
        currentPopularPage++;
      }
    } catch (e) {
      showSnackbar(isError: true, title: "Error", message: e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }




  ///CATEGORIES SECTION METHODS







  ///ON BACK PRESS MAIN DASHBOARD

  Future<void> onDashboardBackPress() async {
    if(navIndex.value > 0){
      navIndex.value = 0;
    } else {
      showCustomDialog(gContext, AppBoolDialog(
        title: AppLanguage.quitStr(appLanguage).toString(),
        detail: AppLanguage.doYouWantToCloseAppStr(appLanguage).toString(),
        onTapConfirm: (){
        SystemNavigator.pop();
      }, iconType: IconType.ICON, icon: Icons.exit_to_app_rounded,));
    }
  }

  Future<void> onTapTopNotificationDialog(MarqueeModel data) async {
    if (data.marqueeType == MarqueeType.FEATURED) {
      navigation.gotoOtherProductsScreen(
        screenType: ProductsScreenType.FEATURED,
      );
    } else if (data.marqueeType == MarqueeType.FLASH_SALE) {
      navigation.gotoOtherProductsScreen(
        screenType: ProductsScreenType.FLASHSALE,
      );
    } else if (data.marqueeType == MarqueeType.POPULAR) {
      navigation.gotoOtherProductsScreen(
        screenType: ProductsScreenType.POPULAR,
      );
    }
  }


  /// OTHER PRODUCTS SECTION - Necessary on Dashboard



  // ✅ Featured
  Future<void> fetchFeaturedProducts({bool loadMore = false}) async {
    if (_isLoadingFeatured || isLoadingMore.value || !hasMoreFeatured.value) {
      return;
    }

    if (loadMore) {
      isLoadingMore.value = true;
      await Future.delayed(Duration(seconds: 1));
    } else {
      featuredProducts.clear();
      _featuredOffset = 0;
      hasMoreFeatured.value = true;
    }

    _isLoadingFeatured = true;
    featuredStatus.value = ProductsStatus.LOADING;

    try {
      final result = await productRepo.fetchProductsListEvent(
        filterType: ProductFilterType.featured,
        limit: _featuredLimit,
        offset: _featuredOffset,
      );

      if (loadMore) {
        featuredProducts.addAll(result);
      } else {
        featuredProducts.assignAll(result);
      }

      if (result.length < _featuredLimit) {
        hasMoreFeatured.value = false;
      } else {
        _featuredOffset += _featuredLimit;
      }

      featuredStatus.value = ProductsStatus.SUCCESS;
    } catch (e) {
      featuredStatus.value = ProductsStatus.FAILURE;
    }

    isLoadingMore.value = false;
    _isLoadingFeatured = false;
  }

  // ✅ Flash Sale
  Future<void> fetchFlashSaleProducts({bool loadMore = false}) async {
    if (_isLoadingFlashSale || isLoadingMore.value || !hasMoreFlashSale.value) {
      return;
    }

    if (loadMore) {
      isLoadingMore.value = true;
      await Future.delayed(Duration(seconds: 1));
    } else {
      flashSaleProducts.clear();
      _flashSaleOffset = 0;
      hasMoreFlashSale.value = true;
    }

    _isLoadingFlashSale = true;
    flashSaleStatus.value = ProductsStatus.LOADING;

    try {
      final result = await productRepo.fetchProductsListEvent(
        filterType: ProductFilterType.flashSale,
        limit: _flashSaleLimit,
        offset: _flashSaleOffset,
      );

      if (loadMore) {
        flashSaleProducts.addAll(result);
      } else {
        flashSaleProducts.assignAll(result);
      }

      if (result.length < _flashSaleLimit) {
        hasMoreFlashSale.value = false;
      } else {
        _flashSaleOffset += _flashSaleLimit;
      }

      flashSaleStatus.value = ProductsStatus.SUCCESS;
    } catch (e) {
      flashSaleStatus.value = ProductsStatus.FAILURE;
    }

    isLoadingMore.value = false;
    _isLoadingFlashSale = false;
  }

  // ✅ Build Popular List from All Products
  void _generatePopularProducts() {
    popularStatus.value = ProductsStatus.LOADING;

    try {
      final sorted = List<ProductModel>.from(allProducts)
        ..sort((a, b) {
          final aAvailable = a.productAvailability ?? false;
          final bAvailable = b.productAvailability ?? false;

          if (aAvailable != bAvailable) {
            return bAvailable ? 1 : -1;
          }

          return (b.productTotalSold ?? 0).compareTo(a.productTotalSold ?? 0);
        });

      popularProducts.assignAll(sorted);
      popularStatus.value = ProductsStatus.SUCCESS;
    } catch (e) {
      popularStatus.value = ProductsStatus.FAILURE;
    }
  }



}
