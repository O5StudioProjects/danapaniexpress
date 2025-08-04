import 'package:danapaniexpress/domain/di/account_binding.dart';
import 'package:danapaniexpress/domain/di/address_binding.dart';
import 'package:danapaniexpress/domain/di/auth_binding.dart';
import 'package:danapaniexpress/domain/di/checkout_binding.dart';
import 'package:danapaniexpress/domain/di/dashboard_binding.dart';
import 'package:danapaniexpress/domain/di/product_detail_binding.dart';
import 'package:danapaniexpress/domain/di/search_binding.dart';
import 'package:danapaniexpress/domain/di/service_area_binding.dart';
import 'package:danapaniexpress/domain/di/settings_binding.dart';
import 'package:danapaniexpress/domain/di/splash_binding.dart';
import 'package:danapaniexpress/ui/screens/main_dashboard_screen/main_dashboard_screen.dart';
import 'package:danapaniexpress/ui/screens/other_screens/no_internet_screen/no_internet_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/account/account_information/account_information_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/account/address_book/add_address/add_address_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/account/address_book/address_book_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/account/my_orders/my_orders_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/account/privacy_policy/privacy_policy_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/account/returns_redunds/returns_refunds_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/account/settings/settings_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/account/terms_conditions/terms_conditions_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/cart/order_placed_screen/order_placed_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/categories/other_products/other_products_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/categories/product_detail/product_detail_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/categories/products/products_screen.dart';
import 'package:danapaniexpress/ui/screens/search_screen/search_screen.dart';
import 'package:danapaniexpress/ui/screens/splash_screen/splash_screen.dart';
import 'package:danapaniexpress/ui/screens/startup_screens/cities_screen/service_areas_screen.dart';
import 'package:danapaniexpress/ui/screens/startup_screens/language_theme_screen.dart';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/ui/screens/startup_screens/startup_main_screen/startup_main_screen.dart';

import '../domain/di/add_address_binding.dart';
import '../domain/di/orders_binding.dart';
import '../ui/screens/auth_screen/forgot_password_screen/forgot_password_screen.dart';
import '../ui/screens/auth_screen/register_screen/register_screen.dart';
import '../ui/screens/pages/cart/checkout_screen/checkout_screen.dart';

class AppRouter {
  static final routes = [
    GetPage(
      name: RouteNames.SplashScreenRoute,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: RouteNames.NoInternetScreen,
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const NoInternetScreen(),
    ),
    GetPage(
      name: RouteNames.LanguageThemeScreenRoute,
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const LanguageThemeScreen(),
    ),

    /// STARTUP SCREENS
    GetPage(
      name: RouteNames.StartupMainScreenRoute,
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const StartupMainScreen(),
    ),
    GetPage(
      name: RouteNames.ServiceAreasScreenRoute,
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const ServiceAreasScreen(),
      binding: ServiceAreaBinding()
    ),

    /// AUTH SCREENS
    GetPage(
      name: RouteNames.SignInScreenRoute,
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const SignInScreen(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: RouteNames.RegisterScreenRoute,
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const RegisterScreen(),
    ),

    GetPage(
      name: RouteNames.ForgotPasswordScreenRoute,
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const ForgotPasswordScreen(),
    ),

    ///DASHBOARD SCREEN AND PAGES SCREENS
    GetPage(
      name: RouteNames.MainDashboardScreenRoute,
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const MainDashboardScreen(),
      binding: DashboardBinding(),
    ),

    GetPage(
      name: RouteNames.ProductsScreenRoute,
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const ProductsScreen(),
    ),

    GetPage(
      name: RouteNames.OtherProductsScreenRoute,
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const OtherProductsScreen(),
    ),

    GetPage(
      name: RouteNames.ProductDetailScreenRoute,
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const ProductDetailScreen(),
      binding: ProductDetailBinding(),
    ),

    /// CART SCREENS
    GetPage(
      name: RouteNames.CheckoutScreenRoute,
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const CheckoutScreen(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: RouteNames.OrderPlacedScreenRoute,
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const OrderPlacedScreen(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: RouteNames.OrdersScreenRoute,
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const MyOrdersScreen(),
      binding: OrdersBinding(),
    ),

    /// ACCOUNT SCREEN AND PAGES
    GetPage(
      name: RouteNames.AccountInformationScreenRoute,
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const AccountInformationScreen(),
      binding: AccountInfoBinding(),
    ),

    GetPage(
      name: RouteNames.AddressBookScreenRoute,
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const AddressBookScreen(),
      binding: AddressBinding(),
    ),

    GetPage(
      name: RouteNames.AddAddressScreenRoute,
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const AddAddressScreen(),
      binding: AddAddressBinding(),
    ),

    GetPage(
      name: RouteNames.SettingsScreenRoute,
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: RouteNames.PrivacyPolicyScreenRoute,
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const PrivacyPolicyScreen(),
      // binding: AddAddressBinding(),
    ),
    GetPage(
      name: RouteNames.TermsConditionsScreenRoute,
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const TermsConditionsScreen(),
      // binding: AddAddressBinding(),
    ),
    GetPage(
      name: RouteNames.ReturnsRefundsScreenRoute,
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const ReturnsRefundsScreen(),
      // binding: AddAddressBinding(),
    ),

    ///SEARCH SCREEN
    GetPage(
      name: RouteNames.SearchScreenRoute,
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const SearchScreen(),
      binding: SearchBinding(),
    ),

  ];
}
