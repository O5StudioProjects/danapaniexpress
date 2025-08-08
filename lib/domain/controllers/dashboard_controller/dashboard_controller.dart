import 'dart:async';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/packages_import.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/ui/app_common/dialogs/bool_dialog.dart';

class DashBoardController extends GetxController {
  final dashboardRepo = DashboardRepository();
  final productRepo = ProductDetailRepository();
  final navigation = Get.find<NavigationController>();
  final favorite = Get.put(FavoritesController());

  // Bottom nav
  RxInt navIndex = 0.obs;

  /// FLOATING DYNAMIC AVATARS/ICONS
  RxBool floatingIcon = true.obs;



  // Init
  @override
  void onInit() {
    super.onInit();
    navIndex.value = 0;
    getFloatingIcon();
  }

  Future<void> getFloatingIcon() async {
    floatingIcon.value = await SharedPrefs.getFloatingIcon();
  }

  void startupMethods() async {
  }

  // Bottom nav change
  void onBottomNavItemTap(int index) {
    navIndex.value = index;
    favorite.searchFavoriteTextController.value.clear();
    favorite.searchQuery.value = '';
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




}
