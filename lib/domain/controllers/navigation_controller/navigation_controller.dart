
import 'package:danapaniexpress/core/common_imports.dart';
import '../../../core/data_model_imports.dart';

class NavigationController extends GetxController{


  Future<void> gotoProductsScreen({required CategoryModel data, int subCategoryIndex = 0}) async {
    JumpTo.gotoProductsScreen(data: data, subCategoryIndex: subCategoryIndex);
  }

}