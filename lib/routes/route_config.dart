import 'package:danapaniexpress/domain/di/auth_binding.dart';
import 'package:danapaniexpress/domain/di/dashboard_binding.dart';
import 'package:danapaniexpress/domain/di/product_detail_binding.dart';
import 'package:danapaniexpress/domain/di/splash_binding.dart';
import 'package:danapaniexpress/ui/screens/main_dashboard_screen/main_dashboard_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/account/account_information/account_information_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/account/address_book/add_address/add_address_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/account/address_book/address_book_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/categories/other_products/other_products_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/categories/product_detail/product_detail_screen.dart';
import 'package:danapaniexpress/ui/screens/pages/categories/products/products_screen.dart';
import 'package:danapaniexpress/ui/screens/splash_screen/splash_screen.dart';
import 'package:danapaniexpress/ui/screens/startup_screens/language_theme_screen.dart';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/ui/screens/startup_screens/startup_main_screen/startup_main_screen.dart';

import '../ui/screens/auth_screen/forgot_password_screen/forgot_password_screen.dart';
import '../ui/screens/auth_screen/register_screen/register_screen.dart';

class AppRouter {
  static final routes = [
    GetPage(
      name: RouteNames.SplashScreenRoute,
      page: () => const SplashScreen(),
        binding: SplashBinding()
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

    /// AUTH SCREENS
    GetPage(
      name: RouteNames.SignInScreenRoute,
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const SignInScreen(),
      binding:  AuthBinding()
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
      binding: DashboardBinding()
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
        binding:  ProductDetailBinding()

    ),

    /// ACCOUNT SCREEN AND PAGES
    GetPage(
        name: RouteNames.AccountInformationScreenRoute,
        transition: Transition.fadeIn,
        transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
        page: () => const AccountInformationScreen(),
    ),

    GetPage(
      name: RouteNames.AddressBookScreenRoute,
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const AddressBookScreen(),
    ),
    GetPage(
      name: RouteNames.AddAddressScreenRoute,
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const AddAddressScreen(),
    ),
    // GetPage(name: RouteNames.HomeScreenRoute, page: () => const HomeScreen(), binding: DashboardBinding()),
  ];
}
