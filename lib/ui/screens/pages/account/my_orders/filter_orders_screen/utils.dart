import 'package:danapaniexpress/core/common_imports.dart';
import 'package:intl/intl.dart';

Future<void> pickDate({
  required BuildContext context,
  required RxString target,
}) async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: isDark
              ? ColorScheme.dark(
            primary: EnvColors.accentCTAColorDark,      // Header background
            onPrimary: EnvColors.cardColorDark,         // Header text
            onSurface: EnvColors.primaryTextColorDark,  // Dates text
          )
              : ColorScheme.light(
            primary: EnvColors.primaryColorLight,       // Header background
            onPrimary: EnvColors.cardColorLight,        // Header text
            onSurface: EnvColors.primaryTextColorLight, // Dates text
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: AppColors.backgroundColorSkin(isDark),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // optional rounded corners
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    target.value = DateFormat('yyyy-MM-dd').format(picked);
  }
}
