import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/controllers/orders_controller/orders_controller.dart';
import 'package:danapaniexpress/domain/controllers/service_area_controller/service_area_controller.dart';
class OrdersBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(OrdersController());
  }

}