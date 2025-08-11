import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/controllers/terms_conditions_controller/terms_conditions_controller.dart';

class TermsConditionsMobile extends StatelessWidget {
  const TermsConditionsMobile({super.key});

  bool get isUrdu => isRightLang;

  @override
  Widget build(BuildContext context) {
    var terms = Get.find<TermsConditionsController>();
    var nav = Get.find<NavigationController>();
    var isStart = Get.arguments[IS_START] as bool;
    return Obx(
      ()=> Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(
              title: AppLanguage.termsConditionsStr(appLanguage),
              isBackNavigation: isStart ? false : true,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
                child: Column(
                  crossAxisAlignment: isRightLang ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [

                    mainTitle(AppLanguage.termsConditionsMainHeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.termsConditionsMainDetailStr(appLanguage).toString()),

                    sectionTitle(AppLanguage.termsConditionsSection1HeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.termsConditionsSection1DetailStr(appLanguage).toString()),

                    sectionTitle(AppLanguage.termsConditionsSection2HeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.termsConditionsSection2DetailStr(appLanguage).toString()),

                    sectionTitle(AppLanguage.termsConditionsSection3HeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.termsConditionsSection3DetailStr(appLanguage).toString()),

                    sectionTitle(AppLanguage.termsConditionsSection4HeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.termsConditionsSection4DetailStr(appLanguage).toString()),

                    sectionTitle(AppLanguage.termsConditionsSection5HeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.termsConditionsSection5DetailStr(appLanguage).toString()),

                    sectionTitle(AppLanguage.termsConditionsSection6HeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.termsConditionsSection6DetailStr(appLanguage).toString()),

                    sectionTitle(AppLanguage.termsConditionsSection7HeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.termsConditionsSection7DetailStr(appLanguage).toString()),

                    sectionTitle(AppLanguage.termsConditionsSection8HeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.termsConditionsSection8DetailStr(appLanguage).toString()),

                    sectionTitle(AppLanguage.termsConditionsSection9HeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.termsConditionsSection9DetailStr(appLanguage).toString()),

                    sectionTitle(AppLanguage.termsConditionsSection10HeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.termsConditionsSection10DetailStr(appLanguage).toString()),

                    sectionTitle(AppLanguage.termsConditionsSection11HeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.termsConditionsSection11DetailStr(appLanguage).toString()),

                    sectionTitle(AppLanguage.termsConditionsSection12HeadingStr(appLanguage).toString()),
                    sectionBody(AppLanguage.termsConditionsSection12DetailStr(appLanguage).toString()),


                    setHeight(MAIN_VERTICAL_PADDING),
                    isStart
                    ? Column(
                      children: [
                        SizedBox(
                          width: size.width,
                          child: GestureDetector(
                            onTap: (){
                              terms.acceptTerms.value =  !terms.acceptTerms.value;
                            },
                            child: Row(
                              children: [
                                appIcon(iconType: IconType.SVG,
                                    icon: terms.acceptTerms.value ? icRadioButtonSelected :icRadioButton,
                                    color: AppColors.materialButtonSkin(isDark)),
                                setWidth(8.0),
                                Expanded(child: appText(text: AppLanguage.iHaveReadAndAcceptTermsOfServicesStr(appLanguage),
                                    maxLines: 2,
                                    textStyle: bodyTextStyle())),
                              ],
                            ),
                          ),
                        ),
                        setHeight(MAIN_VERTICAL_PADDING),
                        Row(
                          children: [
                            Expanded(child: appMaterialButton(text: AppLanguage.declineStr(appLanguage), onTap: (){
                             SystemNavigator.pop();
                            })),
                            setWidth(MAIN_HORIZONTAL_PADDING),
                            Expanded(
                                child:
                                    terms.acceptTermsStatus.value == Status.LOADING
                                ? loadingIndicator()
                                : appMaterialButton(text: AppLanguage.continueStr(appLanguage), isDisable: !terms.acceptTerms.value, onTap: () async {
                              if(terms.acceptTerms.value){
                                nav.gotoServiceAreasScreen(isStart: isStart);
                                terms.onTapContinue();
                              }
                            })),
                          ],
                        ),
                        setHeight(MAIN_VERTICAL_PADDING)
                      ],
                    )
                        : SizedBox.shrink()


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
