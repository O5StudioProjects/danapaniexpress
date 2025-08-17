import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class SearchBarSection extends StatelessWidget {
  const SearchBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI(){
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