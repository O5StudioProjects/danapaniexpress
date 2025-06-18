import 'package:danapaniexpress/entry/common_main.dart';
import 'package:danapaniexpress/routes/route_names.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRouter {
  static final routes = [
    GetPage(name: RouteNames.SplashScreenRoute, page: () => const HomeTest()),
   // GetPage(name: RouteNames.HomeScreenRoute, page: () => const HomeScreen(), binding: DashboardBinding()),


  ];
}