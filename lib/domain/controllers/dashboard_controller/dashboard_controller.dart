

import 'package:danapaniexpress/core/common_imports.dart';

class DashBoardController extends GetxController {

  RxInt navIndex = 0.obs;

  onBottomNavItemTap(index){
    navIndex.value = index;
  }

}