
import 'package:danapaniexpress/data/repositories/orders_repository/orders_filter_datasource.dart';

import '../../models/order_model.dart';

class FilterOrdersRepository extends FilterOrdersDatasource{

  /// GET ORDERS BY USER ID AND DATE (with optional filters & pagination)
  Future<List<OrderModel>> getOrdersByUserIdAndDate(
      String userId, {
        int page = 1,
        int limit = 10,
        String? startDate,
        String? endDate,
        String? orderNumber,
      }) {
    return getOrdersByUserIdAndDateApi(
      userId,
      page: page,
      limit: limit,
      startDate: startDate,
      endDate: endDate,
      orderNumber: orderNumber,
    );
  }

}