import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

String get appLanguage {
  var language = Get.find<ThemeController>().appLanguage.value;
  return language;
}

bool get isDark {
  var theme = Get.find<ThemeController>().isDark.value;
  return theme;
}

// bool get isSubscribed {
//  // var subscription = Get.put(InAppController()).subscription.value;
//   var subscription = Get.find<InAppController>().subscription.value;
//
//   return subscription;
// }

bool get internet {
  var connection = Get.find<ThemeController>().internet.value;
  return connection;
}

Size get size {
  var getSize = MediaQuery.of(gContext).size;
  return getSize;
}