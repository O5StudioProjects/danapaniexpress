
import 'dart:io';

import 'package:danapaniexpress/data/repositories/orders_repository/orders_datasource.dart';

import '../../models/order_model.dart';

class OrdersRepository extends OrdersDatasource {

  /// GET ORDERS BY USER ID
  Future<List<OrderModel>> getOrdersByUserId(String userId) async {
    return await getOrdersByUserIdApi(userId);
  }

  /// GET ORDER BY ORDER NUMBER
  Future<OrderModel> getOrderByNumber(String orderNumber) async {
    return await getOrderByNumberApi(orderNumber);
  }

  /// UPDATE ORDER
  Future<Map<String, dynamic>> updateOrder({
    required String orderId,
    String? riderId,
    String? orderStatus,
  }) async {
    return await updateOrderApi(
      orderId: orderId,
      riderId: riderId,
      orderStatus: orderStatus,
    );
  }


  /// INSERT ORDER FEEDBACK
  Future<Map<String, dynamic>> insertOrderFeedback({
    required String userId,
    required String orderId,
    required String orderNumber,
    required bool isPositive,
    required bool isNegative,
    required String feedBackType,
    required String feedBackDetail,
  }) async {
    return await insertOrderFeedbackApi(
      userId: userId,
      orderId: orderId,
      orderNumber: orderNumber,
      isPositive: isPositive,
      isNegative: isNegative,
      feedBackType: feedBackType,
      feedBackDetail: feedBackDetail,
    );
  }


  /// UPDATE RIDER RATING ONLY
  Future<Map<String, dynamic>> updateRiderRating({
    required String riderId,
    required double riderRating,
  }) async {
    return await updateRiderRatingApi(
      riderId: riderId,
      riderRating: riderRating,
    );
  }

  /// UPDATE RIDER
  Future<Map<String, dynamic>> updateRider({
    required String riderId,
    String? riderName,
    String? riderPhone,
    String? riderCity,
    String? riderDetail,
    String? riderCompletedOrders,
    String? riderCancelledOrders,
    String? riderZoneId,
    double? riderRating,
    File? riderImage,
  }) async {
    return await updateRiderApi(
      riderId: riderId,
      riderName: riderName,
      riderPhone: riderPhone,
      riderCity: riderCity,
      riderDetail: riderDetail,
      riderCompletedOrders: riderCompletedOrders,
      riderCancelledOrders: riderCancelledOrders,
      riderZoneId: riderZoneId,
      riderRating: riderRating,
      riderImage: riderImage,
    );
  }

}