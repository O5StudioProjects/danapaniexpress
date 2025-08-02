import 'package:danapaniexpress/core/common_imports.dart';

import '../controllers/search_controller/search_controller.dart';

class SearchBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(SearchProductsController());
  }

}