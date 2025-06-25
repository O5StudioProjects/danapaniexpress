import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/packages_import.dart';

import '../../../../../data/models/notification_model.dart';

class NotificationBar extends StatelessWidget {
  const NotificationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashBoardController>();

    return Obx(() {
      final data = controller.marqueeNotification;

      if (data == null ||
          (data.notificationDetailEnglish.isEmpty &&
              data.notificationDetailUrdu.isEmpty)) {
        return const SizedBox();
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: GestureDetector(
          onTap: () {
            // Your notification dialog code here
          },
          child: SizedBox(
            width: size.width,
            child: appLanguage == URDU_LANGUAGE
                ? _buildMarqueeRow(
              isUrdu: true,
              title: setMultiLanguageText(
                language: appLanguage,
                urdu: data.notificationTitleUrdu,
                english: data.notificationTitleEnglish,
              ),
              detail: setMultiLanguageText(
                language: appLanguage,
                urdu: data.notificationDetailUrdu,
                english: data.notificationDetailEnglish,
              ),
              data: data
            )
                : _buildMarqueeRow(
              isUrdu: false,
              title: setMultiLanguageText(
                language: appLanguage,
                urdu: data.notificationTitleUrdu,
                english: data.notificationTitleEnglish,
              ),
              detail: setMultiLanguageText(
                language: appLanguage,
                urdu: data.notificationDetailUrdu,
                english: data.notificationDetailEnglish,
              ),
              data: data
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMarqueeRow({
    required bool isUrdu,
    required String title,
    required String detail,
    required NotificationModel data,
  }) {
    final content = '$title : $detail';

    return Padding(
      padding: EdgeInsets.only(
        left: isUrdu ? 0 : MAIN_HORIZONTAL_PADDING,
        right: isUrdu ? MAIN_HORIZONTAL_PADDING : 0,
        top: 8.0,
        bottom: 8.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment:
        isUrdu ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          if (!isUrdu)
            appIcon(
              iconType: IconType.ANIM,
              icon: AppAnims.animNotificationSkin(isDark),
              width: 24.0,
            ),
          if (!isUrdu) setWidth(8.0),
          Expanded(
            child: SizedBox(
              height: 24.0,
              child: Center(
                child: Marquee(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  text: content,
                  style: marqueeTextStyle(data: data), // Or pass data
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
          if (isUrdu) setWidth(8.0),
          if (isUrdu)
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

