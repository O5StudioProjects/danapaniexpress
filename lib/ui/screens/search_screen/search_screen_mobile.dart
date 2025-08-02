import 'package:danapaniexpress/core/common_imports.dart';

import '../../../domain/controllers/search_controller/search_controller.dart';
class SearchScreenMobile extends StatelessWidget {
  const SearchScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final search = Get.find<SearchProductsController>();
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          appBarCommon(title: 'Search', isBackNavigation: true),
          Padding(
            padding: const EdgeInsets.only(
              top: MAIN_HORIZONTAL_PADDING,
              right: MAIN_HORIZONTAL_PADDING,
              left: MAIN_HORIZONTAL_PADDING,
              bottom: MAIN_HORIZONTAL_PADDING,
            ),
            child: AppTextFormField(
              textEditingController: search.searchTextController.value,
              prefixIcon: Icons.search,
              hintText: 'Search products...',

            ),
          ),
          Expanded(
              child: EmptyScreen(icon: animSearch, iconType: IconType.ANIM, text: 'Search Products')
          )
        ],
      ),
    );
  }
}
