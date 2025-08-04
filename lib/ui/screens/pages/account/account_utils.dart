import 'package:danapaniexpress/core/common_imports.dart';

class OrderTabsModel{
  final String icon;
  final String titleEng;
  final String titleUrdu;

  OrderTabsModel({
    required this.icon,
    required this.titleEng,
    required this.titleUrdu,
});
}

var orderTabsModelList = [
  OrderTabsModel(icon: icOrderActive, titleEng: 'Active', titleUrdu: 'فعال'),
  OrderTabsModel(icon: icOrderConfirmed, titleEng: 'Confirmed', titleUrdu: 'تصدیق شدہ'),
  OrderTabsModel(icon: icOrderCompleted, titleEng: 'Completed', titleUrdu: 'مکمل'),
  OrderTabsModel(icon: icOrderCancel, titleEng: 'Cancelled', titleUrdu: 'منسوخ'),
];

