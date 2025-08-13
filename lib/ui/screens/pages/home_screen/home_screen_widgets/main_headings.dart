import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/packages_import.dart';

class NotificationBar extends StatelessWidget {
  const NotificationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final home = Get.find<HomeController>();

    return Obx(() {
      final data = home.marqueeData.value;

      if (data == null || (data.marqueeDetailEnglish.isEmpty && data.marqueeDetailUrdu.isEmpty)) {
        return const SizedBox();
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: MAIN_VERTICAL_PADDING),
        child: GestureDetector(
          onTap: () {
            // Your notification dialog code here
            showCustomDialog(context, AppNotificationDialog(data: data));
          },
          child: SizedBox(
            width: size.width,
            child: isRightLang
                ? _buildMarqueeRow(
                title: marqueeTitleMultiLangText(data),
                detail: marqueeDetailMultiLangText(data),
                data: data
            )
                : _buildMarqueeRow(
                title: marqueeTitleMultiLangText(data),
                detail: marqueeDetailMultiLangText(data),
                data: data
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMarqueeRow({
    required String title,
    required String detail,
    required MarqueeModel data,
  }) {
    final content = '$title : $detail';

    return Padding(
      padding: EdgeInsets.only(
        left: isRightLang ? 0 : MAIN_HORIZONTAL_PADDING,
        right: isRightLang ? MAIN_HORIZONTAL_PADDING : 0,
        top: 8.0,
        bottom: 8.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment:
        isRightLang ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          if (!isRightLang)
            appIcon(
              iconType: IconType.ANIM,
              icon: AppAnims.animNotificationSkin(isDark),
              width: 24.0,
            ),
          if (!isRightLang) setWidth(8.0),
          Expanded(
            child: SizedBox(
              height: 24.0,
              child: Center(
                child: Marquee(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  text: content,
                  style: marqueeDynamicTextStyle(data: data), // Or pass data
                  scrollAxis: Axis.horizontal,
                  velocity: 50.0,
                  blankSpace: 20.0,
                  startPadding: 50.0,
                  showFadingOnlyWhenScrolling: true,
                  fadingEdgeStartFraction: 0.1,
                  fadingEdgeEndFraction: 0.1,
                  textDirection: setTextDirection(appLanguage),
                ),
              ),
            ),
          ),
          if (isRightLang) setWidth(8.0),
          if (isRightLang)
            appIcon(
              iconType: IconType.ANIM,
              icon: AppAnims.animNotificationSkin(isDark),
              width: 24.0,
            ),
        ],
      ),
    );
  }
}