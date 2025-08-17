import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class ShowListSection extends StatelessWidget {
  const ShowListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI(){
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