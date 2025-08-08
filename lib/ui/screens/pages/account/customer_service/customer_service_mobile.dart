import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:marquee/marquee.dart';

class CustomerServiceMobile extends StatelessWidget {
  const CustomerServiceMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = Get.find<AuthController>();
    var nav = Get.find<NavigationController>();
    return Obx((){
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(
              title: AppLanguage.customerServiceStr(appLanguage),
              isBackNavigation: true,
            ),
            Expanded(child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  welcomePart(),
                  marqueeSection(),

                  /// CUSTOM ORDER SECTION
                  auth.currentUser.value!.userId != null
                  ? bodyItemSection(
                    heading: AppLanguage.customOrdersStr(appLanguage),
                    detail: AppLanguage.customOrderInfoStr(appLanguage),
                    buttonText: AppLanguage.customOrdersStr(appLanguage),
                      onTap: () async => nav.launchWhatsApp(phone: ContactUs.CustomOrders)
                  )
                  : SizedBox.shrink(),

                  /// COMPLAINTS AND QUERIES SECTION
                  bodyItemSection(
                      heading: AppLanguage.complaintsQueriesStr(appLanguage),
                      detail: AppLanguage.complaintsDescriptionStr(appLanguage),
                      buttonText: AppLanguage.customerServiceStr(appLanguage),
                      onTap: () async => nav.launchWhatsApp(phone: ContactUs.CustomerService)
                  ),
                  setHeight(MAIN_VERTICAL_PADDING)
                ],
              ),
            ))

          ],
        ),
      );
    });
  }
}

Widget welcomePart() {
  return Padding(
    padding: const EdgeInsets.only(
      top: MAIN_VERTICAL_PADDING,
      left: MAIN_HORIZONTAL_PADDING,
      right: MAIN_HORIZONTAL_PADDING,
    ),
    child: appText(
      text:
          '${AppLanguage.welcomeToAppNameStr(appLanguage)} ${AppLanguage.customerServiceStr(appLanguage)}',
      textAlign: TextAlign.center,
      textStyle: bigBoldHeadingTextStyle().copyWith(
        fontSize: SECONDARY_HEADING_FONT_SIZE,
      ),
    ),
  );
}

Widget bodyItemSection({heading, detail, buttonText, onTap}) {
  return Padding(
    padding: const EdgeInsets.only(
      top: MAIN_VERTICAL_PADDING,
      left: MAIN_HORIZONTAL_PADDING,
      right: MAIN_HORIZONTAL_PADDING,
    ),
    child: SizedBox(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appText(text: heading, textStyle: headingTextStyle()),
          setHeight(MAIN_HORIZONTAL_PADDING),
          appText(text: detail, textStyle: bodyTextStyle()),
          setHeight(MAIN_HORIZONTAL_PADDING),
          appMaterialButton(text: buttonText, onTap: onTap),
        ],
      ),
    ),
  );
}

Widget marqueeSection(){
  return Padding(
    padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING, top: MAIN_HORIZONTAL_PADDING),
    child: GestureDetector(
      onTap: ()=> Get.find<NavigationController>().launchWhatsApp(phone: ContactUs.CustomerService),
      child: SizedBox(
        width: size.width,
        child: isRightLang
            ? _buildMarqueeRow(
            isUrdu: true,
            title: setMultiLanguageText(
              language: appLanguage,
              urdu: '${AppLanguage.customerServiceStr(appLanguage)} : ',
              english: '${AppLanguage.customerServiceStr(appLanguage)} : ',
            ),
            detail: setMultiLanguageText(
              language: appLanguage,
              urdu: ' ہم صبح 7:00 بجے سے رات 9:00 بجے تک آپ کی مدد کے لیے دستیاب ہیں۔ ',
              english: ' We are available to assist you from 7:00 AM to 9:00 PM. ',
            ),
        )
            : _buildMarqueeRow(
            isUrdu: false,
            title: setMultiLanguageText(
              language: appLanguage,
              urdu: '${AppLanguage.customerServiceStr(appLanguage)} : ',
              english: '${AppLanguage.customerServiceStr(appLanguage)} : ',
            ),
            detail: setMultiLanguageText(
              language: appLanguage,
              urdu: ' ہم صبح 7:00 بجے سے رات 9:00 بجے تک آپ کی مدد کے لیے دستیاب ہیں۔ ',
              english: ' We are available to assist you from 7:00 AM to 9:00 PM. ',
            ),
        ),
      ),
    ),
  );
}



Widget _buildMarqueeRow({
  required bool isUrdu,
  required String title,
  required String detail,
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
            iconType: IconType.PNG,
            icon: icAdmins,
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
                style: marqueeTextStyle(),
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
            iconType: IconType.PNG,
            icon: icAdmins,
            width: 24.0,
          ),
      ],
    ),
  );
}