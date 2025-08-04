import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:intl/intl.dart';

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

String formatDateTime(String rawDateTime) {
  final parsedDate = DateTime.parse(rawDateTime);
  return DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);
}

String orderStatusConversion(String orderStatus){

  if(orderStatus == OrderStatus.ACTIVE){
    return AppLanguage.activeStr(appLanguage).toString();
  } else if(orderStatus == OrderStatus.CONFIRMED){
    return AppLanguage.confirmedStr(appLanguage).toString();
  } else if(orderStatus == OrderStatus.COMPLETED){
    return AppLanguage.completedStr(appLanguage).toString();
  } else if(orderStatus == OrderStatus.CANCELLED){
    return AppLanguage.cancelledStr(appLanguage).toString();
  } else {
    return '';
  }

}