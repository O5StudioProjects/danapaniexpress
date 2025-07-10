import 'package:danapaniexpress/core/common_imports.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CityDropdownField extends StatelessWidget {
  final GlobalKey<DropdownSearchState<String>> dropDownKey;
  String selectedCity;
  final Function(String?) onChanged;

  CityDropdownField({
    super.key,
    required this.dropDownKey,
     required this.selectedCity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      items: (filter, infiniteScrollProps) =>['Sahiwal', 'Okara', 'Gujrat'],
      selectedItem: selectedCity,
      // onChanged: (val) => selectedCity = val!,
      validator: (val) => val == null ? 'Please select a city' : null,
      dropdownBuilder: (context, selectedItem) {
        return InputDecorator(
          decoration: InputDecoration(
            hintText: 'Select City',
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
            filled: true,
            fillColor: AppColors.materialButtonSkin(isDark).withValues(alpha: 0.1),
          ),
          child: Text(
            selectedItem ?? '',
            style: TextStyle(
              color: selectedItem == null ? Colors.grey : Colors.black,
              fontSize: 16,
            ),
          ),
        );
      },
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: 'Search...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );

  }
}
