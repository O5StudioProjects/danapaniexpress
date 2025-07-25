import 'package:danapaniexpress/core/common_imports.dart';
import 'package:http/http.dart' as http;

import '../../../core/data_model_imports.dart';

class DashboardDataSource extends BaseRepository {



  /// GET POPULAR PRODUCTS - API
  Future<Map<String, dynamic>> getPopularProductsPaginatedApi({int page = 1, int limit = 10}) async {
    final uri = Uri.parse("${APiEndpoints.getPopularProducts}?page=$page&limit=$limit");
    final response = await http.get(uri, headers: apiHeaders);

    return handleApiResponseAsMap(response); // returns the full object
  }



}