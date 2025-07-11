import 'package:danapaniexpress/core/common_imports.dart';

class SimpleDropdown extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final void Function(String?) onChanged;
  final String hintText;

  const SimpleDropdown({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    this.hintText = 'Select an option',
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedItem,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: textFormHintTextStyle(),
        filled: true,
        fillColor: AppColors.materialButtonSkin(isDark).withValues(alpha: 0.1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.materialButtonSkin(isDark), width: 1.0),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
        value: item,
        child: appText(text: item, textStyle: bodyTextStyle()),
      ))
          .toList(),
    );
  }
}

