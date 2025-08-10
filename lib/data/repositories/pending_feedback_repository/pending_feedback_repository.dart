
import 'package:danapaniexpress/data/models/order_model.dart';
import 'package:danapaniexpress/data/repositories/pending_feedback_repository/pending_feedback_datasource.dart';

class PendingFeedbackRepository extends PendingFeedbackDatasource {
  /// GET ORDERS WITHOUT FEEDBACK COMPLETED
  Future<List<OrderModel>> getCompletedOrdersWithoutFeedback({
    required String userId,
    int page = 1,
    int limit = 10,
  }) {
    return getCompletedOrdersWithoutFeedbackApi(
      userId: userId,
      page: page,
      limit: limit,
    );
  }
}