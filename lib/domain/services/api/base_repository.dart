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
      return handleApiResponseAsMap(response);
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
      return handleApiResponseAsMap(response);
    } catch (e) {
      return handleException(e as Exception);
    }
  }

  /// Decode and normalize POST/PUT response
  Map<String, dynamic> handleApiResponseAsMap(http.Response response) {
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

  List<dynamic> handleApiResponseAsList(http.Response response) {
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) {
        return decoded;
      } else {
        throw Exception('Expected a List but got ${decoded.runtimeType}');
      }
    } else {
      throw Exception('Server returned an error or empty response');
    }
  }


  /// Fallback for network or format exceptions
  Map<String, dynamic> handleException(Exception e) {

    if (e is http.ClientException || e.toString().contains('SocketException')) {
      return {
        'success': false,
        'message': 'No internet connection. Please check your network and try again.',
      };
    }

    return {
      'success': false,
      'message': 'Exception: $e',
    };
  }
}
