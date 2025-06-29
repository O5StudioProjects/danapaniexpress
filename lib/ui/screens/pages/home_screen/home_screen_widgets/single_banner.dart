import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class SingleBanner extends StatelessWidget {
  final HomeSingleBanner homeSingleBanner;
  const SingleBanner({super.key, required this.homeSingleBanner});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<DashBoardController>();
    return Obx((){
      var banner = homeSingleBanner == HomeSingleBanner.ONE ? controller.singleBannerOne.value : controller.singleBannerTwo.value;
      if(banner != null){
        return Padding(
          padding: const EdgeInsets.only(bottom: MAIN_VERTICAL_PADDING),
          child: Container(
            width: size.width,
            height: size.height * 0.2,
            color: AppColors.backgroundColorSkin(isDark),
            child: appAsyncImage(banner.imageUrl, boxFit: BoxFit.cover),
          ),
        );
      } else {
        return SizedBox();
      }
    });
  }
}
