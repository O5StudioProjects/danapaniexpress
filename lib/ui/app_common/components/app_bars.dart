import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/packages_import.dart';

Widget appSliverAppbarHome() {
  final controller = Get.find<DashBoardController>();

  return Obx(
    () => SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      elevation: 0,
      // automaticallyImplyLeading: false,
      expandedHeight: size.height * 0.200,
      floating: true,
      pinned: false,
      backgroundColor: AppColors.backgroundColorSkin(isDark),
      flexibleSpace: FlexibleSpaceBar(
        // collapseMode: CollapseMode.pin,
        background: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              CarouselSlider(
                items: controller.appbarPagerList.map((slider) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                          onTap: () => controller.onTapAppbarImagePager(index: controller.appbarPagerList.indexOf(slider)),
                          child: appAsyncImage(slider.imageUrl, width: size.width));
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  viewportFraction: 1.0,
                  height: size.height,
                  autoPlayInterval: Duration(seconds: 5),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  scrollDirection: Axis.horizontal,
                ),
              ),

              // // semi-transparent overlay
              // Container(
              //   width: size.width,
              //   color: Colors.black.withValues(alpha: 0.2),
              // ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 24.0,
                  right: 24.0,
                  bottom: 24.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.find<ThemeController>().changeTheme();
                        },
                        child: Container(
                          padding: EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: AppColors.floatingButtonSkin(isDark),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: appIcon(iconType: IconType.ICON, icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: whiteColor),
                        ),
                      ),
                    ),
                    setHeight(5.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          if(appLanguage == ENGLISH_LANGUAGE) {
                            Get.find<ThemeController>().changeLanguage(language: URDU_LANGUAGE);
                          } else {
                            Get.find<ThemeController>().changeLanguage(language: ENGLISH_LANGUAGE);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: AppColors.floatingButtonSkin(isDark),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: appIcon(iconType: IconType.ICON, icon: Icons.language, color: whiteColor),
                        ),
                      ),
                    ),
                    setHeight(5.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                        },
                        child: Container(
                          padding: EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: AppColors.floatingButtonSkin(isDark),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: appSvgIcon(
                            icon: icSearch,
                            width: 20.0,
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget appBarCommon({title, isBackNavigation = false}) {
  return Container(
    width: size.width,
    height: 80,
    decoration: BoxDecoration(color: AppColors.appBarColorSkin(isDark)),
    child: Padding(
      padding: const EdgeInsets.only(
        left: MAIN_HORIZONTAL_PADDING,
        right: MAIN_HORIZONTAL_PADDING,
        bottom: 8.0,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isBackNavigation
                ? GestureDetector(
                    onTap: () async {
                      // Navigator.pop(context);
                      // NavigationBlocHelper.instance.clearTextControllersEvent();
                      // SearchBlocHelper.instance.clearSearchFilterEvent();
                      // ThemeBlocHelper.instance.selectIconEvent(iconSelection: IconSelection.NULL);
                      // Navigator.pop(context);
                      // context.read(context).pop()<HomeBloc>().add(ClearContentFilterEvent());
                    },
                    child: appSvgIcon(
                      icon: icArrowLeft,
                      color: AppColors.primaryTextColorSkin(isDark),
                      width: 24.0,
                    ),
                  )
                : const SizedBox(width: 24.0),
            setWidth(12.0),
            Expanded(
              child: appText(
                text: title,
                textAlign: TextAlign.center,
                textStyle: appBarTextStyle(),
              ),
            ),
            setWidth(12.0),
            const SizedBox(width: 24.0),
          ],
        ),
      ),
    ),
  );
}

