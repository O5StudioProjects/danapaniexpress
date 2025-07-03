import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/packages_import.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BodyImagePager extends StatelessWidget {
  const BodyImagePager({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<DashBoardController>();
    return Obx((){
      if(controller.bodyPagerList.isNotEmpty){
        return Padding(
          padding: EdgeInsets.only(
            right: MAIN_HORIZONTAL_PADDING,
            left: MAIN_HORIZONTAL_PADDING,
            bottom: MAIN_VERTICAL_PADDING,
          ),
          child: Stack(
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.cardColorSkin(isDark),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                width: size.width,
                height: size.height * 0.15,
                child: CarouselSlider(
                  items: controller.bodyPagerList.map((slider) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                            onTap: () => controller.onTapBodyPager(index: controller.bodyPagerList.indexOf(slider)),
                            child: appAsyncImage(slider.imageUrl, width: size.width));
                      },
                    );
                  }).toList(),
                  carouselController: controller.bodyPagerController,
                  options: CarouselOptions(
                    autoPlay: true,
                    viewportFraction: 1.0,
                    height: size.height,
                    autoPlayInterval: Duration(seconds: 5),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason){
                      controller.currentSlide.value = index;
                    }
                  ),
                ),
              ),
              /// Smooth Page Indicator
              Positioned(
                bottom: 8,
                right: 0,
                left: 0,
                child: Obx(() => Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedSmoothIndicator(
                    activeIndex: controller.currentSlide.value,
                    count: controller.bodyPagerList.length,
                    effect: WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: AppColors.materialButtonSkin(isDark),
                      dotColor: Colors.grey.shade400,
                    ),
                  ),
                )),
              ),
            ],
          )


        );
      }
      else {
        return SizedBox();
      }
    });
  }
}
