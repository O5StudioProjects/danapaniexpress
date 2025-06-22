import 'package:danapaniexpress/ui/screens/auth_screen/sign_in_screen/sign_in_screen.dart';
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
    ),
    GetPage(
      name: RouteNames.LanguageThemeScreenRoute,
      transition: Transition.downToUp,
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
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: SCREEN_ANIMATION_DURATION),
      page: () => const SignInScreen(),
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


    // GetPage(name: RouteNames.HomeScreenRoute, page: () => const HomeScreen(), binding: DashboardBinding()),
  ];
}
