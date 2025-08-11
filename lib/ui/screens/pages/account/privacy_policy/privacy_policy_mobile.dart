import 'package:danapaniexpress/core/common_imports.dart';

class PrivacyPolicyMobile extends StatelessWidget {
  const PrivacyPolicyMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(
              title: AppLanguage.privacyPolicyStr(appLanguage),
              isBackNavigation: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
                child: Column(
                  crossAxisAlignment: isRightLang ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    mainTitle(AppLanguage.privacyMainHeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.privacyMainDetailStr(appLanguage).toString()),

                    sectionTitle(AppLanguage.privacySection1HeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.privacySection1DetailStr(appLanguage).toString()),

                    sectionTitle(AppLanguage.privacySection2HeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.privacySection2DetailStr(appLanguage).toString()),

                    sectionTitle(AppLanguage.privacySection3HeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.privacySection3DetailStr(appLanguage).toString()),

                    sectionTitle(AppLanguage.privacySection4HeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.privacySection4DetailStr(appLanguage).toString()),

                    sectionTitle(AppLanguage.privacySection5HeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.privacySection5DetailStr(appLanguage).toString()),

                    sectionTitle(AppLanguage.privacySection6HeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.privacySection6DetailStr(appLanguage).toString()),

                    sectionTitle(AppLanguage.privacySection7HeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.privacySection7DetailStr(appLanguage).toString()),

                    sectionTitle(AppLanguage.privacySection8HeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.privacySection8DetailStr(appLanguage).toString()),


                    setHeight(MAIN_VERTICAL_PADDING)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
