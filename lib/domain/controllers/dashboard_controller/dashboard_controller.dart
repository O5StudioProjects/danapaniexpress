import 'dart:async';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import '../../../data/repositories/dashboard_repository/dashboard_repository.dart';

class DashBoardController extends GetxController {
  final dashboardRepo = DashboardRepository();
  final navigation = Get.find<NavigationController>();

  // Bottom nav
  RxInt navIndex = 0.obs;

  ///HOME SCREEN

  // AppBar Slider
  RxList<PagerImagesModel> appbarPagerList = <PagerImagesModel>[].obs;
  Rx<AppbarPagerImagesStatus> appbarPagerStatus =
      AppbarPagerImagesStatus.IDLE.obs;

  // MARQUEE
  Rx<MarqueeModel?> marqueeData = Rx<MarqueeModel?>(null);
  Rx<MarqueeStatus> marqueeStatus = MarqueeStatus.IDLE.obs;

  // Categories
  RxList<CategoryModel> categoriesList = <CategoryModel>[].obs;
  Rx<CategoriesStatus> categoriesStatus = CategoriesStatus.IDLE.obs;

  // Single category
  Rx<CategoryModel?> singleCategory = Rx<CategoryModel?>(null);
  Rx<CategoriesStatus> singleCategoryStatus = CategoriesStatus.IDLE.obs;

  // Single Product
  Rx<ProductsModel?> singleProduct = Rx<ProductsModel?>(null);

  // Body Pager Slider
  RxList<PagerImagesModel> bodyPagerList = <PagerImagesModel>[].obs;
  Rx<BodyPagerImagesStatus> bodyPagerStatus = BodyPagerImagesStatus.IDLE.obs;
  final CarouselSliderController bodyPagerController =
      CarouselSliderController();
  final RxInt currentSlide = 0.obs;

  // Status
  Rx<ProductsStatus> allStatus = ProductsStatus.IDLE.obs;
  Rx<ProductsStatus> featuredStatus = ProductsStatus.IDLE.obs;
  Rx<ProductsStatus> flashSaleStatus = ProductsStatus.IDLE.obs;
  Rx<ProductsStatus> popularStatus = ProductsStatus.IDLE.obs;

  // Lists
  RxList<ProductsModel> allProducts = <ProductsModel>[].obs;
  RxList<ProductsModel> featuredProducts = <ProductsModel>[].obs;
  RxList<ProductsModel> flashSaleProducts = <ProductsModel>[].obs;
  RxList<ProductsModel> popularProducts = <ProductsModel>[].obs;

  RxBool isLoadingMore = false.obs;
  RxBool hasMoreFeatured = true.obs;
  RxBool hasMoreFlashSale = true.obs;
  RxBool hasMoreAllProducts = true.obs;

  //Offsets
  int _featuredOffset = 0;
  int _flashSaleOffset = 0;
  int _allOffset = 0;

  // Limits
  int _allLimit = 20;
  int _featuredLimit = 20;
  int _flashSaleLimit = 20;

  // Loading Flags
  bool _isLoadingAll = false;
  bool _isLoadingFeatured = false;
  bool _isLoadingFlashSale = false;

  // SINGLE BANNER ON HOME SCREEN
  Rx<PagerImagesModel?> singleBannerOne = Rx<PagerImagesModel?>(null);
  Rx<SingleBannerOneStatus> singleBannerOneStatus =
      SingleBannerOneStatus.IDLE.obs;

  Rx<PagerImagesModel?> singleBannerTwo = Rx<PagerImagesModel?>(null);
  Rx<SingleBannerTwoStatus> singleBannerTwoStatus =
      SingleBannerTwoStatus.IDLE.obs;

  /// CATEGORIES SECTION

  RxInt categoryIndex = 0.obs;

  var navigationController = Get.find<NavigationController>();

  // Init
  @override
  void onInit() {
    super.onInit();
    fetchAppbarPagerImages();
    fetchMarquee();
    fetchCategories();
    fetchBodyPagerImages();
    fetchAllProductLists();
    fetchSingleBannerOne();
    fetchSingleBannerTwo();
  }

  // Bottom nav change
  void onBottomNavItemTap(int index) {
    navIndex.value = index;
  }

  // Fetch AppBar slider images
  Future<void> fetchAppbarPagerImages() async {
    await dashboardRepo.fetchAppbarPagerImagesListEvent(
      appbarPagerStatus,
      appbarPagerList,
    );
  }

  // Fetch Notifications
  Future<void> fetchMarquee() async {
    await dashboardRepo.fetchMarqueeEvent(marqueeStatus, marqueeData);
  }

  // Fetch Categories
  Future<void> fetchCategories() async {
    await dashboardRepo.fetchCategoriesListEvent(
      categoriesStatus,
      categoriesList,
    );
  }

  Future<void> fetchCategoryById(String id) async {
    dashboardRepo.fetchSingleCategoryEvent(
      categoryId: id,
      categoryData: singleCategory,
      status: singleCategoryStatus,
    );
  }

  Future<void> getSingleProduct(String id) async {
    singleProduct.value = await dashboardRepo.fetchSingleProductById(id);
  }

  // Fetch Body Slider
  Future<void> fetchBodyPagerImages() async {
    await dashboardRepo.fetchBodyPagerImagesListEvent(
      bodyPagerStatus,
      bodyPagerList,
    );
  }

  // SIGNLE BANNER HOME
  Future<void> fetchSingleBannerOne() async {
    await dashboardRepo.fetchSingleBannerOneEvent(
      singleBannerOneStatus,
      singleBannerOne,
    );
  }

  Future<void> fetchSingleBannerTwo() async {
    await dashboardRepo.fetchSingleBannerTwoEvent(
      singleBannerTwoStatus,
      singleBannerTwo,
    );
  }

  // ✅ Fetch All Lists at Once
  Future<void> fetchAllProductLists() async {
    await Future.wait([
      fetchAllProducts(),
      fetchFeaturedProducts(),
      fetchFlashSaleProducts(),
    ]);
    _generatePopularProducts();
  }

  // ✅ All Products (used to build popular)
  Future<void> fetchAllProducts({bool loadMore = false}) async {
    if (_isLoadingAll || isLoadingMore.value || !hasMoreAllProducts.value)
      return;

    if (loadMore) {
      isLoadingMore.value = true;
      await Future.delayed(Duration(seconds: 1));
    } else {
      allProducts.clear();
      _allOffset = 0;
      hasMoreAllProducts.value = true;
    }

    _isLoadingAll = true;
    allStatus.value = ProductsStatus.LOADING;

    try {
      final result = await dashboardRepo.fetchProductsListEvent(
        filterType: ProductFilterType.all,
        limit: _allLimit,
        offset: _allOffset,
      );

      if (loadMore) {
        allProducts.addAll(result);
      } else {
        allProducts.assignAll(result);
      }

      if (result.length < _allLimit) {
        hasMoreAllProducts.value = false;
      } else {
        _allOffset += _allLimit;
      }

      allStatus.value = ProductsStatus.SUCCESS;
      _generatePopularProducts(); // always regenerate
    } catch (e) {
      allStatus.value = ProductsStatus.FAILURE;
    }

    isLoadingMore.value = false;
    _isLoadingAll = false;
  }

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
      final result = await dashboardRepo.fetchProductsListEvent(
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
    if (_isLoadingFlashSale || isLoadingMore.value || !hasMoreFlashSale.value)
      return;

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
      final result = await dashboardRepo.fetchProductsListEvent(
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
      final sorted = List<ProductsModel>.from(allProducts)
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

  ///CATEGORIES SECTION METHODS

  Future<void> onTapCategories(int index) async {
    categoryIndex.value = index;
  }

  Future<void> onTapSubCategories(int index, CategoryModel categoryData) async {
    navigationController.gotoProductsScreen(
      data: categoryData,
      subCategoryIndex: index,
    );
  }

  /// ON TAP METHODS ON HOME SCREEN

  Future<void> onTapAppbarImagePager({index}) async {
    if (appbarPagerList[index].type == ImagePagerType.FEATURED) {
      navigation.gotoOtherProductsScreen(
        screenType: ProductsScreenType.FEATURED,
      );
    } else if (appbarPagerList[index].type == ImagePagerType.FLASH_SALE) {
      navigation.gotoOtherProductsScreen(
        screenType: ProductsScreenType.FLASHSALE,
      );
    } else if (appbarPagerList[index].type == ImagePagerType.POPULAR) {
      navigation.gotoOtherProductsScreen(
        screenType: ProductsScreenType.POPULAR,
      );
    } else if (appbarPagerList[index].type == ImagePagerType.CATEGORY) {
      await fetchCategoryById(appbarPagerList[index].typeId.toString())
          .then((value) {
            navigation.gotoProductsScreen(data: singleCategory.value!);
          })
          .onError((handleError, str) {
            if (kDebugMode) {
              print(str);
            }
            return;
          });
    } else if (appbarPagerList[index].type == ImagePagerType.PRODUCT) {
      await getSingleProduct(appbarPagerList[index].typeId.toString())
          .then((value) {
            navigation.gotoProductDetailScreen(data: singleProduct.value!);
          })
          .onError((handleError, str) {
            if (kDebugMode) {
              print(str);
            }
            return;
          });
    }
  }

  Future<void> onTapBodyPager({index}) async {
    if (bodyPagerList[index].type == ImagePagerType.FEATURED) {
      navigation.gotoOtherProductsScreen(
        screenType: ProductsScreenType.FEATURED,
      );
    } else if (bodyPagerList[index].type == ImagePagerType.FLASH_SALE) {
      navigation.gotoOtherProductsScreen(
        screenType: ProductsScreenType.FLASHSALE,
      );
    } else if (bodyPagerList[index].type == ImagePagerType.POPULAR) {
      navigation.gotoOtherProductsScreen(
        screenType: ProductsScreenType.POPULAR,
      );
    } else if (bodyPagerList[index].type == ImagePagerType.CATEGORY) {
      await fetchCategoryById(bodyPagerList[index].typeId.toString())
          .then((value) {
            navigation.gotoProductsScreen(data: singleCategory.value!);
          })
          .onError((handleError, str) {
            if (kDebugMode) {
              print(str);
            }
            return;
          });
    } else if (bodyPagerList[index].type == ImagePagerType.PRODUCT) {
      await getSingleProduct(bodyPagerList[index].typeId.toString())
          .then((value) {
            navigation.gotoProductDetailScreen(data: singleProduct.value!);
          })
          .onError((handleError, str) {
            if (kDebugMode) {
              print(str);
            }
            return;
          });
    }
  }

  Future<void> onTapSingleBanners({
    required HomeSingleBanner singleBanner,
  }) async {
    if (singleBanner == HomeSingleBanner.ONE) {
      if (singleBannerOne.value!.type == ImagePagerType.FEATURED) {
        navigation.gotoOtherProductsScreen(
          screenType: ProductsScreenType.FEATURED,
        );
      } else if (singleBannerOne.value!.type == ImagePagerType.FLASH_SALE) {
        navigation.gotoOtherProductsScreen(
          screenType: ProductsScreenType.FLASHSALE,
        );
      } else if (singleBannerOne.value!.type == ImagePagerType.POPULAR) {
        navigation.gotoOtherProductsScreen(
          screenType: ProductsScreenType.POPULAR,
        );
      } else if (singleBannerOne.value!.type == ImagePagerType.CATEGORY) {
        await fetchCategoryById(singleBannerOne.value!.typeId.toString())
            .then((value) {
              navigation.gotoProductsScreen(data: singleCategory.value!);
            })
            .onError((handleError, str) {
              if (kDebugMode) {
                print(str);
              }
              return;
            });
      } else if (singleBannerOne.value!.type == ImagePagerType.PRODUCT) {
        await getSingleProduct(singleBannerOne.value!.typeId.toString())
            .then((value) {
              navigation.gotoProductDetailScreen(data: singleProduct.value!);
            })
            .onError((handleError, str) {
              if (kDebugMode) {
                print(str);
              }
              return;
            });
      }
    } else if (singleBanner == HomeSingleBanner.TWO) {
      if (singleBannerTwo.value!.type == ImagePagerType.FEATURED) {
        navigation.gotoOtherProductsScreen(
          screenType: ProductsScreenType.FEATURED,
        );
      } else if (singleBannerTwo.value!.type == ImagePagerType.FLASH_SALE) {
        navigation.gotoOtherProductsScreen(
          screenType: ProductsScreenType.FLASHSALE,
        );
      } else if (singleBannerTwo.value!.type == ImagePagerType.POPULAR) {
        navigation.gotoOtherProductsScreen(
          screenType: ProductsScreenType.POPULAR,
        );
      } else if (singleBannerTwo.value!.type == ImagePagerType.CATEGORY) {
        await fetchCategoryById(singleBannerTwo.value!.typeId.toString())
            .then((value) {
              navigation.gotoProductsScreen(data: singleCategory.value!);
            })
            .onError((handleError, str) {
              if (kDebugMode) {
                print(str);
              }
              return;
            });
      } else if (singleBannerTwo.value!.type == ImagePagerType.PRODUCT) {
        await getSingleProduct(singleBannerTwo.value!.typeId.toString())
            .then((value) {
              navigation.gotoProductDetailScreen(data: singleProduct.value!);
            })
            .onError((handleError, str) {
              if (kDebugMode) {
                print(str);
              }
              return;
            });
      }
    }
  }


  ///ON BACK PRESS MAIN DASHBOARD

  Future<void> onDashboardBackPress() async {
    if(navIndex.value > 0){
      navIndex.value = 0;
    } else {

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




}
