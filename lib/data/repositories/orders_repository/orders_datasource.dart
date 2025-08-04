
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:http/http.dart' as http;

import '../../models/order_model.dart';

class OrdersDatasource extends BaseRepository{

  /// GET ORDERS BY USER ID
  Future<List<OrderModel>> getOrdersByUserIdApi(String userId) async {
    final uri = Uri.parse('${APiEndpoints.getOrdersByUserId}?user_id=$userId');

    final response = await http.get(
      uri,
      headers: apiHeaders,
    );

    final decoded = handleApiResponseAsMap(response); // returns Map<String, dynamic>
    final List<dynamic> ordersList = decoded['orders'];

    return ordersList.map((e) => OrderModel.fromJson(e)).toList();
  }
}