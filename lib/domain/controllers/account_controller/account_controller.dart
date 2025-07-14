import 'package:danapaniexpress/core/common_imports.dart';


class AccountController extends GetxController {


  final scrollController = ScrollController();
  RxBool reachedEndOfScroll = false.obs;

  double _previousOffset = 0;
  final RxBool showTopHeader = true.obs;
  double _lastHeaderVisibilityOffset = 0.0;

  @override
  void onInit() {
    initScrollListener();
    super.onInit();
  }

  void initScrollListener() {
    scrollController.addListener(() {
      final currentOffset = scrollController.position.pixels;
      final maxOffset = scrollController.position.maxScrollExtent;

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

    });
  }

}