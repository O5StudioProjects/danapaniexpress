import 'package:danapaniexpress/ui/screens/auth_screen/sign_in_screen/sign_in_screen.dart';
import 'package:danapaniexpress/ui/screens/splash_screen/splash_screen.dart';
import 'package:danapaniexpress/ui/screens/startup_screens/1_welocme_screen/welcome_screen.dart';
import 'package:danapaniexpress/ui/screens/startup_screens/2_fast_delivery_screen/fast_delivery_screen.dart';
import 'package:danapaniexpress/ui/screens/startup_screens/3_fresh_products_screen/fresh_products_screen.dart';
import 'package:danapaniexpress/ui/screens/startup_screens/5_trusted_by_families_screen/trusted_by_families_screen.dart';
import 'package:danapaniexpress/ui/screens/startup_screens/language_theme_screen.dart';
import 'package:danapaniexpress/core/common_imports.dart';

class AppRouter {
  static final routes = [
    GetPage(
      name: RouteNames.SplashScreenRoute,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: RouteNames.LanguageThemeScreenRoute,
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const LanguageThemeScreen(),
    ),
    GetPage(
      name: RouteNames.WelcomeStartupScreenRoute,
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const WelcomeScreen(),
    ),
    GetPage(
      name: RouteNames.FastDeliveryStartupScreenRoute,
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const FastDeliveryScreen(),
    ),
    GetPage(
      name: RouteNames.FreshProductsStartupScreenRoute,
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const FreshProductsScreen(),
    ),
    GetPage(
      name: RouteNames.TrustedByFamiliesStartupScreenRoute,
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const TrustedByFamiliesScreen(),
    ),

    GetPage(
      name: RouteNames.SignInScreenRoute,
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const SignInScreen(),
    ),

    // GetPage(name: RouteNames.HomeScreenRoute, page: () => const HomeScreen(), binding: DashboardBinding()),
  ];
}
