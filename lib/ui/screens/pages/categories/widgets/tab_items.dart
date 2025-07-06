import 'package:danapaniexpress/core/common_imports.dart';

class TabItems extends StatelessWidget {
  final String text;
  final bool isSelected;
  const TabItems({super.key, required this.text, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: MAIN_HORIZONTAL_PADDING / 2),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING, vertical: 8.0),
        decoration: BoxDecoration(
            color: isSelected ? AppColors.selectedTabItemsColorSkin(isDark) : AppColors.tabItemsColorSkin(isDark),
            borderRadius: BorderRadius.circular(5.0)
        ),
        child: appText(text: text, textStyle: tabItemTextStyle(isSelected: isSelected)),
      ),
    );
  }
}