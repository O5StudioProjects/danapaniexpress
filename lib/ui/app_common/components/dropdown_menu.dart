import 'package:danapaniexpress/core/common_imports.dart';

class AppButtonDropdownMenu<T> extends StatelessWidget {
  final List<T> options;
  final void Function(T) onSelected;
  final Widget customIcon;
  final Widget Function(T) itemBuilder; // Builds each menu item widget

  const AppButtonDropdownMenu({
    super.key,
    required this.options,
    required this.onSelected,
    required this.customIcon,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      color: AppColors.cardColorSkin(isDark),
      borderRadius: BorderRadius.circular(24.0),
      clipBehavior: Clip.antiAlias,
      onSelected: onSelected,
      position: PopupMenuPosition.under,
      itemBuilder: (BuildContext context) {
        return options.map((item) {
          return PopupMenuItem<T>(
            value: item,
            child: itemBuilder(item), // Unique widget per item
          );
        }).toList();
      },
      child: customIcon,
    );
  }
}
