
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/data/models/order_model.dart';
import 'package:http/http.dart' as http;

class PendingFeedbackDatasource extends BaseRepository{
  /// GET ORDERS WITHOUT FEEDBACK COMPLETED
  Future<List<OrderModel>> getCompletedOrdersWithoutFeedbackApi({
    required String userId,
    int page = 1,
    int limit = 10,
  }) async {
    final uri = Uri.parse(
      '${APiEndpoints.completedOrdersWithoutFeedback}?user_id=$userId&page=$page&limit=$limit',
    );

    final response = await http.get(uri, headers: apiHeaders);
    final data = handleApiResponseAsMap(response);

    final List<dynamic> ordersList = data['orders'] ?? [];

    return ordersList
        .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}