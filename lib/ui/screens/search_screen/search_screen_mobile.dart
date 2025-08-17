import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class SearchScreenMobile extends StatelessWidget {
  const SearchScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI(){
    final search = Get.find<SearchProductsController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      search.clearSearch();
    });
    return Obx(() {
      final isLoadingMore = search.isLoadingMore.value;
      final hasMore = search.hasMoreResults.value;
      final reachedEnd = search.reachedEndOfScroll.value;
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(
              title: AppLanguage.searchStr(appLanguage),
              isBackNavigation: true,
            ),
            SearchBarSection(),
            Expanded(child: ShowListSection()),
            BottomMessagesSection(
              isLoadingMore: isLoadingMore,
              hasMore: hasMore,
              reachedEnd: reachedEnd,
              message: AppLanguage.noMoreProductsStr(appLanguage).toString(),
            ),

          ],
        ),
      );
    });
  }

}
