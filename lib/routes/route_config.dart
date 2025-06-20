import 'package:danapaniexpress/entry/common_main.dart';
import 'package:danapaniexpress/routes/route_names.dart';
import 'package:danapaniexpress/ui/screens/splash_screen/splash_screen.dart';
import 'package:danapaniexpress/ui/screens/startup_screens/language_theme_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRouter {
  static final routes = [
    GetPage(name: RouteNames.SplashScreenRoute, page: () => const SplashScreen()),
    GetPage(name: RouteNames.LanguageThemeScreenRoute, page: () => const LanguageThemeScreen()),
   // GetPage(name: RouteNames.HomeScreenRoute, page: () => const HomeScreen(), binding: DashboardBinding()),


  ];
}