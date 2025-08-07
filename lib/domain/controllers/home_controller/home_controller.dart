import 'package:carousel_slider/carousel_controller.dart';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/data/repositories/home_repository/home_repository.dart';
import 'package:danapaniexpress/ui/app_common/dialogs/events_popup.dart';

class HomeController extends GetxController {
  final homeRepo = HomeRepository();
  final categories = Get.put(CategoriesController(), permanent: true);
  final products = Get.put(ProductsController(), permanent: true);
  final cart = Get.put(CartController(), permanent: true);
  final favorites = Get.put(FavoritesController(), permanent: true);
  final navigation = Get.find<NavigationController>();
  //final cart = Get.find<CartController>();

  ///HOME SCREEN

  // EVENTS POPUP
  Rx<PagerImagesModel?> eventsPopupData = Rx<PagerImagesModel?>(null);
  Rx<Status> eventsPopupStatus = Status.IDLE.obs;

  // AppBar Slider
  RxList<PagerImagesModel> appbarPagerList = <PagerImagesModel>[].obs;
  Rx<AppbarPagerImagesStatus> appbarPagerStatus = AppbarPagerImagesStatus.IDLE.obs;

  // MARQUEE
  Rx<MarqueeModel?> marqueeData = Rx<MarqueeModel?>(null);
  Rx<MarqueeStatus> marqueeStatus = MarqueeStatus.IDLE.obs;

  // COVER IMAGES
  Rx<CoverImagesModel?> coverImages = Rx<CoverImagesModel?>(null);
  Rx<CoverImagesStatus> coverImagesStatus = CoverImagesStatus.IDLE.obs;

  // Body Pager Slider
  RxList<PagerImagesModel> bodyPagerList = <PagerImagesModel>[].obs;
  Rx<BodyPagerImagesStatus> bodyPagerStatus = BodyPagerImagesStatus.IDLE.obs;
  final CarouselSliderController bodyPagerController = CarouselSliderController();
  final RxInt currentSlide = 0.obs;

  Rx<PagerImagesModel?> singleBannerOne = Rx<PagerImagesModel?>(null);
  Rx<SingleBannerOneStatus> singleBannerOneStatus = SingleBannerOneStatus.IDLE.obs;

  Rx<PagerImagesModel?> singleBannerTwo = Rx<PagerImagesModel?>(null);
  Rx<SingleBannerTwoStatus> singleBannerTwoStatus = SingleBannerTwoStatus.IDLE.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchAppbarPagerImages();
    fetchMarquee();
    fetchCoverImages();
    fetchBodyPagerImages();
    fetchSingleBanners();
    fetchInitialPopularProducts();
    fetchInitialFeaturedProducts();
    fetchInitialFlashSaleProducts();
    fetchInitialFavoriteProducts();
    fetchInitialCartProducts();
    fetchEventsPopup();
  }


  ///HOME SCREEN Methods

  // Fetch Events Popup
  Future<void> fetchEventsPopup() async {
    try {
      eventsPopupStatus.value = Status.LOADING;
      final eventList = await homeRepo.getPagerItems(
        ImagePagerSections.EVENTS_POPUP,
      );
      if (eventList.isNotEmpty) {
        eventsPopupData.value = eventList.first;
      }
      if (kDebugMode) {
        print("Fetched ${eventList.length} Events PopUp");
      }
      eventsPopupStatus.value = Status.SUCCESS;
      showCustomDialog(gContext,
          AppEventsDialog(data: eventsPopupData.value), isDismissible: false);

    } catch (e) {
      eventsPopupStatus.value = Status.FAILURE;
      if (kDebugMode) {
        print(e);
      }
      showSnackbar(isError: true, title: 'Error', message: e.toString());
    }
  }

  // Fetch AppBar slider images
  Future<void> fetchAppbarPagerImages() async {
    try {
      appbarPagerStatus.value = AppbarPagerImagesStatus.LOADING;
      final items = await homeRepo.getPagerItems(
        ImagePagerSections.APPBAR_PAGER,
      );
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
      showSnackbar(isError: true, title: 'Error', message: e.toString());
    }
  }

  // Fetch Marquee Notifications
  Future<void> fetchMarquee() async {
    try {
      marqueeStatus.value = MarqueeStatus.LOADING;
      final result = await homeRepo.getMarquee();
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

  //Fetch categories here
  Future<void> fetchCategories() async {
    await categories.fetchCategories();
  }

  //Fetch OTHER Products here - POPULAR
  Future<void> fetchInitialPopularProducts() async {
    await products.fetchInitialPopularProducts();
  }

  //Fetch OTHER Products here - FEATURED
  Future<void> fetchInitialFeaturedProducts() async {
    await products.fetchInitialFeaturedProducts();
  }

  //Fetch OTHER Products here - FLASH SALE
  Future<void> fetchInitialFlashSaleProducts() async {
    await products.fetchInitialFlashSaleProducts();
  }

  //Fetch Favorite Products here
  Future<void> fetchInitialFavoriteProducts() async {
    await favorites.fetchFavorites();
  }

  //Fetch Cart Products here
  Future<void> fetchInitialCartProducts() async {
    await cart.fetchCartProducts();
  }


  // Fetch Cover Images
  Future<void> fetchCoverImages() async {
    try {
      coverImagesStatus.value = CoverImagesStatus.LOADING;
      final data = await homeRepo.getCoverImages();
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

  //Fetch Body Slider
  Future<void> fetchBodyPagerImages() async {
    try {
      bodyPagerStatus.value = BodyPagerImagesStatus.LOADING;
      final items = await homeRepo.getPagerItems(ImagePagerSections.BODY_PAGER);
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
      final bannerOneList = await homeRepo.getPagerItems(
        SingleBanners.BANNER_ONE,
      );
      if (bannerOneList.isNotEmpty) {
        singleBannerOne.value = bannerOneList.first;
      }

      final bannerTwoList = await homeRepo.getPagerItems(
        SingleBanners.BANNER_TWO,
      );
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
      await categories
          .fetchCategoryById(appbarPagerList[index].typeId.toString())
          .then((value) {
            print(
              ' This is Single Category Data : ${categories.singleCategory.value!.categoryNameEnglish}',
            );
            navigation.gotoProductsScreen(
              data: categories.singleCategory.value!,
            );
          })
          .onError((handleError, str) {
            if (kDebugMode) {
              print(str);
            }
            return;
          });
    } else if (appbarPagerList[index].type == ImagePagerType.PRODUCT) {
      await products.getSingleProduct(appbarPagerList[index].typeId.toString())
          .then((value) {
            navigation.gotoProductDetailScreen(data: products.singleProduct.value!);
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
      await categories
          .fetchCategoryById(bodyPagerList[index].typeId.toString())
          .then((value) {
            navigation.gotoProductsScreen(
              data: categories.singleCategory.value!,
            );
          })
          .onError((handleError, str) {
            if (kDebugMode) {
              print(str);
            }
            return;
          });
    } else if (bodyPagerList[index].type == ImagePagerType.PRODUCT) {
      await products.getSingleProduct(bodyPagerList[index].typeId.toString())
          .then((value) {
            navigation.gotoProductDetailScreen(data: products.singleProduct.value!);
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
        await categories
            .fetchCategoryById(singleBannerOne.value!.typeId.toString())
            .then((value) {
              navigation.gotoProductsScreen(
                data: categories.singleCategory.value!,
              );
            })
            .onError((handleError, str) {
              if (kDebugMode) {
                print(str);
              }
              return;
            });
      } else if (singleBannerOne.value!.type == ImagePagerType.PRODUCT) {
        await products.getSingleProduct(singleBannerOne.value!.typeId.toString())
            .then((value) {
              navigation.gotoProductDetailScreen(data: products.singleProduct.value!);
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
        await categories
            .fetchCategoryById(singleBannerTwo.value!.typeId.toString())
            .then((value) {
              navigation.gotoProductsScreen(
                data: categories.singleCategory.value!,
              );
            })
            .onError((handleError, str) {
              if (kDebugMode) {
                print(str);
              }
              return;
            });
      } else if (singleBannerTwo.value!.type == ImagePagerType.PRODUCT) {
        await products.getSingleProduct(singleBannerTwo.value!.typeId.toString())
            .then((value) {
              navigation.gotoProductDetailScreen(data: products.singleProduct.value!);
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

  Future<void> onTapTopNotificationEventDialog(PagerImagesModel data) async {
    if (data.type == ImagePagerType.FEATURED) {
      navigation.gotoOtherProductsScreen(
        screenType: ProductsScreenType.FEATURED,
      );
    } else if (data.type == ImagePagerType.FLASH_SALE) {
      navigation.gotoOtherProductsScreen(
        screenType: ProductsScreenType.FLASHSALE,
      );
    } else if (data.type == ImagePagerType.POPULAR) {
      navigation.gotoOtherProductsScreen(
        screenType: ProductsScreenType.POPULAR,
      );
    } else if (data.type == ImagePagerType.CATEGORY) {
      await categories
          .fetchCategoryById(data.typeId.toString())
          .then((value) {
        print(
          ' This is Single Category Data : ${categories.singleCategory.value!.categoryNameEnglish}',
        );
        navigation.gotoProductsScreen(
          data: categories.singleCategory.value!,
        );
      })
          .onError((handleError, str) {
        if (kDebugMode) {
          print(str);
        }
        return;
      });
    } else if (data.type == ImagePagerType.PRODUCT) {
      await products.getSingleProduct(data.typeId.toString())
          .then((value) {
        navigation.gotoProductDetailScreen(data: products.singleProduct.value!);
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
