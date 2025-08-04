
import 'package:danapaniexpress/data/repositories/orders_repository/orders_datasource.dart';

import '../../models/order_model.dart';

class OrdersRepository extends OrdersDatasource {

  /// GET ORDERS BY USER ID
  Future<List<OrderModel>> getOrdersByUserId(String userId) async {
    return await getOrdersByUserIdApi(userId);
  }

}