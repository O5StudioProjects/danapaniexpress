import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/core/common_imports.dart';

List<OrderModel> sortByDateDesc(List<OrderModel> list, status) {
  final sortedList = List<OrderModel>.from(list);

  sortedList.sort((a, b) {
    String? aDateStr;
    String? bDateStr;

    switch (status) {
      case OrderStatus.ACTIVE:
        aDateStr = a.orderPlacedDateTime;
        bDateStr = b.orderPlacedDateTime;
        break;
      case OrderStatus.CONFIRMED:
        aDateStr = a.orderConfirmedDateTime;
        bDateStr = b.orderConfirmedDateTime;
        break;
      case OrderStatus.COMPLETED:
        aDateStr = a.orderCompletedDateTime;
        bDateStr = b.orderCompletedDateTime;
        break;
      case OrderStatus.CANCELLED:
        aDateStr = a.orderCancelledDateTime;
        bDateStr = b.orderCancelledDateTime;
        break;
    }

    final aDate = DateTime.tryParse(aDateStr ?? '') ?? DateTime(1970);
    final bDate = DateTime.tryParse(bDateStr ?? '') ?? DateTime(1970);

    return bDate.compareTo(aDate); // Newest first
  });

  return sortedList;
}

Color getStatusTextColor(String status) {
  switch (status) {
    case OrderStatus.ACTIVE:
      return EnvColors.backgroundColorDark;
    default:
      return EnvColors.backgroundColorLight;
  }
}

Color getStatusBgColor(String status) {
  switch (status) {
    case OrderStatus.ACTIVE:
      return EnvColors.offerHighlightColorDark;
    case OrderStatus.CONFIRMED:
      return EnvColors.accentCTAColorLight;
    case OrderStatus.COMPLETED:
      return EnvColors.primaryColorLight;
    case OrderStatus.CANCELLED:
      return EnvColors.specialFestiveColorLight;
    default:
      return EnvColors.primaryColorLight;
  }
}