import 'dart:async';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/packages_import.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/ui/app_common/dialogs/bool_dialog.dart';

class DashBoardController extends GetxController {
  final dashboardRepo = DashboardRepository();
  final productRepo = ProductRepository();
  final navigation = Get.find<NavigationController>();
  final categories = Get.find<CategoriesController>();

  // Bottom nav
  RxInt navIndex = 0.obs;

  /// FLOATING DYNAMIC AVATARS/ICONS
  RxBool floatingAvatarIcon = true.obs;

  ///HOME SCREEN

  // AppBar Slider
  RxList<PagerImagesModel> appbarPagerList = <PagerImagesModel>[].obs;
  Rx<AppbarPagerImagesStatus> appbarPagerStatus =
      AppbarPagerImagesStatus.IDLE.obs;

  // MARQUEE
  Rx<MarqueeModel?> marqueeData = Rx<MarqueeModel?>(null);
  Rx<MarqueeStatus> marqueeStatus = MarqueeStatus.IDLE.obs;

  // COVER IMAGES
  Rx<CoverImagesModel?> coverImages = Rx<CoverImagesModel?>(null);
  Rx<CoverImagesStatus> coverImagesStatus = CoverImagesStatus.IDLE.obs;


  // Single Product
  Rx<ProductModel?> singleProduct = Rx<ProductModel?>(null);

  // Body Pager Slider
  RxList<PagerImagesModel> bodyPagerList = <PagerImagesModel>[].obs;
  Rx<BodyPagerImagesStatus> bodyPagerStatus = BodyPagerImagesStatus.IDLE.obs;
  final CarouselSliderController bodyPagerController =
      CarouselSliderController();
  final RxInt currentSlide = 0.obs;


  Rx<PagerImagesModel?> singleBannerOne = Rx<PagerImagesModel?>(null);
  Rx<SingleBannerOneStatus> singleBannerOneStatus =
      SingleBannerOneStatus.IDLE.obs;

  Rx<PagerImagesModel?> singleBannerTwo = Rx<PagerImagesModel?>(null);
  Rx<SingleBannerTwoStatus> singleBannerTwoStatus =
      SingleBannerTwoStatus.IDLE.obs;

  /// CATEGORIES SECTION

  RxInt categoryIndex = 0.obs;

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
    fetchAppbarPagerImages();
    fetchMarquee();
    fetchCoverImages();
    categories.fetchCategories(); // Categories Left
    fetchBodyPagerImages();
    fetchAllProductLists(); // Left
    fetchSingleBanners();
  }

  // Bottom nav change
  void onBottomNavItemTap(int index) {
    navIndex.value = index;
  }

  // Fetch AppBar slider images
  Future<void> fetchAppbarPagerImages() async {
    try {
      appbarPagerStatus.value = AppbarPagerImagesStatus.LOADING;
      final items = await dashboardRepo.getPagerItems(ImagePagerSections.APPBAR_PAGER);
      appbarPagerList.assignAll(items);
      if (kDebugMode) {
        print("Fetched ${items.length} appbar pager images");
      }
      appbarPagerStatus.value = AppbarPagerImagesStatus.SUCCESS;
    } catch (e) {
      appbarPagerStatus.value = AppbarPagerImagesStatus.FAILURE;
      if (kDebugMode) {
        print(e);
      }
      showSnackbar(
        isError: true,
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  // Fetch Marquee Notifications
  Future<void> fetchMarquee() async {
    try {
      marqueeStatus.value = MarqueeStatus.LOADING;
      final result = await dashboardRepo.getMarquee();
      marqueeData.value = result;
      marqueeStatus.value = MarqueeStatus.SUCCESS;
    } catch (e) {
      marqueeStatus.value = MarqueeStatus.FAILURE;
      showSnackbar(
        isError: true,
        title: 'Marquee Error',
        message: e.toString(),
      );
    }
  }

  // Fetch Cover Images
  Future<void> fetchCoverImages() async {
    try {
      coverImagesStatus.value = CoverImagesStatus.LOADING;
      final data = await dashboardRepo.getCoverImages();
      coverImages.value = data;
      coverImagesStatus.value = CoverImagesStatus.SUCCESS;

      if (kDebugMode) {
        print("Fetched Cover Images: ${data.toJson()}");
      }
    } catch (e) {
      coverImagesStatus.value = CoverImagesStatus.FAILURE;
      showSnackbar(
        isError: true,
        title: 'Cover Images Error',
        message: 'Failed to fetch cover images: $e',
      );
    }
  }


  Future<void> getSingleProduct(String id) async {
    singleProduct.value = await dashboardRepo.fetchSingleProductById(id);
  }

  //Fetch Body Slider
  Future<void> fetchBodyPagerImages() async {
    try {
      bodyPagerStatus.value = BodyPagerImagesStatus.LOADING;
      final items = await dashboardRepo.getPagerItems(ImagePagerSections.BODY_PAGER);
      bodyPagerList.assignAll(items);
      bodyPagerStatus.value = BodyPagerImagesStatus.SUCCESS;
      if (kDebugMode) {
        print("Fetched ${items.length} body pager images");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      bodyPagerStatus.value = BodyPagerImagesStatus.FAILURE;
      showSnackbar(
        isError: true,
        title: 'Body Pager Error',
        message: e.toString(),
      );
    }
  }

  // SIGNLE BANNER HOME


  Future<void> fetchSingleBanners() async {
    try {
      final bannerOneList = await dashboardRepo.getPagerItems(SingleBanners.BANNER_ONE);
      if (bannerOneList.isNotEmpty) {
        singleBannerOne.value = bannerOneList.first;
      }

      final bannerTwoList = await dashboardRepo.getPagerItems(SingleBanners.BANNER_TWO);
      if (bannerTwoList.isNotEmpty) {
        singleBannerTwo.value = bannerTwoList.first;
      }

      if (kDebugMode) {
        print("Fetched banner_one: ${singleBannerOne.value}");
        print("Fetched banner_two: ${singleBannerTwo.value}");
      }
    } catch (e) {
      showSnackbar(
        isError: true,
        title: 'Single Banners Error',
        message: 'Failed to fetch single banners: $e',
      );
    }
  }


  // ✅ Fetch All Lists at Once
  Future<void> fetchAllProductLists() async {
    await Future.wait([
      fetchAllProducts(),
      fetchFeaturedProducts(),
      fetchFlashSaleProducts()
    ]);
    _generatePopularProducts();
  }




  ///CATEGORIES SECTION METHODS

  Future<void> onTapCategories(int index) async {
    categoryIndex.value = index;
  }

  Future<void> onTapSubCategories(int index, CategoryModel categoryData) async {
    navigation.gotoProductsScreen(
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
      await categories.fetchCategoryById(appbarPagerList[index].typeId.toString())
          .then((value) {
        print(' This is Single Category Data : ${categories.singleCategory.value!.categoryNameEnglish}');
        navigation.gotoProductsScreen(data: categories.singleCategory.value!);
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
      await categories.fetchCategoryById(bodyPagerList[index].typeId.toString())
          .then((value) {
            navigation.gotoProductsScreen(data: categories.singleCategory.value!);
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
        await categories.fetchCategoryById(singleBannerOne.value!.typeId.toString())
            .then((value) {
              navigation.gotoProductsScreen(data: categories.singleCategory.value!);
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
        await categories.fetchCategoryById(singleBannerTwo.value!.typeId.toString())
            .then((value) {
              navigation.gotoProductsScreen(data: categories.singleCategory.value!);
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

  // ✅ All Products (used to build popular)
  Future<void> fetchAllProducts({bool loadMore = false}) async {
    if (_isLoadingAll || isLoadingMore.value || !hasMoreAllProducts.value) {
      return;
    }

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
      final result = await productRepo.fetchProductsListEvent(
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
