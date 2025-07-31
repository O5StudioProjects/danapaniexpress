
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:http/http.dart' as http;

class CheckoutDatasource extends BaseRepository{

  /// GET DELIVERY DAYS WITH SLOTS (7 DAYS)
  Future<Map<String, dynamic>> getDeliveryDaysWithSlotsApi() async {
    final uri = Uri.parse(APiEndpoints.getDeliveryDaysAndSlots);

    final response = await http.get(
      uri,
      headers: apiHeaders,
    );

    return handleApiResponseAsMap(response);
  }

}