// lib/repositories/base_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class BaseRepository {
  /// Common GET request handler
  Future<Map<String, dynamic>> getRequest(
      Uri url, {
        required Map<String, String> headers,
      }) async {
    try {
      final response = await http.get(url, headers: headers);
      return handleGetResponse(response);
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  /// Common POST request handler
  Future<Map<String, dynamic>> postRequest(Uri url, {
    required Map<String, String>? headers,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      return handleApiResponse(response);
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  /// Decode and normalize POST/PUT response
  Map<String, dynamic> handleApiResponse(http.Response response) {
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
    if (response.body.isNotEmpty) {
      final data = jsonDecode(response.body);
      data['success'] = response.statusCode == 200;
      return data;
    } else {
      return {'success': false, 'message': 'Empty response from server'};
    }
  }

  /// Decode and normalize GET response
  Map<String, dynamic> handleGetResponse(http.Response response) {
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
    if (response.body.isNotEmpty) {
      final data = jsonDecode(response.body);
      data['success'] = response.statusCode == 200;
      return data;
    } else {
      return {'success': false, 'message': 'Empty response from server'};
    }
  }

  /// Fallback for network or format exceptions
  Map<String, dynamic> handleException(Exception e) {
    return {
      'success': false,
      'message': 'Exception: $e',
    };
  }
}
