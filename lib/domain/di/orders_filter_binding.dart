import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/controllers/orders_controller/filter_orders_controller.dart';
import 'package:danapaniexpress/domain/controllers/orders_controller/orders_controller.dart';
import 'package:danapaniexpress/domain/controllers/service_area_controller/service_area_controller.dart';
class OrdersFilterBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(FilterOrdersController());
    Get.put(OrdersController());
  }

}