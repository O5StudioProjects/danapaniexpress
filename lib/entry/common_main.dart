import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/packages_import.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/di/auth_binding.dart';

Future<void> commonMain() async {

  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Status bar color
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark, // Light icons for status bar
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // Permanent singleton setup
    final themeController = Get.put(ThemeController(), permanent: true);
    Get.put(NavigationController(), permanent: true);
    Get.put<AuthRepository>(AuthRepository(), permanent: true);
    Get.put<AuthController>(AuthController(authRepo: Get.find()), permanent: true);

    final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
    Connectivity connectivity = Connectivity();
    connectivity.onConnectivityChanged.listen((event) async {
      themeController.updateInternetConnection(event: event);
    });
    print('Internet Connection : ${themeController.internet}');

    return Obx(
      ()=> GetMaterialApp(
        navigatorKey: GlobalContextService.navigatorKey,
        scaffoldMessengerKey: scaffoldKey,
        debugShowCheckedModeBanner: false,
        title: EnvStrings.appNameEng,
        theme: Styles.themeData(themeController.isDark.value, themeController.appLanguage.value, context),
        getPages: AppRouter.routes,
        initialBinding: AuthBinding(),
        initialRoute: RouteNames.SplashScreenRoute,
      ),
    );
  }
}
