import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/ui/screens/search_screen/widgets/search_product_item.dart';

import '../../../domain/controllers/search_controller/search_controller.dart';

class SearchScreenMobile extends StatelessWidget {
  const SearchScreenMobile({super.key});


  @override
  Widget build(BuildContext context) {
    final search = Get.find<SearchProductsController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
    search.clearSearch();
    });
    return Obx(() {
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(title: AppLanguage.searchStr(appLanguage), isBackNavigation: true),
            SearchBarSection(),
            Expanded(
              child: ShowListSection(),
            ),
            ShowBottomMessagesSection(),
          ],
        ),
      );
    });
  }
}

class SearchBarSection extends StatelessWidget {
  const SearchBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    final search = Get.find<SearchProductsController>();
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(
          top: MAIN_HORIZONTAL_PADDING,
          right: MAIN_HORIZONTAL_PADDING,
          left: MAIN_HORIZONTAL_PADDING,
          bottom: MAIN_HORIZONTAL_PADDING,
        ),
        child: AppTextFormField(
          textEditingController: search.searchTextController.value,
          prefixIcon: Icons.search,
          hintText: AppLanguage.searchProductsDotsStr(appLanguage),
          onChanged: (value) {
            search.searchQuery.value = value;
            if (value.trim().isEmpty) {
              search.clearSearch(); // Instantly reset to initial state
            }
          },
          onSubmit: (value) {
            search.searchQuery.value = value;
          },
        ),
      );
    });
  }
}

class ShowListSection extends StatelessWidget {
  const ShowListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final search = Get.find<SearchProductsController>();
    final nav = Get.find<NavigationController>();
    return Obx(() {
      var list = search.searchResults;

      // 1️⃣ Initial state (user hasn't searched yet)
      if (search.searchStatus.value == Status.IDLE && list.isEmpty) {
        return EmptyScreen(
          icon: animSearch,
          iconType: IconType.ANIM,
          text: AppLanguage.searchProductsStr(appLanguage).toString(),
        );
      }

      // 2️⃣ Loading
      if (search.searchStatus.value == Status.LOADING) {
        return loadingIndicator();
      }

      // 3️⃣ Failure
      if (search.searchStatus.value == Status.FAILURE) {
        return ErrorScreen();
      }

      // 4️⃣ Search done but no results
      if (list.isEmpty) {
        return EmptyScreen(
          icon: animSearch,
          iconType: IconType.ANIM,
          text: AppLanguage.noSuchProductFoundStr(appLanguage).toString(),
        );
      }

      // 5️⃣ Show results
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
        physics: const BouncingScrollPhysics(),
        controller: search.scrollController,
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          var data = list[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
            child: GestureDetector(
                onTap: () => nav.gotoProductDetailScreen(data: data),
                child: SearchProductItem(data: data)),
          );
        },
      );
    });
  }
}


class ShowBottomMessagesSection extends StatelessWidget {
  const ShowBottomMessagesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final search = Get.find<SearchProductsController>();

    return Obx(() {
      final isLoadingMore = search.isLoadingMore.value;
      final hasMore = search.hasMoreResults.value;
      final reachedEnd = search.reachedEndOfScroll.value;

      // ✅ Only show when all products are scrolled & no more left
      if (!hasMore && reachedEnd) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Center(
            child: appText(text: AppLanguage.noMoreProductsStr(appLanguage), textStyle: itemTextStyle()),
          ),
        );
      }

      // ✅ Show loading if fetching more
      if (isLoadingMore) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: loadingIndicator(),
        );
      }

      return const SizedBox(); // nothing to show
    });
  }
}
