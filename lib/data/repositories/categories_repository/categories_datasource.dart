import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:http/http.dart' as http;

class CategoriesDatasource extends BaseRepository {

  /// GET CATEGORIES - API
  Future<List<CategoryModel>> getCategoriesDataApi() async {
    final uri = Uri.parse(APiEndpoints.getCategories);

    final response = await http.get(uri, headers: apiHeaders);
    final Map<String, dynamic> json = handleApiResponseAsMap(response);

    final List<dynamic> list = json['data'] ?? [];

    return list
        .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// category By ID - API
  Future<CategoryModel?> getCategoryByIDApi(String categoryId) async {
    final uri = Uri.parse('${APiEndpoints.getCategoryById}?category_id=$categoryId');

    final response = await http.get(uri, headers: apiHeaders);
    final data = handleApiResponseAsMap(response);

    // Safely extract the 'category' object from nested 'data'
    final categoryJson = data['data']?['category'];
    if (categoryJson == null) {
      throw Exception("Category not found in response");
    }

    return CategoryModel.fromJson(categoryJson as Map<String, dynamic>);
  }

}