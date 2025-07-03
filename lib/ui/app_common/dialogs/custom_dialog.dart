import 'package:danapaniexpress/core/common_imports.dart';

void showCustomDialog(BuildContext context, customDialog) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return customDialog;
    },
  );
}