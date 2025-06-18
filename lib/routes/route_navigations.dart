
import 'package:danapaniexpress/routes/route_names.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class JumpTo {

  static gotoHomeScreen(){
    Get.offAndToNamed(RouteNames.HomeScreenRoute);
  }

  // static gotoDownloadDbScreen({required String dbLink, required DownloadType downloadType, required bool isStart}){
  //   Get.toNamed(RouteNames.DbDownloadRoute, arguments: {
  //     DB_LINK: dbLink,
  //     DOWNLOAD_TYPE: downloadType,
  //     IS_START: isStart
  //   });
  // }

}