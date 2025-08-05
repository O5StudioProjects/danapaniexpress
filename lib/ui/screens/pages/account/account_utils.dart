import 'package:danapaniexpress/core/common_imports.dart';

class OrderTabsModel {
  final String icon;
  final String titleEng;
  final String titleUrdu;
  final String statusKey;

  OrderTabsModel({
    required this.icon,
    required this.titleEng,
    required this.titleUrdu,
    required this.statusKey,
  });
}

var orderTabsModelList = [
  OrderTabsModel(
    icon: icOrderActive,
    titleEng: 'Active',
    titleUrdu: 'فعال',
    statusKey: 'Active', // ← Add this
  ),
  OrderTabsModel(
    icon: icOrderConfirmed,
    titleEng: 'Confirmed',
    titleUrdu: 'تصدیق شدہ',
    statusKey: 'Confirmed',
  ),
  OrderTabsModel(
    icon: icOrderCompleted,
    titleEng: 'Completed',
    titleUrdu: 'مکمل',
    statusKey: 'Completed',
  ),
  OrderTabsModel(
    icon: icOrderCancel,
    titleEng: 'Cancelled',
    titleUrdu: 'منسوخ',
    statusKey: 'Cancelled',
  ),
];


