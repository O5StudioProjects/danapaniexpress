import 'package:danapaniexpress/core/common_imports.dart';

void showCustomDialog(BuildContext context, customDialog, {isDismissible = true}) {
  showDialog(
    context: context,
    barrierDismissible: isDismissible,
    builder: (BuildContext context) {
      return customDialog;
    },
  );
}