import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class NavigationController extends GetxController{

  Future<void> gotoSignInScreen() async {
    JumpTo.gotoSignInScreen();
  }
  Future<void> gotoStartupMainScreen() async {
    JumpTo.gotoStartupMainScreen();
  }

  Future<void> gotoRegisterScreen() async {
    JumpTo.gotoRegisterScreen();
  }

  Future<void> gotoForgotPasswordScreen() async {
    JumpTo.gotoForgotPasswordScreen();
  }

  Future<void> gotoDashboardScreen() async {
    JumpTo.gotoDashboardScreen();
  }

  Future<void> gotoHomeScreen() async {
    JumpTo.gotoHomeScreen();
  }

  Future<void> gotoLanguageThemeScreen({required bool isNavigation, required bool isStart}) async {
    JumpTo.gotoLanguageThemeScreen(isNavigation: isNavigation, isStart: isStart);
  }

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