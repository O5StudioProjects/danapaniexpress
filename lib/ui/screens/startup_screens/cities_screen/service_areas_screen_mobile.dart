import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class ServiceAreasScreenMobile extends StatelessWidget {
  const ServiceAreasScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI(){
    var isStart = Get.arguments[IS_START] as bool;
    return Obx((){
      var serviceArea = Get.find<ServiceAreaController>();
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            _appBar(isStart),
            Expanded(
                child: SizedBox(
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: !isRightLang ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _availableServiceAreaHeading(),
                      ShowServiceAreaList(),
                      setHeight(24.0),

                    ],
                  ),
                )),
            _buttonSection(serviceArea,isStart),
          ],
        ),
      );
    });
  }


  Widget _appBar(isStart){
    return appBarCommon(
      title: AppLanguage.selectCityStr(appLanguage),
      isBackNavigation: isStart ? false : true,
    );
  }

  Widget _buttonSection(serviceArea,isStart){
    return Padding(
      padding: const EdgeInsets.only(left: MAIN_HORIZONTAL_PADDING, right: MAIN_HORIZONTAL_PADDING, bottom: 60.0),
      child:
      serviceArea.serviceAreaStatus.value == Status.LOADING
          ? loadingIndicator()
          : appMaterialButton(text: AppLanguage.confirmStr(appLanguage),
          isDisable: serviceArea.serviceArea.value.isEmpty ? true : false,
          onTap: () async {
            if(serviceArea.serviceArea.value.isEmpty){
              showSnackbar(title: AppLanguage.selectCityStr(appLanguage).toString(), message: AppLanguage.cityNotSelectedStr(appLanguage).toString());
              return;
            } else {
              await SharedPrefs.setServiceArea(serviceArea.serviceArea.value);
              if(isStart){
                serviceArea.onTapConfirm(serviceArea.serviceArea.value);
              } else {
                Get.back();
              }
            }

          }),
    );
  }

  Widget _availableServiceAreaHeading(){
    return Padding(
      padding: const EdgeInsets.only(left: MAIN_HORIZONTAL_PADDING, right: MAIN_HORIZONTAL_PADDING, top: 24.0, bottom: 12.0),
      child: appText(
          text: AppLanguage.availableServiceAreasStr(appLanguage),
          textStyle: headingTextStyle()),
    );
  }

}

