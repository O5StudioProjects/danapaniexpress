
import 'dart:convert';
import 'dart:io';

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

  /// GET ORDER BY ORDER NUMBER
  Future<OrderModel> getOrderByNumberApi(String orderNumber) async {
    final uri = Uri.parse('${APiEndpoints.getOrderByNumber}?order_number=$orderNumber');

    final response = await http.get(
      uri,
      headers: apiHeaders,
    );

    final decoded = handleApiResponseAsMap(response); // returns Map<String, dynamic>
    final Map<String, dynamic> orderMap = decoded['order'];

    return OrderModel.fromJson(orderMap);
  }

  /// UPDATE ORDER
  Future<Map<String, dynamic>> updateOrderApi({
    required String orderId,
    String? riderId,
    String? orderStatus,
  }) async {
    final uri = Uri.parse(APiEndpoints.updateOrder);

    final body = {
      'order_id': orderId,
      if (riderId != null && riderId.isNotEmpty) 'rider_id': riderId,
      if (orderStatus != null && orderStatus.isNotEmpty) 'order_status': orderStatus,
    };

    final response = await http.post(
      uri,
      headers: apiHeaders,
      body: jsonEncode(body),
    );

    return handleApiResponseAsMap(response); // returns Map<String, dynamic>
  }

  /// INSERT ORDER FEEDBACK
  Future<Map<String, dynamic>> insertOrderFeedbackApi({
    required String userId,
    required String orderId,
    required String orderNumber,
    required bool isPositive,
    required bool isNegative,
    required String feedBackType,
    required String feedBackDetail,
  }) async {
    final uri = Uri.parse(APiEndpoints.insertOrderFeedback);

    final body = {
      'user_id': userId,
      'order_id': orderId,
      'order_number': orderNumber,
      'is_positive': isPositive.toString(),
      'is_negative': isNegative.toString(),
      'feed_back_type': feedBackType,
      'feed_back_detail': feedBackDetail,
    };

    final response = await http.post(
      uri,
      headers: apiHeaders,
      body: jsonEncode(body),
    );

    return handleApiResponseAsMap(response); // returns Map<String, dynamic>
  }

  /// UPDATE RIDER RATING ONLY
  Future<Map<String, dynamic>> updateRiderRatingApi({
    required String riderId,
    required double riderRating,
  }) async {
    final uri = Uri.parse(APiEndpoints.updateRider);

    final jsonData = {
      "rider_id": riderId,
      "rider_rating": riderRating.toString(),
    };

    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll(apiHeaders!)
      ..fields['data'] = jsonEncode(jsonData);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return handleApiResponseAsMap(response);
  }

  /// UPDATE RIDER
  Future<Map<String, dynamic>> updateRiderApi({
    required String riderId,
    String? riderName,
    String? riderPhone,
    String? riderCity,
    String? riderDetail,
    String? riderCompletedOrders,
    String? riderCancelledOrders,
    String? riderZoneId,
    double? riderRating,
    File? riderImage, // For image upload
  }) async {
    final uri = Uri.parse(APiEndpoints.updateRider);

    // ✅ Prepare JSON data for text fields
    final jsonData = {
      "rider_id": riderId,
      if (riderName != null) "rider_name": riderName,
      if (riderPhone != null) "rider_phone": riderPhone,
      if (riderCity != null) "rider_city": riderCity,
      if (riderDetail != null) "rider_detail": riderDetail,
      if (riderCompletedOrders != null) "rider_completed_orders": riderCompletedOrders,
      if (riderCancelledOrders != null) "rider_cancelled_orders": riderCancelledOrders,
      if (riderZoneId != null) "rider_zone_id": riderZoneId,
      if (riderRating != null) "rider_rating": riderRating.toString(),
    };

    // ✅ Multipart request because of file upload
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(apiHeaders!)
      ..fields['data'] = jsonEncode(jsonData);

    // ✅ Attach image if available
    if (riderImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'rider_image',
        riderImage.path,
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return handleApiResponseAsMap(response); // returns Map<String, dynamic>
  }
}