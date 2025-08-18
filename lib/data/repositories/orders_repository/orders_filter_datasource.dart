import 'package:danapaniexpress/core/common_imports.dart';
import 'package:http/http.dart' as http;
import '../../models/order_model.dart';

class FilterOrdersDatasource extends BaseRepository{

  /// GET ORDERS BY USER ID AND DATE (with optional filters & pagination)
  Future<List<OrderModel>> getOrdersByUserIdAndDateApi(
      String userId, {
        int page = 1,
        int limit = 10,
        String? startDate,
        String? endDate,
        String? orderNumber,
      }) async {
    // Build base query
    String query = '?user_id=$userId&page=$page&limit=$limit';

    // Append filters if provided
    if (startDate != null && startDate.isNotEmpty) {
      query += '&start_date=$startDate';
    }
    if (endDate != null && endDate.isNotEmpty) {
      query += '&end_date=$endDate';
    }
    if (orderNumber != null && orderNumber.isNotEmpty) {
      query += '&order_number=$orderNumber';
    }

    final uri = Uri.parse('${APiEndpoints.getOrdersByUserIdAndDate}$query');

    final response = await http.get(
      uri,
      headers: apiHeaders,
    );

    final decoded = handleApiResponseAsMap(response); // Map<String, dynamic>
    final List<dynamic> ordersList = decoded['orders'] ?? [];

    return ordersList.map((e) => OrderModel.fromJson(e)).toList();
  }


}