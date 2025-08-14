import 'package:danapaniexpress/core/common_imports.dart';


class ReturnsRefundsMobile extends StatelessWidget {
  const ReturnsRefundsMobile({super.key});


  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> _buildUI(),
    );
  }

  Widget _buildUI(){
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          appBarCommon(
            title: AppLanguage.returnsRefundsStr(appLanguage),
            isBackNavigation: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
              child: Column(
                crossAxisAlignment: isRightLang ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [

                  mainTitle(AppLanguage.returnsRefundsMainHeadingStr(appLanguage).toString()),

                  sectionTitle(AppLanguage.returnsRefundsSection1HeadingStr(appLanguage).toString()),
                  sectionBody(AppLanguage.returnsRefundsSection1DetailStr(appLanguage).toString()),

                  sectionTitle(AppLanguage.returnsRefundsSection2HeadingStr(appLanguage).toString()),
                  sectionBody(AppLanguage.returnsRefundsSection2DetailStr(appLanguage).toString()),

                  sectionTitle(AppLanguage.returnsRefundsSection3HeadingStr(appLanguage).toString()),
                  sectionBody(AppLanguage.returnsRefundsSection3DetailStr(appLanguage).toString()),

                  sectionTitle(AppLanguage.returnsRefundsSection4HeadingStr(appLanguage).toString()),
                  sectionBody(AppLanguage.returnsRefundsSection4DetailStr(appLanguage).toString()),

                  sectionTitle(AppLanguage.returnsRefundsSection5HeadingStr(appLanguage).toString()),
                  sectionBody(AppLanguage.returnsRefundsSection5DetailStr(appLanguage).toString()),

                  sectionTitle(AppLanguage.returnsRefundsSection6HeadingStr(appLanguage).toString()),
                  sectionBody(AppLanguage.returnsRefundsSection6DetailStr(appLanguage).toString()),

                  setHeight(MAIN_VERTICAL_PADDING)

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}
