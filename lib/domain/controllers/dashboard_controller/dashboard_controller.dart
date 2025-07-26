import 'dart:async';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/packages_import.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/ui/app_common/dialogs/bool_dialog.dart';

class DashBoardController extends GetxController {
  final dashboardRepo = DashboardRepository();
  final productRepo = ProductDetailRepository();
  final home = Get.find<HomeController>();
  final navigation = Get.find<NavigationController>();
  final categories = Get.find<CategoriesController>();

  // Bottom nav
  RxInt navIndex = 0.obs;

  /// FLOATING DYNAMIC AVATARS/ICONS
  RxBool floatingAvatarIcon = true.obs;



  // Init
  @override
  void onInit() {
    super.onInit();
    navIndex.value = 0;
    startupMethods();

  }

  void startupMethods() async {

  }

  // Bottom nav change
  void onBottomNavItemTap(int index) {
    navIndex.value = index;
  }



  ///ON BACK PRESS MAIN DASHBOARD

  Future<void> onDashboardBackPress() async {
    if(navIndex.value > 0){
      navIndex.value = 0;
    } else {
      showCustomDialog(gContext, AppBoolDialog(
        title: AppLanguage.quitStr(appLanguage).toString(),
        detail: AppLanguage.doYouWantToCloseAppStr(appLanguage).toString(),
        onTapConfirm: (){
        SystemNavigator.pop();
      }, iconType: IconType.ICON, icon: Icons.exit_to_app_rounded,));
    }
  }

  Future<void> onTapTopNotificationDialog(MarqueeModel data) async {
    if (data.marqueeType == MarqueeType.FEATURED) {
      navigation.gotoOtherProductsScreen(
        screenType: ProductsScreenType.FEATURED,
      );
    } else if (data.marqueeType == MarqueeType.FLASH_SALE) {
      navigation.gotoOtherProductsScreen(
        screenType: ProductsScreenType.FLASHSALE,
      );
    } else if (data.marqueeType == MarqueeType.POPULAR) {
      navigation.gotoOtherProductsScreen(
        screenType: ProductsScreenType.POPULAR,
      );
    }
  }



}
