import 'package:danapaniexpress/core/common_imports.dart';
import 'package:http/http.dart' as http;

import '../../../core/data_model_imports.dart';

class DashboardDataSource extends BaseRepository {

  /// IMAGE PAGERS - API
  Future<List<PagerImagesModel>> getPagerDataApi(String pagerSection) async {
    final uri = Uri.parse('${APiEndpoints.getPagerData}?pager_section=$pagerSection');

    final response = await http.get(uri, headers: apiHeaders);
    final decoded = handleApiResponseAsList(response); // This returns List<dynamic>

    return decoded
        .map((item) => PagerImagesModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// GET MARQUEE - API
  Future<MarqueeModel> getMarqueeApi() async {
    final uri = Uri.parse(APiEndpoints.getMarquee);
    final response = await http.get(uri, headers: apiHeaders);

    final data = handleApiResponseAsMap(response);

    // If response is a direct object
    return MarqueeModel.fromJson(data);
  }

  /// GET COVER IMAGES - API
  Future<CoverImagesModel> getCoverImagesApi() async {
    final uri = Uri.parse(APiEndpoints.getCoverImages); // e.g. https://yourapi.com/get_cover_images.php

    final response = await http.get(uri, headers: apiHeaders);

    final data = handleApiResponseAsMap(response); // Already decodes and checks success

    return CoverImagesModel.fromJson(data);
  }

}