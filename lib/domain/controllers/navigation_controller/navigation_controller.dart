
import 'package:danapaniexpress/core/common_imports.dart';
import '../../../core/data_model_imports.dart';

class NavigationController extends GetxController{


  Future<void> gotoProductsScreen({required CategoryModel data, int subCategoryIndex = 0}) async {
    JumpTo.gotoProductsScreen(data: data, subCategoryIndex: subCategoryIndex);
  }

  Future<void> gotoOtherProductsScreen({required ProductsScreenType screenType}) async {
    JumpTo.gotoOtherProductsScreen(productScreenType: screenType);
  }


  Future<void> gotoProductDetailScreen({required ProductsModel data}) async {
    JumpTo.gotoProductDetailScreen(data: data);
  }

}