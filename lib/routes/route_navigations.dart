import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';


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

  ///STARTUP SCREEN
  static gotoServiceAreasScreen({required bool isStart}) {
    Get.toNamed(RouteNames.ServiceAreasScreenRoute,
      arguments: {IS_START: isStart},);
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
    required ProductModel data,
  }) {
    Get.toNamed(
      RouteNames.ProductDetailScreenRoute,
      arguments: {DATA_PRODUCT: data},

    );
  }
  ///CHECKOUT SCREENS
  static gotoCheckoutScreen() {
    Get.toNamed(RouteNames.CheckoutScreenRoute);
  }
  static gotoOrderedPlacedScreen({OrderModel? orderData}) {
    Get.offAndToNamed(RouteNames.OrderPlacedScreenRoute,
    arguments: {DATA_ORDER: orderData}
    );
  }

  static gotoOrdersScreen({int screenIndex = 0}) {
    Get.toNamed(RouteNames.OrdersScreenRoute,
        arguments: {ORDERS_INDEX: screenIndex}
    );
  }

  static gotoOrdersDetailScreen({required OrderModel orderModel}) {
    Get.toNamed(RouteNames.OrdersDetailScreenRoute,
        arguments: {DATA_ORDER: orderModel}
    );
  }
  static gotoOrdersFeedbackScreen({OrderModel? orderData}) {
    Get.toNamed(RouteNames.OrderFeedbackScreenRoute,
        arguments: {DATA_ORDER: orderData}
    );
  }
  static gotoOrdersFeedbackCompleteScreen({OrderModel? orderData}) {
    Get.offAndToNamed(RouteNames.OrderFeedbackCompletedScreenRoute,
        arguments: {DATA_ORDER: orderData}
    );
  }


  ///ACCOUNT SCREENS
  static gotoAccountInformationScreen() {
    Get.toNamed(RouteNames.AccountInformationScreenRoute);
  }
  static gotoAddressBookScreen({AddressScreenType addressScreenType = AddressScreenType.ADDRESSBOOK}) {
    Get.toNamed(RouteNames.AddressBookScreenRoute,
    arguments: {ADDRESS_SCREEN_TYPE: addressScreenType}
    );
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
  static gotoTermsConditionsScreen({required bool isStart,}) {
    Get.toNamed(RouteNames.TermsConditionsScreenRoute,
    arguments: {IS_START: isStart},
    );
  }
  static gotoReturnsRefundsScreen() {
    Get.toNamed(RouteNames.ReturnsRefundsScreenRoute);
  }

  /// SEARCH SCREEN
  static gotoSearchScreen() {
    Get.toNamed(RouteNames.SearchScreenRoute);
  }

}
