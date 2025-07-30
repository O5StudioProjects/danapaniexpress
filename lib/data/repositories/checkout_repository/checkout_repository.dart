
import 'package:danapaniexpress/data/repositories/checkout_repository/checkout_datasource.dart';

class CheckoutRepository extends CheckoutDatasource{

  /// GET DELIVERY DAYS WITH SLOTS (7 DAYS)
  Future<Map<String, dynamic>> getDeliveryDaysWithSlots() async {
    return await getDeliveryDaysWithSlotsApi();
  }

}