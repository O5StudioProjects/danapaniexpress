import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/data/models/address_model.dart';

import '../domain/controllers/product_controller/product_detail_controller.dart';

class JumpTo {
  static gotoHomeScreen() {
    Get.offAndToNamed(RouteNames.HomeScreenRoute);
  }

  static gotoNoInternetScreen({required bool isStart}) {
    Get.toNamed(RouteNames.NoInternetScreen,
    arguments: {IS_START: isStart}
    );
  }

  static gotoLanguageThemeScreen({
    required bool isNavigation,
    required bool isStart,
  }) {
    Get.offAndToNamed(
      RouteNames.LanguageThemeScreenRoute,
      arguments: {IS_NAVIGATION: isNavigation, IS_START: isStart},
    );
  }

  static gotoStartupMainScreen() {
    Get.offAndToNamed(RouteNames.StartupMainScreenRoute);
  }

  ///AUTH SCREENS
  static gotoSignInScreen() {
    Get.offAllNamed(RouteNames.SignInScreenRoute);
  }

  static gotoRegisterScreen() {
    Get.toNamed(RouteNames.RegisterScreenRoute);
  }

  static gotoForgotPasswordScreen() {
    Get.toNamed(RouteNames.ForgotPasswordScreenRoute);
  }

  ///DASHBOARD SCREEN AND PAGES SCREENS
  static gotoDashboardScreen() {
    Get.offAndToNamed(RouteNames.MainDashboardScreenRoute);
  }

  static gotoProductsScreen({
    required CategoryModel data,
    int subCategoryIndex = 0,
  }) {
    Get.toNamed(
      RouteNames.ProductsScreenRoute,
      arguments: {
        DATA_CATEGORY: data,
        SUB_CATEGORY_INDEX: subCategoryIndex,
      },
    );
  }

  static gotoOtherProductsScreen({
    required ProductsScreenType productScreenType
  }) {
    Get.toNamed(
      RouteNames.OtherProductsScreenRoute,
      arguments: {
        PRODUCT_SCREEN_TYPE: productScreenType
      },
    );
  }

  static gotoProductDetailScreen({
    required ProductsModel data,
  }) {
    Get.toNamed(
      RouteNames.ProductDetailScreenRoute,
      arguments: {DATA_PRODUCT: data},

    );
  }

  ///ACCOUNT SCREENS
  static gotoAccountInformationScreen() {
    Get.toNamed(RouteNames.AccountInformationScreenRoute);
  }
  static gotoAddressBookScreen() {
    Get.toNamed(RouteNames.AddressBookScreenRoute);
  }
  static gotoAddAddressScreen({required AddressModel? data, required CurdType curdType }) {
    Get.toNamed(RouteNames.AddAddressScreenRoute,
      arguments: {DATA_ADDRESS: data, DATA_CURD_TYPE: curdType},
    );
  }

  static gotoSettingsScreen() {
    Get.toNamed(RouteNames.SettingsScreenRoute);
  }

  static gotoLanguageScreen({
    required bool isNavigation,
    required bool isStart,
  }) {
    Get.toNamed(
      RouteNames.LanguageThemeScreenRoute,
      arguments: {IS_NAVIGATION: isNavigation, IS_START: isStart},
    );
  }

  static gotoPrivacyPolicyScreen() {
    Get.toNamed(RouteNames.PrivacyPolicyScreenRoute);
  }
  static gotoTermsConditionsScreen() {
    Get.toNamed(RouteNames.TermsConditionsScreenRoute);
  }
  static gotoReturnsRefundsScreen() {
    Get.toNamed(RouteNames.ReturnsRefundsScreenRoute);
  }

}
