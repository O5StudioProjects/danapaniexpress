import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/data/models/products_model.dart';
import 'package:danapaniexpress/data/repositories/search_repository/search_repository.dart';


class SearchProductsController extends GetxController {
  final searchRepo = SearchRepository();

  var searchTextController = TextEditingController().obs;

  /// PAGINATION VARIABLES
  RxBool isLoadingMore = false.obs;
  Rx<Status> searchStatus = Status.IDLE.obs;
  RxList<ProductModel> searchResults = <ProductModel>[].obs;
  final int searchLimit = PRODUCTS_LIMIT;
  int currentPage = 1;
  RxBool hasMoreResults = true.obs;

  RxString searchQuery = ''.obs;
  double _previousOffset = 0;
  RxBool showBottomMessage = true.obs;
  RxBool reachedEndOfScroll = false.obs;
  /// Scroll Controller
  final ScrollController scrollController = ScrollController();


  @override
  void onInit() {
    super.onInit();
    // Debounce search query changes
    debounce(
      searchQuery,
          (_) {
        if (searchQuery.value.trim().isNotEmpty) {
          fetchInitialSearchResults();
        }
      },
      time: const Duration(milliseconds: 500),
    );
    setupScrollListener();
  }




  void setupScrollListener() {
    scrollController.addListener(() {

      final currentOffset = scrollController.position.pixels;
      final maxOffset = scrollController.position.maxScrollExtent;

      // ✅ Bottom message visibility
      showBottomMessage.value = currentOffset > _previousOffset;

      // ✅ End of scroll detection
      reachedEndOfScroll.value = currentOffset >= maxOffset - 10;

      // ✅ Load more trigger (per tab)

      if (currentOffset >= maxOffset - 200 && hasMoreResults.value && !isLoadingMore.value) {
        loadMoreSearchResults();
      }
      _previousOffset = currentOffset;
    });
  }

  /// INITIAL SEARCH
  Future<void> fetchInitialSearchResults() async {
    if (searchQuery.value.trim().isEmpty) return;

    try {
      searchStatus.value = Status.LOADING;
      currentPage = 1;

      final fetchedProducts = await searchRepo.searchProducts(
        search: searchQuery.value,
        page: currentPage,
        limit: searchLimit,
      );

      searchResults.clear();
      searchResults.assignAll(fetchedProducts);
      hasMoreResults.value = fetchedProducts.length == searchLimit;
      searchStatus.value = Status.SUCCESS;
    } catch (e) {
      searchStatus.value = Status.FAILURE;
    }
  }

  /// LOAD MORE SEARCH RESULTS
  Future<void> loadMoreSearchResults() async {
    if (isLoadingMore.value || !hasMoreResults.value) return;

    try {
      isLoadingMore.value = true;
      currentPage++;

      final moreProducts = await searchRepo.searchProducts(
        search: searchQuery.value,
        page: currentPage,
        limit: searchLimit,
      );

      searchResults.addAll(moreProducts);

      // If fewer results than limit, no more pages
      if (moreProducts.length < searchLimit) {
        hasMoreResults.value = false;
      }
    } catch (e) {
      currentPage--; // rollback if failed
    } finally {
      isLoadingMore.value = false;
    }
  }


  clearSearch(){
    searchTextController.value.clear();
    searchQuery.value = '';
    searchResults.clear();
    searchStatus.value = Status.IDLE;
  }
}
